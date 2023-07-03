import 'dart:math';

import 'package:collection/collection.dart';
import 'package:petitparser/petitparser.dart';
import 'package:template_engine/template_engine.dart';

class FunctionExpression<R extends Object> extends Expression<R> {
  final TagFunction<R> definition;
  final Expression parameter;

  FunctionExpression(
    this.definition,
    this.parameter,
  );

  @override
  R eval(Map<String, Object> variables) {
    var parameters = <String, Object>{'value': parameter.eval(variables)};
    return definition.function(parameters);
  }

  @override
  String toString() => 'Function{${definition.name}}';
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
            function: (parameters) => exp(parameters['value'] as num));
}

class Log extends TagFunction<num> {
  Log()
      : super(
            name: 'log',
            function: (parameters) => log(parameters['value'] as num));
}

class Sin extends TagFunction<num> {
  Sin()
      : super(
            name: 'sin',
            function: (parameters) => sin(parameters['value'] as num));
}

class Asin extends TagFunction<num> {
  Asin()
      : super(
            name: 'asin',
            function: (parameters) => asin(parameters['value'] as num));
}

class Cos extends TagFunction<num> {
  Cos()
      : super(
            name: 'cos',
            function: (parameters) => cos(parameters['value'] as num));
}

class Acos extends TagFunction<num> {
  Acos()
      : super(
            name: 'acos',
            function: (parameters) => acos(parameters['value'] as num));
}

class Tan extends TagFunction<num> {
  Tan()
      : super(
            name: 'tan',
            function: (parameters) => tan(parameters['value'] as num));
}

class Atan extends TagFunction<num> {
  Atan()
      : super(
            name: 'atan',
            function: (parameters) => atan(parameters['value'] as num));
}

class Sqrt extends TagFunction<num> {
  Sqrt()
      : super(
            name: 'sqrt',
            function: (parameters) => sqrt(parameters['value'] as num));
}

class StringLength extends TagFunction<num> {
  StringLength()
      : super(
            name: 'length',
            function: (parameters) {
              var value = parameters['value'];
              if (value is String) {
                return value.length;
              } else {
                throw ParameterException('String expected');
              }
            });
}

// /// A [Tag] is a [Tag] that generates the result using a
// /// Dart [] that you can write yourself.
// /// You can use attributes inside a [Tag].
// /// These will be passed to the Dart [] together with the [ParserContext]
// ///
// /// Example of an [Tag]: {{greetings name='world'}}
// ///
// /// Note that attribute values can also be a tag. In the following example the
// /// name attributes gets value of variable name.
// /// Example : {{greetings name={{name}} }}
// abstract class Tag<T extends Object> extends Tag {
//   /// A [Tag] may have 0 or more [Parameter]s
//   final List<Parameter> attributeDefinitions;

//   Tag({
//     required super.name,
//     required super.description,
//     this.attributeDefinitions = const [],
//   });

//   @override
//   Parser<T> createTagParser(ParserContext context) =>
//       _createParserWithoutMapping(context, failsOnParameterError: true)
//           .map2((values, parsePosition) {
//         return createParserResult(
//           context: context,
//           attributes: values[3],
//           source: TemplateSource(
//             template: context.template,
//             parserPosition: parsePosition,
//           ),
//         );
//       });

//   Parser<List<dynamic>> _createParserWithoutMapping(ParserContext context,
//       {required bool failsOnParameterError}) {
//     return (string(context.tagStart) &
//         optionalWhiteSpace() &
//         stringIgnoreCase(name) &
//         ParametersParser(
//           parserContext: context,
//           attributes: attributeDefinitions,
//           failsOnError: failsOnParameterError,
//         ) &
//         optionalWhiteSpace() &
//         string(context.tagEnd));
//   }

//   /// creates a parser that returns success when a [Tag] is found but the attributes contains an error.
//   /// It will return a map with attribute errors
//   Parser<Map<String, Object>>
//       createTagParserThatReturnsMapWithParameterErrors(
//               ParserContext context) =>
//           _createParserWithoutMapping(context, failsOnParameterError: false)
//               .map((values) {
//             return values[3];
//           });

//   T createParserResult({
//     required ParserContext context,
//     required TemplateSource source,
//     required Map<String, Object> attributes,
//   });

//   @override
//   String documentation(ParserContext context) => [
//         'Example: ${example(context)}',
//         description,
//         ...attributeDocumentation
//       ].join('\n');

