import 'package:collection/collection.dart';
import 'package:petitparser/petitparser.dart';
import 'package:template_engine/src/parser/override_message_parser.dart';
import 'package:template_engine/template_engine.dart';

Parser<Expression> functionsParser({
  required ParserContext context,
  required SettableParser loopback,
  required bool verboseErrors,
}) {
  var functions =
      context.engine.functionGroups.expand((function) => function).toList();
  var parser = ChoiceParser<Expression>(
      functions.map((function) => functionParser(
          context: context, function: function, loopbackParser: loopback)),
      failureJoiner: selectFarthest);
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
          ParametersParser(
              parserContext: context,
              parameters: function.parameters,
              loopbackParser: loopbackParser) &
          char(')').trim())
      .valueContextMap((values, context) => FunctionExpression(
          context.toPositionString(),
          function,
          values[2] as Map<String, Expression>));
}

class FunctionException implements Exception {
  final String message;
  FunctionException(this.message);
}

/// The [FunctionName]:
/// * must start with a lower case letter, optionally followed by letters and or digits.
/// * is case sensitive .
///
/// E.g.: myValue1
class FunctionName {
  static final Parser<String> parser =
      (lowercase() & (letter() | digit()).star()).flatten();

  static validate(String name) {
    var result = parser.end('letter OR digit expected').parse(name);
    if (result is Failure) {
      throw FunctionException("Invalid function name: '$name', "
          "${result.message} at position ${result.position}");
    }
  }
}

class FunctionExpression<R extends Object> extends Expression<R> {
  final String position;
  final ExpressionFunction<R> function;
  final Map<String, Expression> parameterExpressionMap;

  FunctionExpression(this.position, this.function, this.parameterExpressionMap);

  @override
  Future<R> render(RenderContext context) async {
    ParameterMap parameterMap = <String, Object>{};
    for (var name in parameterExpressionMap.keys) {
      var value = await parameterExpressionMap[name]!.render(context);
      parameterMap[name] = value;
    }
    return await function.function(position, context, parameterMap);
  }

  @override
  String toString() => 'Function{${function.name}}';
}

/// A function is a piece of dart code that performs a specific task.
/// So a function can basically do anything that dart code can do.
///
/// A function can be used anywhere in an tag expression
/// wherever that particular task should be performed.
///
/// The [TemplateEngine] supports several standard functions.
///
/// ## Custom Functions
/// You can adopt existing functions or add your own custom functions by
/// manipulating the [TemplateEngine.functionGroups] field.
/// See [custom_function_test.dart](https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/function/custom_function_test.dart).
///

