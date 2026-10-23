import 'package:template_engine/template_engine.dart';

///  the associativity of an operator is a property that determines how
/// operators of the same precedence are grouped in the absence of parentheses.
/// If an operand is both preceded and followed by operators, and those
///  operators have equal precedence, then the operand may be used as input
/// to two different operations (i.e. the two operations indicated by the
/// two operators). The choice of which operations to apply the operand to,
/// is determined by the associativity of the operators.
///
/// Operators may be associative (meaning the operations can be grouped
/// arbitrarily):
/// * left-associative (meaning the operations are grouped from the left)
/// * right-associative (meaning the operations are grouped from the right)
/// * non-associative (meaning operations cannot be chained,
///   often because the output type is incompatible with the input types).
///
/// The associativity and precedence of an operator is a part of the
/// definition of the programming language; different programming languages
/// may have different associativity and precedence for the same type of
/// operator.
///
/// See https://en.wikipedia.org/wiki/Operator_associativity
///
enum BinaryOperatorAssociativity {
  /// left-associative: meaning the operations are grouped from the left first
  /// This is used for the majority of operators
  left,

  /// right-associative: meaning the operations are grouped from the right first
  /// E.g. This is used for the the power operator (2 ^ 3)
  right,
}

/// Defines precedence levels for binary operators used during expression parsing.
///
/// Precedence determines the order in which operators are evaluated in the
/// absence of parentheses. Operators with higher [level] values bind more
/// tightly than those with lower values.
///
/// For example, in the expression `a + b * c`, the `*` operator has higher
/// precedence than `+`, so `b * c` is evaluated first.
///
/// The values in this enum are ordered from lowest to highest precedence.
///
/// Some operator categories (such as unary, postfix, and primary expressions)
/// are not included here because they are handled separately in the parser.
enum BinaryOperatorPrecedence {
  /// assignment: See [Grammar.statements]
  conditional(1), // ? :
  or(2), // |
  xor(3), // ^
  and(4), // &
  equality(5), // ==, !=
  relational(6), // <, <=, >, >=
  shift(7), // <<, >>
  additive(8), // +, -
  multiplicative(9), // *, /, %
  exponentiation(10); // **(if supported)

  /// unary: +, -, !, ~, ++, --, see [ExpressionGrammar.unaryOperators]
  /// postfix: indexes[] and function calls, see [ExpressionGrammar.functionGroups]
  /// primary:
  /// * literals (e.g. a number) see [ExpressionGrammar.dataTypes],
  /// * identifiers (e.g. constants) see [ExpressionGrammar.constants],
  /// * parentheses see [ExpressionParser]

  final int level;
  const BinaryOperatorPrecedence(this.level);
}

/// Represents a operator expression consisting of a left and right
/// operand and an operator symbol (e.g. `+`, `==`, `&&`).
///
/// The expression is evaluated by first evaluating both operands and then
/// selecting the first matching [BinaryOperatorSignature] that validates
/// the operand types. If no signature matches, a [RenderError] is thrown.
///
/// Multiple [signatures] allow operator overloading based on operand types.
class BinaryOperatorExpression extends Expression {
  final TemplateLocation location;
  final BinaryOperatorDefinition definition;
  final Expression left;
  final Expression right;

  BinaryOperatorExpression({
    required this.location,
    required this.definition,
    required this.left,
    required this.right,
  });

  @override
  Future<dynamic> evaluate(RenderContext context) async {
    final leftValue = await left.evaluate(context);
    final rightValue = await right.evaluate(context);
    var errors = <String>[];
    for (var signature in definition.signatures) {
      var variantErrors = signature.validate(
        definition.symbol,
        leftValue,
        rightValue,
      );
      if (variantErrors.isEmpty) {
        return signature.evaluate(leftValue, rightValue);
      } else {
        errors.addAll(variantErrors);
      }
    }
    throw RenderError(errors.join(', or '), location);
  }
}

/// Defines a binary operator, including its parsing and evaluation behavior.
///
/// This structure is typically used during parsing and evaluation to resolve
/// operator behavior dynamically.
class BinaryOperatorDefinition {
  final String symbol;

  /// determines the order in which the operator is applied
  /// relative to other operators.
  final BinaryOperatorPrecedence precedence;

  ///determines how operators of the same precedence are grouped.
  final BinaryOperatorAssociativity associativity;

  /// the supported operand type combinations and their evaluation logic.
  final List<BinaryOperatorSignature> signatures;

  late final BinaryOperatorDocumentation documentation =
      BinaryOperatorDocumentation(this);

  BinaryOperatorDefinition({
    required this.symbol,
    required this.precedence,
    required this.associativity,
    required this.signatures,
  });
}

