import 'dart:math';

import 'package:collection/collection.dart';
import 'package:petitparser/petitparser.dart';
import 'package:template_engine/src/parser/override_message_parser.dart';
import 'package:template_engine/template_engine.dart';

Parser<Expression> functionsParser({
  required ParserContext context,
  required List<TagFunction<Object>> functions,
  required SettableParser loopbackParser,
  required bool verboseErrors,
}) {
  var parser = ChoiceParser<Expression>(
      functions.map((function) => functionParser(
          context: context,
          function: function,
          loopbackParser: loopbackParser)),
      failureJoiner: selectFarthest);
  if (verboseErrors) {
    return parser;
  } else {
    return OverrideMessageParser(parser, 'function expected');
  }
}

Parser<Expression> functionParser({
  required ParserContext context,
  required TagFunction<Object> function,
  required SettableParser loopbackParser,
}) {
  return (string(function.name, 'expected function name: ${function.name}') &
          char('(').trim() &
          ParametersParser(
              parserContext: context,
              parameters: function.parameters,
              loopbackParser: loopbackParser) &
          char(')').trim())
      .map((values) =>
          FunctionExpression(function, values[2] as Map<String, Expression>));
}

class FunctionExpression<R extends Object> extends Expression<R> {
  final TagFunction<R> tagFunction;
  final Map<String, Expression> parameterExpressionMap;

  FunctionExpression(this.tagFunction, this.parameterExpressionMap);

  @override
  R render(RenderContext context) {
    ParameterMap parameterMap = <String, Object>{};
    for (var name in parameterExpressionMap.keys) {
      var value = parameterExpressionMap[name]!.render(context);
      parameterMap[name] = value;
    }
    return tagFunction.function(parameterMap);
  }

  @override
  String toString() => 'Function{${tagFunction.name}}';
}

class DefaultFunctions extends DelegatingList<TagFunction> {
  DefaultFunctions()
      : super([
          Exp(),
          Log(),
          Sin(),
          Asin(),
          Cos(),
          Acos(),
          Tan(),
          Atan(),
          Sqrt(),
          StringLength()
        ]);
}

class Exp extends TagFunction<num> {
  Exp()
      : super(
            name: 'exp',
            parameters: [
              Parameter(name: 'value', presence: Presence.mandatory())
            ],
            function: (parameters) => exp(parameters['value'] as num));
}

class Log extends TagFunction<num> {
  Log()
      : super(
            name: 'log',
            parameters: [
              Parameter(name: 'value', presence: Presence.mandatory())
            ],
            function: (parameters) => log(parameters['value'] as num));
}

class Sin extends TagFunction<num> {
  Sin()
      : super(
            name: 'sin',
            parameters: [
              Parameter(name: 'value', presence: Presence.mandatory())
            ],
            function: (parameters) => sin(parameters['value'] as num));
}

class Asin extends TagFunction<num> {
  Asin()
      : super(
            name: 'asin',
            parameters: [
              Parameter(name: 'value', presence: Presence.mandatory())
            ],
            function: (parameters) => asin(parameters['value'] as num));
}

class Cos extends TagFunction<num> {
  Cos()
      : super(
            name: 'cos',
            parameters: [
              Parameter(name: 'value', presence: Presence.mandatory())
            ],
            function: (parameters) => cos(parameters['value'] as num));
}

class Acos extends TagFunction<num> {
  Acos()
      : super(
            name: 'acos',
            parameters: [
              Parameter(name: 'value', presence: Presence.mandatory())
            ],
            function: (parameters) => acos(parameters['value'] as num));
}

class Tan extends TagFunction<num> {
  Tan()
      : super(
            name: 'tan',
            parameters: [
              Parameter(name: 'value', presence: Presence.mandatory())
            ],
            function: (parameters) => tan(parameters['value'] as num));
}

class Atan extends TagFunction<num> {
  Atan()
      : super(
            name: 'atan',
            parameters: [
              Parameter(name: 'value', presence: Presence.mandatory())
            ],
            function: (parameters) => atan(parameters['value'] as num));
}

class Sqrt extends TagFunction<num> {
  Sqrt()
      : super(
            name: 'sqrt',
            parameters: [
              Parameter(name: 'value', presence: Presence.mandatory())
            ],
            function: (parameters) => sqrt(parameters['value'] as num));
}

class StringLength extends TagFunction<num> {
  StringLength()
      : super(
            name: 'length',
            parameters: [
              Parameter(name: 'value', presence: Presence.mandatory())
            ],
            function: (parameters) {
              var value = parameters['value'];
              if (value is String) {
                return value.length;
              } else {
                throw ParameterException('String expected');
              }
            });
}

class TagFunction<R extends Object> {
  TagFunction({
    required this.name,
    this.description,
    this.parameters = const [],
    required this.function,
  });

  final String name;
  final String? description;
  final List<Parameter> parameters;
  final R Function(Map<String, Object> parameters) function;
}

/// A [Tag] can have 0 or more [Parameter]s.
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
class Parameter<T> {
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
}

/// The [ParameterName]:
/// * must start with a letter, optionally followed by letters and or digits.
/// * is case sensitive .
///
/// E.g.: myValue1
class ParameterName {
  static final parser = (letter().plus() & digit().star()).plus().flatten();

  static validate(String name) {
    var result = parser.end().parse(name);
    if (result.isFailure) {
      throw ParameterException(
          'Parameter name: "$name" is invalid: ${result.message} at position: ${result.position}');
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
          if (result.isSuccess) {
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
    if (result.isSuccess) {
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

/// Returns a parser that returns the value of an [TagFunction] parameter
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
