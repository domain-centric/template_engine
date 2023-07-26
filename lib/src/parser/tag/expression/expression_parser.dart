import 'package:petitparser/petitparser.dart';
import 'package:template_engine/template_engine.dart';

Parser<Expression> expressionParser(ParserContext parserContext,
    {bool verboseErrors = false}) {
  final builder = ExpressionBuilder2<Expression>();
  builder.primitive(
    ChoiceParser([
      ...dataTypeParsers(parserContext.engine.dataTypes),
      functionsParser(
          context: parserContext,
          loopback: builder.loopback,
          verboseErrors: verboseErrors),
      constantParser(parserContext.engine.constants),
      variableParser(parserContext.template),
    ], failureJoiner: selectFarthestJoined),
  );

  builder.addOperators(parserContext);

  var parser = builder.build();
  return parser;
}

/// A builder that allows the simple definition of expression grammars with
/// prefix, postfix, and left- and right-associative infix operators.
///
/// The following code creates the empty expression builder producing values of
/// type [num]:
///
///     final builder = ExpressionBuilder<num>();
///
/// Every [ExpressionBuilder] needs to define at least one primitive type to
/// parse. In this example these are the literal numbers. The mapping function
/// converts the string input into an actual number.
///
///     builder.primitive(digit()
///         .plus()
///         .seq(char('.').seq(digit().plus()).optional())
///         .flatten()
///         .trim()
///         .map(num.parse));
///
/// Then we define the operator-groups in descending precedence. The highest
/// precedence have parentheses. The mapping function receives both the opening
/// parenthesis, the value, and the closing parenthesis as arguments:
///
///     builder.group().wrapper(
///         char('(').trim(), char(')').trim(), (left, value, right) => value);
///
/// Then come the normal arithmetic operators. We are using [cascade
/// notation](https://dart.dev/guides/language/language-tour#cascade-notation)
/// to define multiple operators on the same precedence-group. The mapping
/// functions receive both, the terms and the parsed operator in the order they
/// appear in the parsed input:
///
///     // Negation is a prefix operator.
///     builder.group().prefix(char('-').trim(), (operator, value) => -value);
///
///     // Power is right-associative.
///     builder.group().right(char('^').trim(), (left, operator, right) => math.pow(left, right));
///
///     // Multiplication and addition are left-associative, multiplication has
///     // higher priority than addition.
///     builder.group()
///       ..left(char('*').trim(), (left, operator, right) => left * right)
///       ..left(char('/').trim(), (left, operator, right) => left / right);
///     builder.group()
///       ..left(char('+').trim(), (left, operator, right) => left + right)
///       ..left(char('-').trim(), (left, operator, right) => left - right);
///
/// Finally we can build the parser:
///
///     final parser = builder.build();
///
/// After executing the above code we get an efficient parser that correctly
/// evaluates expressions like:
///
///     parser.parse('-8');      // -8
///     parser.parse('1+2*3');   // 7
///     parser.parse('1*2+3');   // 5
///     parser.parse('8/4/2');   // 2
///     parser.parse('2^2^3');   // 256
///
class ExpressionBuilder2<T> {
  final List<Parser<T>> _primitives = [];
  final List<ExpressionGroup2<T>> _groups = [];
  final SettableParser<T> loopback = undefined();

  /// Defines a new primitive, literal, or value [parser].
  void primitive(Parser<T> parser) => _primitives.add(parser);

  /// Creates a new group of operators that share the same priority.
  ExpressionGroup2<T> group() {
    final group = ExpressionGroup2<T>(loopback);
    _groups.add(group);
    return group;
  }

  /// Builds the expression parser.
  Parser<T> build() {
    final primitives = <Parser<T>>[
      ..._primitives,
      ..._groups.expand((group) => group.primitives),
    ];
    assert(primitives.isNotEmpty, 'At least one primitive parser expected');
    final parser = _groups.fold<Parser<T>>(
      primitives.length == 1 ? primitives.first : primitives.toChoiceParser(),
      (parser, group) => group.build(parser),
    );
    loopback.set(parser);
    return resolve(parser);
  }

  void addOperators(
    ParserContext parserContext,
  ) {
    for (var operatorGroup in parserContext.engine.operatorGroups) {
      var builderGroup = group();
      for (var operator in operatorGroup) {
        operator.addParser(parserContext.template,
            builderGroup as ExpressionGroup2<Expression<Object>>);
      }
    }
  }
}

Parser<R> buildChoice<R>(List<Parser<R>> parsers) =>
    parsers.length == 1 ? parsers.first : parsers.toChoiceParser();

/// Models a group of operators of the same precedence.
class ExpressionGroup2<T> {
  ExpressionGroup2(this._loopback);

  /// Loopback parser used to establish the recursive expressions.
  final Parser<T> _loopback;

