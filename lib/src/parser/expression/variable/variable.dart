// ignore_for_file: unintended_html_in_doc_comment

import 'package:template_engine/template_engine.dart';

/// A [variable](https://en.wikipedia.org/wiki/Variable_(computer_science)) is
/// a named container for some type of information
/// (like [num], [bool], [String] etc...)
abstract class Variable {}

final variableExamples = <TestFileExample>[
  TestFileExample.fromProjectFilePath(
    '/test/src/parser/expression/variable/variable_test.dart',
  ),
  TestFileExample.fromProjectFilePath(
    '/test/src/parser/expression/variable/nested_variable_test.dart',
  ),
];

/// A [DataMap] is a structure that stores information with keys and values.
/// The [key] is a name that identifies a value (case sensitive!)
/// A [value] can is normally on of the following types:
/// * [bool]
/// * [String]
/// * [num]
/// * A list of one of the types above
/// * A [DataMap]
///
/// An example of a [DataMap]:
///
/// DataMap dataMap = {
///   'person': {
///     'name': 'John Doe',
///     'age': 30,
///     'alive': true
///     'child': {
///       'name': 'Jane Doe',
///       'age': 5,
///     }
///   }
/// };
typedef DataMap = Map<String, dynamic>;

/// * Variables are stored as key, value pairs in a dart Map<String, dynamic> where:
///   * [key]=Variable name (case sensitive!)
///   * [value]=Variable value
/// * Variables can be used in an expression
/// * Initial variable values are passed to the TemplateEngine.render method
/// * Variables can be modified during rendering
typedef VariableMap = DataMap;

// /// An expression to return a variable value
// class VariableExpression implements Expression {
//   final TemplateLocation location;
//   final String namePath;
//   VariableExpression(this.location, this.namePath);

//   @override
//   String toString() => 'Variable{$namePath}';

//   Future<Object> _findVariableValue(
//     VariableMap variables,
//     List<String> namePath,
//     namePathIndex,
//   ) async {
//     var name = namePath[namePathIndex];
//     if (variables.containsKey(name)) {
//       var value = variables[name];
//       if (namePath.length == namePathIndex + 1) {
//         return Future.value(value!);
//       } else if (value is VariableMap) {
//         // recursive:
//         return await _findVariableValue(value, namePath, namePathIndex + 1);
//       }
//     }
//     throw VariableException(
//       'Variable '
//       '"${namePath.sublist(0, namePathIndex + 1).join('.')}" '
//       'does not exist',
//       location,
//     );
//   }

//   @override
//   evaluate(RenderContext context) {
//     try {
//       return _findVariableValue(context.variables, namePath.split('.'), 0);
//     } on VariableException catch (e) {
//       throw RenderError(e.message, location);
//     }
//   }
// }

// An expression to return a variable value
class VariableExpression implements Expression {
  final TemplateLocation location;
  final String variableName;
  VariableExpression(this.location, this.variableName);

  @override
  String toString() => 'variable $variableName';

  @override
  evaluate(RenderContext context) {
    if (context.variables.containsKey(variableName)) {
      return Future.value(context.variables[variableName]!);
    }
    throw VariableException(
      'Variable '
      '`$variableName` '
      'does not exist',
      location,
    );
  }
}

// An expression to return a property value from a Map expression
class MapPropertyExpression implements Expression {
  final TemplateLocation location;
  final Expression owner;
  final String propertyName;

  MapPropertyExpression({
    required this.location,
    required this.owner,
    required this.propertyName,
  });

  @override
  String toString() => '$owner.$propertyName';

  @override
  evaluate(RenderContext context) async {
    var ownerValue = await owner.evaluate(context);
    if (ownerValue is! Map<String, dynamic>) {
      throw PropertyException(
        '$owner is not a Map and therefore '
        'property `$propertyName` can not be accessed',
        location,
      );
    }
    if (!ownerValue.containsKey(propertyName)) {
      throw PropertyException(
        'Property `$propertyName` does not exist in $owner',
        location,
      );
    }
    return Future.value(ownerValue[propertyName]!);
  }
}

class VariableException extends RenderError {
  VariableException(super.message, super.position);
}

class PropertyException extends RenderError {
  PropertyException(super.message, super.position);
}

/// [VariableValue]s must be one of the following types:
/// * [bool]
/// * [String]
/// * [int]
/// * [double]
/// * [DateTime]
/// * [List] where the elements are one of the types above
/// * [Map] where the keys are a [String] and the values are
///   one of the types above
abstract class VariableValue {
  /// for documentation only
}
