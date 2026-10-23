import 'package:collection/collection.dart';
import 'package:template_engine/template_engine.dart';

abstract class ArgumentExpression implements Expression {
  TemplateLocation get location;
  Expression get value;
}

class PositionalArgumentExpression implements ArgumentExpression {
  @override
  final TemplateLocation location;

  @override
  final Expression value;

  PositionalArgumentExpression(this.location, this.value);

  @override
  Future<dynamic> evaluate(RenderContext context) async =>
      await value.evaluate(context);
}

class NamedArgumentExpression implements ArgumentExpression {
  @override
  final TemplateLocation location;

  final String name;

  @override
  final Expression value;

  NamedArgumentExpression(this.location, this.name, this.value) {
    validateIdentifier(nameType: 'argument', nameToValidate: name);
  }

  @override
  Future<dynamic> evaluate(RenderContext context) async =>
      await value.evaluate(context);
}

class ArgumentDefaultExpression implements ArgumentExpression {
  @override
  final TemplateLocation location;

  @override
  final Expression value;

  ArgumentDefaultExpression(this.location, dynamic value)
    : value = LiteralExpression(value);

  @override
  Future<dynamic> evaluate(RenderContext context) async =>
      await value.evaluate(context);
}

/// [ArgumentExpressionList] is the result after parsing.
/// It is not yet validated because the parameters may not be known at
/// parsing.
///
/// E.g. the method parameters are unknown since the method owner type
/// is known at rendering (after parsing)
///
/// The validating and mapping the [ArgumentExpressionList] is therefore
/// done by [ArgumentExpressionMap]
class ArgumentExpressionList extends DelegatingList<ArgumentExpression> {
  final TemplateLocation endOfArguments;

  ArgumentExpressionList(this.endOfArguments, super.argumentExpressions);
}

