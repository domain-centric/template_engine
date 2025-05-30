import 'package:collection/collection.dart';
import 'package:petitparser/petitparser.dart';
import 'package:template_engine/template_engine.dart';

Parser<Expression> functionsParser({
  required ParserContext context,
  required SettableParser loopback,
  required bool verboseErrors,
}) {
  var functions = context.engine.functionGroups
      .expand((function) => function)
      .toList();
  var parser = ChoiceParser<Expression>(
    functions.map(
      (function) => functionParser(
        context: context,
        function: function,
        loopbackParser: loopback,
      ),
    ),
    failureJoiner: selectFarthest,
  );
  if (verboseErrors) {
    return parser;
  } else {
    return OverrideMessageParser(parser, 'function expected');
  }
}

Parser<Expression> functionParser({
  required ParserContext context,
  required ExpressionFunction<Object> function,
  required SettableParser loopbackParser,
}) {
  return (string(function.name, 'expected function name: ${function.name}') &
          char('(').trim() &
          ArgumentsParser(
            parserContext: context,
            parameters: function.parameters,
            loopbackParser: loopbackParser,
          ) &
          char(')').trim())
      .valueContextMap(
        (values, context) => FunctionExpression(
          context.toPositionString(),
          function,
          values[2] as Map<String, Expression>,
        ),
      );
}

class FunctionException implements Exception {
  final String message;
  FunctionException(this.message);
}

class FunctionExpression<R extends Object>
    extends ExpressionWithSourcePosition<R> {
  final ExpressionFunction<R> function;
  final Map<String, Expression> parameterExpressionMap;

  FunctionExpression(
    String position,
    this.function,
    this.parameterExpressionMap,
  ) : super(position: position);

  @override
  Future<R> render(RenderContext context) async {
    Arguments parameterMap = <String, Object>{};
    for (var name in parameterExpressionMap.keys) {
      var value = await parameterExpressionMap[name]!.render(context);
      parameterMap[name] = value;
    }
    return await function.function(super.position, context, parameterMap);
  }

  @override
  String toString() => 'Function{${function.name}}';
}

/// A function is a piece of dart code that performs a specific task.
// So a function can basically do anything that dart code can do.
///
/// A function can be used anywhere in an tag expression. Wherever that particular task should be performed.
///
/// An example of a function call: cos(pi)
/// Should result in: -1
///
/// ## Custom Functions
/// You can adopt existing functions or add your own custom functions by
/// manipulating the [TemplateEngine.functionGroups] field.
/// See [custom_function_test.dart](https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/function/custom_function_test.dart).
///