/// Describes a single valid type combination ("signature") for a binary operator.
///
/// A signature defines:
/// - The expected types of the left and right operands
/// - The resulting type of the operation
/// - A human-readable [description]
/// - Example usages for documentation purposes
/// - The evaluation [function] that performs the operation
///
/// Multiple signatures can be defined for a single operator to support
/// overloading (e.g. number + number, string + string).
///
/// Generic type parameters:
/// - [LEFT_OPERAND_TYPE]: expected type of the left operand
/// - [RIGHT_OPERAND_TYPE]: expected type of the right operand
/// - [RESULT_TYPE]: type of the result produced by the operator
class BinaryOperatorSignature<
  LEFT_OPERAND_TYPE,
  RIGHT_OPERAND_TYPE,
  RESULT_TYPE
>
    implements ExampleProvider {
  final leftOperandType = LEFT_OPERAND_TYPE;
  final rightOperandType = RIGHT_OPERAND_TYPE;
  final resultType = RESULT_TYPE;
  final String description;
  @override
  final List<Example> examples;
  final RESULT_TYPE Function(
    LEFT_OPERAND_TYPE leftOperand,
    RIGHT_OPERAND_TYPE rightOperand,
  )
  function;

  BinaryOperatorSignature({
    required this.description,
    required this.examples,
    required this.function,
  });

  List<String> validate(
    String operator,
    dynamic leftValue,
    dynamic rightValue,
  ) {
    bool leftTypeOk = leftValue is LEFT_OPERAND_TYPE;
    bool rightTypeOk = rightValue is RIGHT_OPERAND_TYPE;
    if (leftTypeOk && rightTypeOk) {
      return [];
    }
    if (LEFT_OPERAND_TYPE.hashCode == RIGHT_OPERAND_TYPE.hashCode &&
        !leftTypeOk &&
        !rightTypeOk) {
      return [
        'left and right of the $operator operator '
            'must be a ${typeDescription(LEFT_OPERAND_TYPE)}',
      ];
    }
    var errors = <String>[];
    if (!leftTypeOk) {
      errors.add(
        'left of the $operator operator '
        'must be a ${typeDescription(LEFT_OPERAND_TYPE)}',
      );
    }
    if (!rightTypeOk) {
      errors.add(
        'right of the $operator operator '
        'must be a ${typeDescription(RIGHT_OPERAND_TYPE)}',
      );
    }
    return errors;
  }

  RESULT_TYPE evaluate(dynamic leftOperand, dynamic rightOperand) => function(
    leftOperand as LEFT_OPERAND_TYPE,
    rightOperand as RIGHT_OPERAND_TYPE,
  );

  String syntaxMarkdown(String operatorSymbol) =>
      'syntax: &lt;${typeDescription(LEFT_OPERAND_TYPE)}&gt; '
      '$operatorSymbol '
      '&lt;${typeDescription(RIGHT_OPERAND_TYPE)}&gt;<br>'
      'returns: &lt;${typeDescription(RESULT_TYPE)}&gt;';
}

/// Provides Markdown documentation for a binary operator.
///
/// This class generates a formatted HTML/Markdown representation of an
/// operator, including:
/// - Syntax for each supported signature
/// - Descriptions of each signature
/// - Example usages
///
/// It aggregates documentation from all signatures in the associated
/// [BinaryOperatorDefinition], making it suitable for generating reference
/// documentation for template languages or DSLs.
class BinaryOperatorDocumentation
    implements MarkdownDocumentation, ExampleProvider {
  final BinaryOperatorDefinition definition;

  BinaryOperatorDocumentation(this.definition);

  @override
  String createMarkdownDocumentation(Grammar grammar, int titleLevel) {
    var writer = HtmlTableWriter();
    writer.setTitle(titleLevel, '${definition.symbol} operator');
    for (var signature in definition.signatures) {
      writer.addRow(
        ['<p align="center">${signature.syntaxMarkdown(definition.symbol)}</p>'],
        [2],
      );
      writer.addRow(['description:', signature.description]);
      for (final example in signature.examples) {
        writer.addRow([
          '${example.typeString}:',
          example.toMarkdown(grammar.codeBlockDelimiter),
        ]);
      }
    }
    return writer.toHtml();
  }

  @override
  late final List<Example> examples = definition.signatures
      .expand((s) => s.examples)
      .toList();

  late final precedence = definition.precedence;
}

final standardBinaryOperators = <BinaryOperatorDefinition>[
  ...standardOrOperators,
  ...standardXorOperators,
  ...standardAndOperators,
  ...standardEqualityOperators,
  ...standardRelationalOperators,
  ...standardAdditiveOperators,
  ...standardMultiplicativeOperators,
  ...standardExponentiationOperators,
];