/// Validates and maps a parsed [ArgumentExpressionList]
/// to parameter names and expressions
///
/// An [ArgumentExpressionList] only represents the arguments as they were
/// parsed from a template. At that stage, no validation can be performed
/// because the target method or function signature may not yet be known.
///
/// [ArgumentExpressionMap] performs this validation once the available
/// [parameters] are known. During construction it:
///
/// * Maps positional arguments to parameters by position.
/// * Resolves named arguments to parameters by name (case-insensitive).
/// * Reports unknown parameter names.
/// * Reports duplicate arguments.
/// * Reports positional arguments that appear after named arguments.
/// * Reports when more arguments are supplied than there are parameters.
/// * Inserts [ArgumentDefaultExpression] instances for optional parameters
///   with default values that were not explicitly provided.
/// * Reports missing mandatory parameters.
///
/// Any validation problems encountered during mapping are collected in
/// [errors].
///
/// After successful validation, [evaluate] resolves all argument
/// expressions using the corresponding parameter definitions and returns
/// a map containing the evaluated argument values keyed by parameter name.
class ArgumentExpressionMap
    extends UnmodifiableMapView<String, ArgumentExpression> {
  ArgumentExpressionMap._(
    this.parameters,
    super.argumentExpressionMap,
    this.endOfArguments,
    this.errors,
  );

  final List<Parameter> parameters;
  final List<ParseError> errors;
  final TemplateLocation endOfArguments;

  static int noMorePositionalArguments = -1;

  factory ArgumentExpressionMap(
    ArgumentExpressionList argumentExpressionList,
    List<Parameter> parameters,
  ) {
    var errors = <ParseError>[];
    var argumentExpressionMap = <String, ArgumentExpression>{};
    var index = 0;
    for (var argumentExpression in argumentExpressionList) {
      if (argumentExpression is PositionalArgumentExpression) {
        if (index == noMorePositionalArguments) {
          errors.add(
            ParseError(
              'Positional arguments must precede named arguments',
              argumentExpression.location,
            ),
          );
          // break;
        } else if (index >= parameters.length) {
          errors.add(
            ParseError(
              'More arguments than there are parameters',
              argumentExpression.location,
            ),
          );
          // break;
        } else {
          var parameter = parameters[index];
          argumentExpressionMap[parameter.name] = argumentExpression;
          index++;
        }
      } else if (argumentExpression is NamedArgumentExpression) {
        var lowerCaseName = argumentExpression.name.toLowerCase();
        var parameter = parameters.firstWhereOrNull(
          (p) => p.name.toLowerCase() == lowerCaseName,
        );
        if (parameter == null) {
          errors.add(
            ParseError(
              'Unknown parameter name: ${argumentExpression.name}',
              argumentExpression.location,
            ),
          );
        } else if (argumentExpressionMap.keys.contains(parameter.name)) {
          errors.add(
            ParseError(
              'Parameter ${parameter.name} was specified more than once',
              argumentExpression.location,
            ),
          );
        } else {
          argumentExpressionMap[parameter.name] = argumentExpression;
          index = noMorePositionalArguments;
        }
      }
    }

    argumentExpressionMap.addAll(
      _missingOptionalDefaultValues(
        parameters,
        argumentExpressionList.endOfArguments,
        argumentExpressionMap,
      ),
    );

    var missingArgumentError = _validateMissingArguments(
      argumentExpressionList.endOfArguments,
      parameters,
      argumentExpressionMap,
    );
    if (missingArgumentError != null) {
      errors.add(missingArgumentError.toParseError);
    }

    return ArgumentExpressionMap._(
      parameters,
      argumentExpressionMap,
      argumentExpressionList.endOfArguments,
      errors,
    );
  }

  static Map<String, ArgumentExpression> _missingOptionalDefaultValues(
    List<Parameter> parameters,
    TemplateLocation endOfArguments,
    Map<String, ArgumentExpression> args,
  ) => <String, ArgumentExpression>{
    for (var parameter in parameters.where(
      (p) =>
          p.presence is PresenceOptionalWithDefaultValue &&
          !args.containsKey(p.name),
    ))
      parameter.name: ArgumentDefaultExpression(
        endOfArguments,
        (parameter.presence as PresenceOptionalWithDefaultValue).defaultValue,
      ),
  };

  /// returns an error when arguments are missing
  static MissingArgumentError? _validateMissingArguments(
    TemplateLocation endOfArguments,
    List<Parameter> parameters,
    Map<String, dynamic> foundArguments,
  ) {
    var lowerCaseArgumentNames = foundArguments.keys.map(
      (argumentName) => argumentName.toLowerCase(),
    );
    var missingParameters = parameters.where(
      (parameter) =>
          parameter.presence is PresenceMandatory &&
          !lowerCaseArgumentNames.contains(parameter.name.toLowerCase()),
    );
    if (missingParameters.isEmpty) {
      return null;
    }
    if (missingParameters.length == 1) {
      return MissingArgumentError(
        'Missing argument for parameter: ${missingParameters.first.name}',
        endOfArguments,
      );
    } else {
      return MissingArgumentError(
        'Missing arguments for parameters: '
        '${missingParameters.map((parameter) => parameter.name).join(', ')}',
        endOfArguments,
      );
    }
  }

  /// converts the [ArgumentExpressionMap] to a map
  /// with argument names and values
  /// Errors are added to the [context]
  ///
  /// If the map is invalid it will throw an error,
  /// which must be caught by a statement or a expression block,
  /// which in turn will generate a errorPlaceHolder
  Future<Map<String, dynamic>> evaluate(RenderContext context) async {
    var argumentValueMap = <String, dynamic>{};
    for (var name in keys) {
      var parameter = parameters.firstWhere((p) => p.name == name);
      var expression = this[name]!;
      var value = await expression.evaluate(context);
      parameter.validateType(expression.location, value);
      argumentValueMap[name] = value;
    }
    var missingArgumentError = _validateMissingArguments(
      endOfArguments,
      parameters,
      argumentValueMap,
    );
    if (missingArgumentError != null) {
      throw missingArgumentError;
    }
    return argumentValueMap;
  }

  Map<String, TemplateLocation> toLocationMap() => <String, TemplateLocation>{
    for (var name in keys) name: this[name]!.location,
  };
}

class MissingArgumentError implements TemplateEngineException {
  @override
  final String message;
  @override
  final TemplateLocation location;

  MissingArgumentError(this.message, this.location);

  ParseError get toParseError => ParseError(message, location);

  RenderError get toRenderError => RenderError(message, location);
}