//   List<String> get attributeDocumentation {
//     var attributeDoc = <String>[];
//     if (attributeDefinitions.isNotEmpty) {
//       attributeDoc.add('Parameters:');
//     }
//     for (var attribute in attributeDefinitions) {
//       attributeDoc.add('* ${attribute.name}');
//       if (attribute.description != null &&
//           attribute.description!.trim().isNotEmpty) {
//         attributeDoc.add('  Description: ${attribute.description}');
//       }
//       attributeDoc.add(
//           '  ${attribute.optional ? 'Usage: optional' : 'Usage: mandatory'}');
//       if (attribute.optional && attribute.defaultValue != null) {
//         attributeDoc.add('  Default value: ${attribute.defaultValue}');
//       }
//     }
//     return attributeDoc;
//   }
// }

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

/// See [attributeValueParser] for the [ParameterValue] types that are supported
abstract class ParameterValue {
  // for documentation only;
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

typedef Parameters = Map<String, Object>;

/// Creates parsers for each parameter:
/// * no parameters
/// * one parameter: value or name=value
/// * multiple parameters: name=value, name=value etc...
/// Then validates the result and converts parameters to a name-value [Map]
class ParametersParser extends Parser<Map<String, Object>> {
  final ParserContext parserContext;
  final List<ParameterParser> parameterParsers;
  final List<Parameter> parameters;
  final bool failsOnError;

  ParametersParser({
    required this.parserContext,
    required this.parameters,
    required this.failsOnError,
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
  Result<Map<String, Object>> parseOn(Context context) {
    List<Error> errors = [];
    Parameters namesAndValues = {};
    var current = context;

    ParameterParser? parserWithSuccess;
    do {
      parserWithSuccess = null;
      //TODO add separation comma's
      for (var parser in parameterParsers) {
        if (parserWithSuccess == null) {
          var result = parser.parseOn(current);
          if (result.isSuccess) {
            parserWithSuccess = parser;
            namesAndValues.addEntries([result.value]);
            current = result;
          }
        }
      }
      if (parserWithSuccess != null) {
        // remove parser for efficiency
        parameterParsers.remove(parserWithSuccess);
      }
    } while (parserWithSuccess != null);

    var remainingParser = (whitespace().plus().flatten()) &
        untilEndOfTagParser(parserContext.tagStart, parserContext.tagEnd);
    var result = remainingParser.parseOn(current);
    if (result.isSuccess) {
      var remainingText = result.value[1].trim();
      if (remainingText.isNotEmpty) {
        errors.add(Error(
            source: _createTemplateSource(current),
            message: 'Invalid parameter: $remainingText',
            stage: ErrorStage.parse));
      }
      current = result;
    }

    errors.addAll(
        _validateIfMandatoryParametersWhereFound(namesAndValues, current));

    namesAndValues.addAll(_missingDefaultValues(namesAndValues));

    if (failsOnError) {
      if (errors.isEmpty) {
        return current.success(namesAndValues);
      } else {
        return current.failure(errors.join('\n'));
      }
    } else {
      var errorMap = {
        for (int i = 0; i < errors.length; i++) i.toString(): errors[i]
      };
      return current.success(errorMap);
    }
  }

  @override
  ParametersParser copy() => ParametersParser(
        parserContext: parserContext,
        parameters: parameters,
        failsOnError: failsOnError,
      );

  List<Error> _validateIfMandatoryParametersWhereFound(
      Parameters parameterNamesAndValues, Context context) {
    var missingMandatoryParameters = parameters.where((parameter) =>
        parameter.presence == Presence.mandatory() &&
        !parameterNamesAndValues.containsKey(parameter.name));
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

  Map<String, Object> _missingDefaultValues(
      Map<String, Object> namesAndValues) {
    Map<String, Object> missingDefaultValues = {};

    var optionalParametersWithDefaultValue = parameters
        .where((parameter) => parameter.presence.optionalWithDefaultValue);
    for (var optionalParameter in optionalParametersWithDefaultValue) {
      if (!namesAndValues.containsKey(optionalParameter.name)) {
        missingDefaultValues[optionalParameter.name] =
            optionalParameter.presence.defaultValue;
      }
    }
    return missingDefaultValues;
  }

  TemplateSource _createTemplateSource(Context context) => TemplateSource(
      template: parserContext.template,
      parserPosition: context.toPositionString());
}

typedef ParameterParser = Parser<MapEntry<String, Expression>>;

/// Returns a parser that returns the value of an attribute
/// Note that it must start with a whitespace for separation!
ParameterParser parameterParser({
  required ParserContext parserContext,
  required Parameter parameter,
  required ParameterParserType parserType,
}) {
  if (parserType == ParameterParserType.withName) {
    return (optionalWhiteSpace() &
            stringIgnoreCase(parameter.name) &
            optionalWhiteSpace() &
            char('=') &
            expressionParser(parserContext))
        .map((values) => MapEntry(parameter.name, values[4]));
  } else {
    return expressionParser(parserContext)
        .map((value) => MapEntry(parameter.name, value));
  }
}

enum ParameterParserType { withName, withoutName }
