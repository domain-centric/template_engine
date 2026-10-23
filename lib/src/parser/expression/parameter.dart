import 'package:template_engine/template_engine.dart';

/// A [FunctionDefinition]s or [MethodDefinition]s can have 0 or more [Parameter]s.
/// A [Parameter]:
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
///  * Can have a default value when the attribute is optional
class Parameter<T> {
  /// See [ParameterName]
  final String name;

  /// Optional description
  final String? description;

  final Presence presence;

  Type get valueType => T;

  Parameter({required this.name, this.description, required this.presence}) {
    validateIdentifier(nameType: 'parameter name', nameToValidate: name);
  }

  String createHtmlTableRow() => HtmlTableRow(
    ['parameter:', name, typeDescription(T), presence.toString(), ?description],
    [1, 1, 1, description == null ? 2 : 1, 1],
  ).toHtml();

  /// Throws ArgumentTypeError when needed
  void validateType(TemplateLocation location, dynamic value) {
    if (value is! T) {
      throw ArgumentTypeError(
        'Argument for parameter `$name` must be type ${typeDescription(T)} '
        'but was ${value.runtimeType}',
        location,
      );
    }
  }
}

class ArgumentTypeError implements RenderError {
  @override
  final TemplateLocation location;

  @override
  final String message;

  ArgumentTypeError(this.message, this.location);
}

abstract class Presence {}

class PresenceMandatory implements Presence {
  @override
  String toString() => 'mandatory';
}

class PresenceOptional implements Presence {
  @override
  String toString() => 'optional';
}

class PresenceOptionalWithDefaultValue implements Presence {
  final dynamic defaultValue;

  PresenceOptionalWithDefaultValue(this.defaultValue);

  @override
  String toString() => 'optional (default value: $defaultValue)';
}

/// [Arguments] is a [Map] of parameter names and values
typedef Arguments = Map<String, Object>;

extension ParametersExtension on List<Parameter> {
  List<String> get names => map((p) => p.name).toList();
  List<String> get lowerCaseNames => map((p) => p.name.toLowerCase()).toList();
}

enum ParameterOwner { function, method }

String parameterAndArgumentDocumentation(
  int titleLevel,
  ParameterOwner owner,
) => [
  markdownTitle(titleLevel, 'Parameters and Arguments'),
  '**Parameter & argument names:**',
  '* are [case unsensitive sensitive](https://en.wikipedia.org/wiki/Case_sensitivity)',
  '* must start with a letter, optionally followed by '
      'letters and or digits.',
  '* preferred convention: prefer to use [lowerCamelCase](https://en.wikipedia.org/wiki/Camel_case)',
  '* must be unique and does not match reserved key words (e.g. statements and constants)',
  '',
  '**Parameters vs Arguments**',
  '* Parameters are the names used in the $owner definition.',
  '* Arguments are the actual values passed when calling the $owner.',
  '',
  '**Parameters:**',
  '* A $owner can have zero or more parameters',
  '* Parameters are defined as either mandatory or optional',
  '* Optional parameters can have a default value',
  '',
  '**Arguments:**',
  '* Multiple arguments are separated with a comma, e.g.: ',
  if (owner == ParameterOwner.function)
    'single argument: `cos(pi)` multiple arguments: `volume(10,20,30)`',
  if (owner == ParameterOwner.method)
    "single argument: `'Hello'.right(2)` multiple arguments: "
        "`'Telephone'.replaceFirst('phone','vision')`",
  '* There are different types of arguments',
  '  * Positional Arguments: These are passed in the order the function '
      'defines them. e.g.: ',
  if (owner == ParameterOwner.function) '`volume(10, 20, 30)`',
  if (owner == ParameterOwner.method)
    "`'Telephone'.replaceFirst('phone','vision')`",
  '  * Named Arguments: You can specify which parameter you\'re assigning a '
      'value to, regardless of order. e.g.: ',
  if (owner == ParameterOwner.function) '`volume(l=30, h=10, w=20)`',
  if (owner == ParameterOwner.method)
    "`'Telephone'.replaceFirst(from:'phone',to:'vision')`",
  '* Arguments can set a parameter value only once',
  '* You can mix positional arguments and named arguments, but positional '
      'arguments must come first',
  '* Named arguments remove ambiguity: If you want to skip an optional '
      'argument or specify one out of order, you must name it explicitly',
  '',
  '**Argument values:**',
  '* must match the expected parameter type. e.g. '
      '`area(length=\'hello\', width=\'world\')` will result in a error',
  '* may be a expression such as a variable, constant, operation, '
      'function, or combination. e.g. `cos(2*pi)`',
  '',
].join('\n');
