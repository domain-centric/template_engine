import 'dart:math';

import 'package:collection/collection.dart';
import 'package:petitparser/petitparser.dart';
import 'package:template_engine/src/parser/override_message_parser.dart';
import 'package:template_engine/template_engine.dart';

Parser<Expression> functionsParser(
        ParserContext context, List<TagFunction<Object>> functions) =>
    OverrideMessageParser(
        ChoiceParser(
            functions.map((function) => functionParser(context, function))),
        'function expected');

Parser<Expression> functionParser(
    ParserContext context, TagFunction<Object> function) {
  return (string(function.name, 'expected function name: ${function.name}') &
          char('(').trim() &
          ParametersParser(
              parserContext: context, parameters: function.parameters) &
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
            parameters: [Parameter(name: 'value')],
            function: (parameters) => exp(parameters['value'] as num));
}

class Log extends TagFunction<num> {
  Log()
      : super(
            name: 'log',
            parameters: [Parameter(name: 'value')],
            function: (parameters) => log(parameters['value'] as num));
}

class Sin extends TagFunction<num> {
  Sin()
      : super(
            name: 'sin',
            parameters: [Parameter(name: 'value')],
            function: (parameters) => sin(parameters['value'] as num));
}

class Asin extends TagFunction<num> {
  Asin()
      : super(
            name: 'asin',
            parameters: [Parameter(name: 'value')],
            function: (parameters) => asin(parameters['value'] as num));
}

class Cos extends TagFunction<num> {
  Cos()
      : super(
            name: 'cos',
            parameters: [Parameter(name: 'value')],
            function: (parameters) => cos(parameters['value'] as num));
}

class Acos extends TagFunction<num> {
  Acos()
      : super(
            name: 'acos',
            parameters: [Parameter(name: 'value')],
            function: (parameters) => acos(parameters['value'] as num));
}

class Tan extends TagFunction<num> {
  Tan()
      : super(
            name: 'tan',
            parameters: [Parameter(name: 'value')],
            function: (parameters) => tan(parameters['value'] as num));
}

class Atan extends TagFunction<num> {
  Atan()
      : super(
            name: 'atan',
            parameters: [Parameter(name: 'value')],
            function: (parameters) => atan(parameters['value'] as num));
}

class Sqrt extends TagFunction<num> {
  Sqrt()
      : super(
            name: 'sqrt',
            parameters: [Parameter(name: 'value')],
            function: (parameters) => sqrt(parameters['value'] as num));
}

class StringLength extends TagFunction<num> {
  StringLength()
      : super(
            name: 'length',
            parameters: [Parameter(name: 'value')],
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
/// * is case unsensitive .
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
  //TODO add TemplateSource
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
  final _remainingParser =
      (any().plusLazy(char(')'))).flatten().trim().map((value) => value);

  final ParserContext parserContext;
  final List<ParameterParser> parameterParsers;
  final List<Parameter> parameters;

  ParametersParser({
    required this.parserContext,
    required this.parameters,
  }) : parameterParsers = parameters
            .map((parameter) => parameterParser(
                  parserContext: parserContext,
                  parameter: parameter,
                  parserType: parameters.length == 1
                      ? ParameterParserType.withoutName
                      : ParameterParserType.withName,
                ))
            .toList();

  @override
  Result<Map<String, Expression>> parseOn(Context context) {
    List<Error> errors = [];
    var parameterMap = <String, Expression>{};
    var current = context;
    var unUsedParameterParsers = [...parameterParsers];
    ParameterParser? parserWithSuccess;
    do {
      parserWithSuccess = null;
      //TODO add separation comma's
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
      }
    } while (parserWithSuccess != null);

    var result = _remainingParser.parseOn(current);
    if (result.isSuccess) {
      var remainingText = result.value;
      if (remainingText.isNotEmpty) {
        errors.add(Error(
            source: _createTemplateSource(current),
            message: 'Invalid parameter: $remainingText',
            stage: ErrorStage.parse));
      }
      current = result;
    }

    errors.addAll(
        _validateIfMandatoryParametersWhereFound(parameterMap, current));

    parameterMap.addAll(_missingDefaultValues(parameterMap));

    if (errors.isEmpty) {
      return current.success(parameterMap);
    } else {
      return current.failure(errors.join('\n'));
    }
  }

  @override
  ParametersParser copy() =>
      ParametersParser(parserContext: parserContext, parameters: parameters);

  List<Error> _validateIfMandatoryParametersWhereFound(
      ParameterMap parameterMap, Context context) {
    var missingMandatoryParameters = parameters.where((parameter) =>
        parameter.presence == Presence.mandatory() &&
        !parameterMap.containsKey(parameter.name));
    if (missingMandatoryParameters.isNotEmpty) {
      if (missingMandatoryParameters.length == 1) {
        return [
          Error(
            stage: ErrorStage.parse,
            source: _createTemplateSource(context),
            message:
                'Missing mandatory parameter: ${missingMandatoryParameters.first.name}',
          )
        ];
      } else {
        return [
          Error(
            stage: ErrorStage.parse,
            source: _createTemplateSource(context),
            message:
                'Missing mandatory parameters: ${missingMandatoryParameters.map((e) => e.name).join(', ')}',
          )
        ];
      }
    }
    return [];
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

  TemplateSource _createTemplateSource(Context context) => TemplateSource(
      template: parserContext.template,
      parserPosition: context.toPositionString());
}

typedef ParameterParser = Parser<MapEntry<String, Expression>>;

/// Returns a parser that returns the value of an [TagFunction] parameter
/// Note that it must start with a whitespace for separation!
ParameterParser parameterParser({
  required ParserContext parserContext,
  required Parameter parameter,
  required ParameterParserType parserType,
}) {
  if (parserType == ParameterParserType.withName) {
    return (stringIgnoreCase(parameter.name).trim() &
            char('=').trim() &
            ChoiceParser([
              numberParser(),
              quotedStringParser()
            ]).map((value) => Value(
                value))) //TODO replace with expressionParser(parserContext)) without causing a stack overflow (with loopBackParser??)
        .map((values) => MapEntry(parameter.name, values[2]));
  } else {
    return ChoiceParser([numberParser(), quotedStringParser()])
        .map((value) => Value(
            value)) //TODO replace with expressionParser(parserContext)) without causing a stack overflow (with loopBackParser??)
        .map((value) => MapEntry(parameter.name, value));
  }
}

enum ParameterParserType { withName, withoutName }