  /// Defines a new primitive or literal [parser].
  @Deprecated('Define primitive parsers directly on the builder using '
      '`ExpressionBuilder.primitive`')
  void primitive(Parser<T> parser) => primitives.add(parser);

  final List<Parser<T>> primitives = [];

  /// Defines a new wrapper using [left] and [right] parsers, that are typically
  /// used for parenthesis. Evaluates the [callback] with the parsed `left`
  /// delimiter, the `value` and `right` delimiter.
  void wrapper<L, R>(Parser<L> left, Parser<R> right,
          T Function(L left, T value, R right) callback) =>
      _wrapper.add(seq3(left, _loopback, right).map3(callback));

  Parser<T> _buildWrapper(Parser<T> inner) => buildChoice([..._wrapper, inner]);

  final List<Parser<T>> _wrapper = [];

  /// Adds a prefix operator [parser]. Evaluates the [callback] with the parsed
  /// `operator` and `value`.
  void prefix<O>(Parser<O> parser,
          T Function(Context context, O operator, T value) callback) =>
      _prefix.add(parser.valueContextMap((operator, context) =>
          ExpressionResultPrefix<T, O>(context, operator, callback)));

  Parser<T> _buildPrefix(Parser<T> inner) => _prefix.isEmpty
      ? inner
      : seq2(buildChoice(_prefix).star(), inner).map2((prefix, value) =>
          prefix.reversed.fold(value, (each, result) => result.call(each)));

  final List<Parser<ExpressionResultPrefix<T, void>>> _prefix = [];

  /// Adds a postfix operator [parser]. Evaluates the [callback] with the parsed
  /// `value` and `operator`.
  void postfix<O>(Parser<O> parser, T Function(T value, O operator) callback) =>
      _postfix.add(parser.map(
          (operator) => ExpressionResultPostfix<T, O>(operator, callback)));

  Parser<T> _buildPostfix(Parser<T> inner) => _postfix.isEmpty
      ? inner
      : seq2(inner, buildChoice(_postfix).star()).map2((value, postfix) =>
          postfix.fold(value, (each, result) => result.call(each)));

  final List<Parser<ExpressionResultPostfix<T, void>>> _postfix = [];

  /// Adds a right-associative operator [parser]. Evaluates the [callback] with
  /// the parsed `left` term, `operator`, and `right` term.
  void right<O>(Parser<O> parser,
          T Function(Context context, T left, O operator, T right) callback) =>
      _right.add(parser.valueContextMap((operator, context) =>
          ExpressionResultInfix<T, O>(context, operator, callback)));

  Parser<T> _buildRight(Parser<T> inner) => _right.isEmpty
      ? inner
      : inner.plusSeparated(buildChoice(_right)).map((sequence) => sequence
          .foldRight((left, result, right) => result.call(left, right)));

  final List<Parser<ExpressionResultInfix<T, void>>> _right = [];

  /// Adds a left-associative operator [parser]. Evaluates the [callback] with
  /// the parsed `left` term, `operator`, and `right` term.
  void left<O>(Parser<O> parser,
          T Function(Context context, T left, O operator, T right) callback) =>
      _left.add(parser.valueContextMap((operator, context) =>
          ExpressionResultInfix<T, O>(context, operator, callback)));

  Parser<T> _buildLeft(Parser<T> inner) => _left.isEmpty
      ? inner
      : inner.plusSeparated(buildChoice(_left)).map((sequence) =>
          sequence.foldLeft((left, result, right) => result.call(left, right)));

  final List<Parser<ExpressionResultInfix<T, void>>> _left = [];

  /// Makes the group optional and instead return the provided [value].
  void optional(T value) {
    assert(!_optional, 'At most one optional value expected');
    _optionalValue = value;
    _optional = true;
  }

  Parser<T> _buildOptional(Parser<T> inner) =>
      _optional ? inner.optionalWith(_optionalValue) : inner;

  late T _optionalValue;
  bool _optional = false;

  // Internal helper to build the group of parsers.
  Parser<T> build(Parser<T> inner) => _buildOptional(_buildLeft(
      _buildRight(_buildPostfix(_buildPrefix(_buildWrapper(inner))))));
}

class ExpressionResultPrefix<V, O> {
  ExpressionResultPrefix(this.context, this.operator, this.callback);

  final Context context;
  final O operator;
  final V Function(Context context, O operator, V value) callback;

  V call(V value) => callback(context, operator, value);
}

/// Encapsulates a postfix operation.
class ExpressionResultPostfix<V, O> {
  ExpressionResultPostfix(this.operator, this.callback);

  final O operator;
  final V Function(V value, O operator) callback;

  V call(V value) => callback(value, operator);
}

/// Encapsulates a infix operation.
class ExpressionResultInfix<V, O> {
  ExpressionResultInfix(this.context, this.operator, this.callback);

  final Context context;

  final O operator;
  final V Function(Context context, V left, O operator, V right) callback;

  V call(V left, V right) => callback(context, left, operator, right);
}