// A function of an [ExpressionTag]
// It has the [Expression] prefix in the name since [Function]
// is already taken by Dart core.
class ExpressionFunction<R extends Object>
    implements DocumentationFactory, ExampleFactory {
  ExpressionFunction({
    required this.name,
    this.description,
    this.exampleExpression,
    this.exampleResult,
    this.exampleCode,
    this.parameters = const [],
    required this.function,
  }) {
    IdentifierName.validate(name);
  }

  final String name;
  final String? description;
  final String? exampleExpression;
  final String? exampleResult;
  final ProjectFilePath? exampleCode;
  final List<Parameter> parameters;
  final Future<R> Function(
    String position,
    RenderContext renderContext,
    Map<String, Object> parameters,
  )
  function;

  @override
  List<String> createMarkdownDocumentation(
    RenderContext renderContext,
    int titleLevel,
  ) {
    var writer = HtmlTableWriter();
    writer.setHeader(titleLevel, '$name Function');
    if (description != null) {
      writer.addRow(['description:', description!], [1, 4]);
    }
    writer.addRow(['return type:', typeDescription<R>()], [1, 4]);
    writer.addRow(['expression example:', _createExpressionExample()], [1, 4]);
    if (exampleCode != null) {
      writer.addRow(['code example:', exampleCode!.githubMarkdownLink], [1, 4]);
    }
    var parameterRows = parameters
        .map(
          (parameter) =>
              parameter.createMarkdownDocumentation(renderContext, titleLevel),
        )
        .flattened;
    writer.rows.addAll(parameterRows);
    return writer.toHtmlLines();
  }

  @override
  List<String> createMarkdownExamples(
    RenderContext renderContext,
    int titleLevel,
  ) => exampleCode == null ? [] : ['* ${exampleCode!.githubMarkdownLink}'];

  String _createExampleExpression() {
    var expression = StringBuffer();
    expression.write('{{ $name(');
    var mandatoryParameters = parameters.where(
      (parameter) => parameter.presence.mandatory,
    );
    if (mandatoryParameters.length == 1) {
      expression.write(
        _createExampleExpressionParameterValue(mandatoryParameters.first),
      );
    } else {
      var commaNeeded = false;
      for (var mandatoryParameter in mandatoryParameters) {
        if (commaNeeded) {
          expression.write(', ');
        }
        expression.write(mandatoryParameter.name);
        expression.write('=');
        expression.write(
          _createExampleExpressionParameterValue(mandatoryParameter),
        );
        commaNeeded = true;
      }
    }
    expression.write(') }}');
    return expression.toString();
  }

  String _createExpressionExample() {
    var example = exampleExpression ?? _createExampleExpression();
    if (exampleResult != null && exampleResult!.trim().isNotEmpty) {
      example += ' should render: $exampleResult';
    }
    return example;
  }

  String _createExampleExpressionParameterValue(Parameter mandatoryParameter) {
    var type = mandatoryParameter.valueType;
    if (type == String) {
      return "'${mandatoryParameter.name} value'";
    }
    if (type == double) {
      return '12.34';
    }
    if (type == num) {
      return '1234';
    }
    if (type == bool) {
      return 'true';
    }
    return '???';
  }
}

class FunctionGroup extends DelegatingList<ExpressionFunction>
    implements DocumentationFactory, ExampleFactory {
  final String name;

  FunctionGroup(this.name, super.base);

  @override
  List<String> createMarkdownDocumentation(
    RenderContext renderContext,
    int titleLevel,
  ) => [
    '${"#" * titleLevel} $name',
    ...map(
      (function) =>
          function.createMarkdownDocumentation(renderContext, titleLevel + 1),
    ).flattened,
  ];

  @override
  List<String> createMarkdownExamples(
    RenderContext renderContext,
    int titleLevel,
  ) {
    var examples = map(
      (function) =>
          function.createMarkdownExamples(renderContext, titleLevel + 2),
    ).flattened;
    if (examples.isEmpty) {
      return [];
    } else {
      return ['${"#" * (titleLevel + 1)} $name', ...examples];
    }
  }
}

/// A [ExpressionFunction] can have 0 or more [Parameter]s.
/// An [Parameter]:
/// * Has a name
/// * Has a value of one of the following types:
///   * bool
///   * String
///   * int
///   * double
///   * date
///   * list where the elements are one of the types above
///   * map where the keys are a string and the values are one of the types above
///   * an [Expression]
///  * Can be optional
///  * Can have an default value when the attribute is optional
class Parameter<T> implements DocumentationFactory {
  /// See [ParameterName]
  final String name;

  /// Optional description
  final String? description;

  final Presence presence;

  Type get valueType => T;

  Parameter({required this.name, this.description, Presence? presence})
    : presence = presence ?? Presence.mandatory() {
    ParameterName.validate(name);
  }

  @override
  List<String> createMarkdownDocumentation(
    RenderContext renderContext,
    int titleLevel,
  ) => [
    HtmlTableRow(
      [
        'parameter:',
        name,
        typeDescription<T>(),
        presence.toString(),
        if (description != null) description!,
      ],
      [1, 1, 1, description == null ? 2 : 1, 1],
    ).toHtml(),
  ];
}

class Presence {
  final String name;
  final dynamic defaultValue;

  Presence.mandatory() : name = 'mandatory', defaultValue = null;
  Presence.optional() : name = 'optional', defaultValue = null;
  Presence.optionalWithDefaultValue(this.defaultValue)
    : name = 'optionalWithDefaultValue';

  bool get mandatory => name == 'mandatory';

  bool get optional => name == 'optional';

  bool get optionalWithDefaultValue => name == 'optionalWithDefaultValue';