// A function of a [Expression]
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
    FunctionName.validate(name);
  }

  final String name;
  final String? description;
  final String? exampleExpression;
  final String? exampleResult;
  final ProjectFilePath? exampleCode;
  final List<Parameter> parameters;
  final Future<R> Function(String position, RenderContext renderContext,
      Map<String, Object> parameters) function;

  @override
  List<String> createMarkdownDocumentation(
      RenderContext renderContext, int titleLevel) {
    var writer = HtmlTableWriter();
    writer.addHeaderRow([name], [5]);
    if (description != null) {
      writer.addRow(['description:', description!], [1, 4]);
    }
    writer.addRow(['return type:', typeDescription<R>()], [1, 4]);
    writer.addRow(['expression example:', _createExpressionExample()], [1, 4]);
    if (exampleCode != null) {
      writer.addRow(['code example:', exampleCode!.githubMarkdownLink], [1, 4]);
    }
    var parameterRows = parameters
        .map((parameter) =>
            parameter.createMarkdownDocumentation(renderContext, titleLevel))
        .flattened;
    writer.rows.addAll(parameterRows);
    return writer.toHtmlLines();
  }

  @override
  List<String> createMarkdownExamples(
          RenderContext renderContext, int titleLevel) =>
      exampleCode == null ? [] : ['* ${exampleCode!.githubMarkdownLink}'];

  String _createExampleExpression() {
    var expression = StringBuffer();
    expression.write('{{ $name(');
    var mandatoryParameters =
        parameters.where((parameter) => parameter.presence.mandatory);
    if (mandatoryParameters.length == 1) {
      expression.write(
          _createExampleExpressionParameterValue(mandatoryParameters.first));
    } else {
      var commaNeeded = false;
      for (var mandatoryParameter in mandatoryParameters) {
        if (commaNeeded) {
          expression.write(', ');
        }
        expression.write(mandatoryParameter.name);
        expression.write('=');
        expression
            .write(_createExampleExpressionParameterValue(mandatoryParameter));
        commaNeeded = true;
      }
    }
    expression.write(') }}');
    return expression.toString();
  }

  _createExpressionExample() {
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
          RenderContext renderContext, int titleLevel) =>
      [
        '${"#" * titleLevel} $name',
        ...map((function) => function.createMarkdownDocumentation(
            renderContext, titleLevel + 1)).flattened
      ];

  @override
  List<String> createMarkdownExamples(
      RenderContext renderContext, int titleLevel) {
    var examples = map((function) =>
            function.createMarkdownExamples(renderContext, titleLevel + 1))
        .flattened;
    if (examples.isEmpty) {
      return [];
    } else {
      return [
        '${"#" * titleLevel} $name',
        ...examples,
      ];
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
  /// The name of the [Parameter]:
  /// * may not be empty
  /// * is case un-sensitive
  /// * may contain letters and numbers: 'title'
  final String name;

  /// Optional description
  final String? description;

  final Presence presence;

  Type get valueType => T;

  Parameter({
    required this.name,
    this.description,
    Presence? presence,
  }) : presence = presence ?? Presence.mandatory() {
    ParameterName.validate(name);
  }

  @override
  List<String> createMarkdownDocumentation(
          RenderContext renderContext, int titleLevel) =>
      [
        HtmlTableRow([
          'parameter:',
          name,
          typeDescription<T>(),
          presence.toString(),
          if (description != null) description!
        ], [
          1,
          1,
          1,
          description == null ? 2 : 1,
          1
        ]).toHtml()
      ];
}

class Presence {
  final String name;
  final dynamic defaultValue;

  Presence.mandatory()
      : name = 'mandatory',
        defaultValue = null;
  Presence.optional()
      : name = 'optional',
        defaultValue = null;
  Presence.optionalWithDefaultValue(Object this.defaultValue)
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

/// The [ParameterName]:
/// * must start with a letter, optionally followed by letters and or digits.
/// * is case sensitive .
///
/// E.g.: myValue1
class ParameterName {
  static final parser = FunctionName.parser;

  static validate(String name) {
    var result = parser.end('letter OR digit expected').parse(name);
    if (result is Failure) {
      throw ParameterException(
          'Invalid parameter name: "$name", ${result.message} at position ${result.position}');
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

typedef ParameterMap = Map<String, Object>;

/// Creates parsers for each parameter:
/// * no parameters
/// * one parameter: value or name=value
/// * multiple parameters: name=value, name=value etc...
/// Then validates the result and converts parameters to a name-value [Map]
class ParametersParser extends Parser<Map<String, Expression>> {
  static final _remainingParser = (any().starLazy(char(')'))).flatten().trim();
  static final _commaParser = char(',').flatten('comma expected').trim();
  final ParserContext parserContext;
  final List<ParameterParser> parameterParsers;
  final List<Parameter> parameters;
  final SettableParser loopbackParser;

  ParametersParser(
      {required this.parserContext,
      required this.parameters,
      required this.loopbackParser})
      : parameterParsers = parameters
            .map((parameter) => parameterParser(
                parserContext: parserContext,
                parameter: parameter,
                loopbackParser: loopbackParser,
                withName: parameters.length > 1))
            .toList();

  @override
  Result<Map<String, Expression>> parseOn(Context context) {
    var parameterMap = <String, Expression>{};
    var current = context;
    var unUsedParameterParsers = [...parameterParsers];
    ParameterParser? parserWithSuccess;
    bool firstParameter = true;
    do {
      parserWithSuccess = null;

      for (var parser in unUsedParameterParsers) {
        if (parserWithSuccess == null) {
          var result = parser.parseOn(current);
          if (result is Success) {
            parserWithSuccess = parser;
            parameterMap.addEntries([result.value]);
            current = result;
          }
        }
      }
      if (parserWithSuccess != null) {
        // remove parser for efficiency
        unUsedParameterParsers.remove(parserWithSuccess);
        if (firstParameter) {
          firstParameter = false;
          //add commaParsers before parameterParsers
          var withCommaPrefixParsers = unUsedParameterParsers
              .map((parser) => (_commaParser & parser)
                  .map((values) => values[1] as MapEntry<String, Expression>))
              .toList();
          unUsedParameterParsers = withCommaPrefixParsers;
        }
      }
    } while (parserWithSuccess != null && unUsedParameterParsers.isNotEmpty);

    var result = _remainingParser.parseOn(current);
    if (result is Success) {
      var remainingText = result.value;
      if (remainingText.isNotEmpty) {
        return current
            .failure('invalid function parameter syntax: $remainingText');
      }
      current = result;
    }

    var validationError =
        _validateIfMandatoryParametersWhereFound(parameterMap, current);
    if (validationError != null) {
      return current.failure(validationError);
    }

    parameterMap.addAll(_missingDefaultValues(parameterMap));

    return current.success(parameterMap);
  }

  @override
  ParametersParser copy() => ParametersParser(
      parserContext: parserContext,
      parameters: parameters,
      loopbackParser: loopbackParser);

  /// returns an validation error message or null when valid
  String? _validateIfMandatoryParametersWhereFound(
      ParameterMap parameterMap, Context context) {
    var missingMandatoryParameters = parameters.where((parameter) =>
        parameter.presence.mandatory &&
        !parameterMap.containsKey(parameter.name));
    if (missingMandatoryParameters.isNotEmpty) {
      if (missingMandatoryParameters.length == 1) {
        return 'missing mandatory function parameter: ${missingMandatoryParameters.first.name}';
      } else {
        return 'missing mandatory function parameters: ${missingMandatoryParameters.map((e) => e.name).join(', ')}';
      }
    }
    return null;
  }

  Map<String, Expression> _missingDefaultValues(
      Map<String, Expression> namesAndValues) {
    Map<String, Expression> missingDefaultValues = {};

    var optionalParametersWithDefaultValue = parameters
        .where((parameter) => parameter.presence.optionalWithDefaultValue);
    for (var optionalParameter in optionalParametersWithDefaultValue) {
      if (!namesAndValues.containsKey(optionalParameter.name)) {
        missingDefaultValues[optionalParameter.name] =
            Value(optionalParameter.presence.defaultValue);
      }
    }
    return missingDefaultValues;
  }
}

typedef ParameterParser = Parser<MapEntry<String, Expression>>;

/// Returns a parser that returns the value of an [ExpressionFunction] parameter
/// It uses a loopback parser which is an [expressionParser] so that it can
/// parse any known expression to a parameter value.
/// The [loopbackParser] is a SettableParser because the [expressionParser]
/// does not exist when this [parameterParser] is created.
ParameterParser parameterParser({
  required ParserContext parserContext,
  required Parameter parameter,
  required SettableParser loopbackParser,
  required bool withName,
}) {
  if (withName) {
    return (string(parameter.name).trim() & char('=').trim() & loopbackParser)
        .map((values) => MapEntry(parameter.name, values[2]));
  } else {
    return loopbackParser.map((value) => MapEntry(parameter.name, value));
  }
}