  @override
  String toString() {
    if (mandatory || optional) {
      return name;
    } else {
      return 'optional (default='
          '${defaultValue is String ? '"$defaultValue"' : defaultValue})';
    }
  }
}

/// A [ParameterName]:
/// * must start with a loewe case letter, optionally followed by (lower or upper) letters and or digits.
/// * is case sensitive .
///
/// E.g.: myValue1
class ParameterName {
  static final parser = IdentifierName.parser;

  static void validate(String name) {
    var result = parser.end('letter OR digit expected').parse(name);
    if (result is Failure) {
      throw ParameterException(
        'Invalid parameter name: "$name", ${result.message} at position ${result.position}',
      );
    }
  }
}

class ParameterException implements Exception {
  final String message;
  ParameterException(this.message);
}

class ParameterExceptions implements Exception {
  final List<String> messages;

  ParameterExceptions(this.messages);
}

/// [Arguments] is a [Map] of parameter names and values
typedef Arguments = Map<String, Object>;

/// Parses an function argument expression and:
/// * validates the result
/// * and converts the values to [Arguments]
///
/// **Function arguments:**
/// * Multiple arguments are separated with a comma, e.g. single argument: `cos(pi)` multiple arguments: `volume(10,20,30)`
/// * There are different types of arguments
///   * Positional Arguments: These are passed in the order the function defines them. e.g.: `volume(10, 20, 30)`
///   * Named Arguments: You can specify which parameter you're assigning a value to, regardless of order. e.g.: `volume(l=30, h=10, w=20)`
/// * Arguments can set a parameter only once
/// * You can mix positional arguments and named arguments, but positional arguments must come first
/// * Named arguments remove ambiguity: If you want to skip an optional argument or specify one out of order, you must name it explicitly
///
/// **Argument values:**
/// * must match the expected parameter type. e.g. `area(length='hello', width='world')` will result in a failure
/// * may be a tag expression such as a variable, constant, operation, function, or combination. e.g. `cos(2*pi)`
class ArgumentsParser extends Parser<Arguments> {
  static final _endOfArgumentsParser = (whitespace().starLazy(
    char(')'),
  )).flatten().trim();
  static final _remainingParser = (any().starLazy(char(')'))).flatten().trim();
  static final _commaParser = char(',').flatten('comma expected').trim();
  final ParserContext parserContext;
  final List<Parameter> parameters;
  final SettableParser loopbackParser;

  ArgumentsParser({
    required this.parserContext,
    required this.parameters,
    required this.loopbackParser,
  });

  @override
  Result<Map<String, Expression>> parseOn(Context context) {
    var arguments = <String, Expression>{};
    var current = context;
    var index = 0;
    var seenNamed = false;

    while (true) {
      // Try if we are at the end
      var endResult = _endOfArgumentsParser.parseOn(current);
      if (endResult is Success) {
        current = endResult;
        break;
      }

      // Try to parse a comma if this is not the first argument
      if (arguments.isNotEmpty) {
        final commaResult = _commaParser.parseOn(current);
        if (commaResult is Failure) return commaResult;
        current = commaResult;
      }

      // If we've parsed all parameters, stop
      if (index >= parameters.length) break;

      // Try to parse a positional argument
      final positionalParameter = parameters[index];
      final positionalParser = positionalArgumentParser(
        parserContext: parserContext,
        positionalParameter: positionalParameter,
        parameters: parameters,
        loopbackParser: loopbackParser,
      );
      final positionalResult = positionalParser.parseOn(current);

      if (positionalResult is Success) {
        // If we've already seen a named argument, positional arguments are not allowed
        if (seenNamed) {
          return current.failure(
            'positional arguments must come before named arguments',
          );
        }
        final entry = positionalResult.value;
        if (arguments.containsKey(entry.key)) {
          return current.failure(
            'parameter "${entry.key}" specified more than once',
          );
        }
        arguments[entry.key] = entry.value;
        current = positionalResult;
        index++;
        continue;
      }

      // Try to parse a remaining named arguments
      var foundNamed = false;
      var namedParameters = parameters.skip(index);
      for (var parameter in namedParameters) {
        final namedParser = namedArgumentParser(
          parserContext: parserContext,
          parameter: parameter,
          loopbackParser: loopbackParser,
        );
        final namedResult = namedParser.parseOn(current);
        if (namedResult is Success) {
          foundNamed = true;
          seenNamed = true;
          final entry = namedResult.value;
          if (arguments.containsKey(entry.key)) {
            return current.failure(
              'parameter "${entry.key}" was specified more than once',
            );
          }
          arguments[entry.key] = entry.value;
          current = namedResult;
          break;
        }
      }

      if (!foundNamed) {
        break;
      }
    }

    // Check for remaining unexpected input
    final remainingResult = _remainingParser.parseOn(current);
    if (remainingResult is Success) {
      final remainingText = remainingResult.value;
      if (remainingText.isNotEmpty) {
        return current.failure('invalid syntax in function argument');
      }
      current = remainingResult;
    }

    final validationError = _validateIfMandatoryParametersWhereFound(
      arguments,
      current,
    );
    if (validationError != null) {
      return current.failure(validationError);
    }

    arguments.addAll(_missingDefaultValues(parameters, arguments));

    return current.success(arguments);
  }

  @override
  ArgumentsParser copy() => ArgumentsParser(
    parserContext: parserContext,
    parameters: parameters,
    loopbackParser: loopbackParser,
  );

  /// returns an validation error message or null when valid
  String? _validateIfMandatoryParametersWhereFound(
    Arguments arguments,
    Context context,
  ) {
    var missingMandatoryParameters = parameters.where(
      (p) => p.presence.mandatory && !arguments.containsKey(p.name),
    );
    if (missingMandatoryParameters.isEmpty) {
      return null;
    }
    if (missingMandatoryParameters.length == 1) {
      return 'missing argument for parameter: ${missingMandatoryParameters.first.name}';
    } else {
      return 'missing arguments for parameters: ${missingMandatoryParameters.map((e) => e.name).join(', ')}';
    }
  }

  /// Adds missing default values in [namesAndValues]
  Map<String, Expression> _missingDefaultValues(
    List<Parameter> parameters,
    Map<String, Expression> namesAndValues,
  ) {
    Map<String, Expression> missingDefaultValues = {};

    var optionalParametersWithDefaultValue = parameters.where(
      (parameter) => parameter.presence.optionalWithDefaultValue,
    );
    for (var optionalParameter in optionalParametersWithDefaultValue) {
      if (!namesAndValues.containsKey(optionalParameter.name)) {
        missingDefaultValues[optionalParameter.name] = Value(
          optionalParameter.presence.defaultValue,
        );
      }
    }
    return missingDefaultValues;
  }
}

typedef ArgumentEntry = MapEntry<String, Expression>;
typedef ArgumentEntryParser = Parser<ArgumentEntry>;

/// Accepts a name=value expression and converts it to a [ArgumentEntry]
/// Returns a parser that returns the value of an [ExpressionFunction] parameter
/// It uses a loopback parser which is an [expressionParser] so that it can
/// parse any known expression to a parameter value.
/// The [loopbackParser] is a [SettableParser] because the [expressionParser]
/// does not exist when this [namedArgumentParser] is created.
ArgumentEntryParser namedArgumentParser({
  required ParserContext parserContext,
  required Parameter parameter,
  required SettableParser loopbackParser,
}) => (string(parameter.name).trim() & char('=').trim() & loopbackParser).map(
  (values) => ArgumentEntry(parameter.name, values[2]),
);

/// Accepts a value expression (not starting with name=) and converts it to a [ArgumentEntry]
/// It uses a loopback parser which is an [expressionParser] so that it can
/// parse any known expression to a parameter value.
/// The [loopbackParser] is a [SettableParser] because the [expressionParser]
/// does not exist when this [positionalArgumentParser] is created.
ArgumentEntryParser positionalArgumentParser({
  required ParserContext parserContext,
  required positionalParameter,
  required List<Parameter> parameters,
  required SettableParser loopbackParser,
}) =>
    ([for (var p in parameters) (string(p.name).trim() & char('=').trim())]
                .toChoiceParser()
                .not() &
            loopbackParser)
        .map((values) => ArgumentEntry(positionalParameter.name, values[1]));
