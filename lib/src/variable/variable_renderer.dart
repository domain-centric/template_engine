import 'package:template_engine/src/error.dart';
import 'package:template_engine/template_engine.dart';

/// You can use [Variables](https://en.wikipedia.org/wiki/Variable_(computer_science))
/// in your [Template]s.
/// [Variables] in a [Template] look exactly like a [Tag] without [Attribute]s:
/// * [Variables] are surrounded with symbols like {{  }}
/// * [Variables] have a name or name path.
///
/// E.G.:{{name}} in a [Template] will be replaced by the [VariableValue] of
/// [Variable]: name
abstract class Variable {
  /// for documentation only
}

/// The [Variable]s are stored in a Map<String, Object?>,
/// where the String represents the [VariableName]
/// and the [Object?] represents the [VariableValue]
/// This map is given to the [TemplateEngine] as a constructor parameter.
abstract class Variables implements Map<String, Object?> {
  /// for documentation only
}

/// The [VariableName] identifies the [Variable] and corresponds with the keys
/// in the [Variables] map.
///
/// The [VariableName] may only contain letters or numbers and
/// is case sensitive.
///
/// Make sure that the variable name is unique and does not match a [TagName]
///
/// Variables can be nested. Concatenate [VariableName]s separated with dot's
/// to get the [VariableValue] of a nested [Variable].
///
/// E.g.:
/// [Variables] map: {'person': {'name': 'John Doe', 'age',30}}
/// [VariableName] person.name: refers to the [VariableValue] of 'John Doe'
abstract class VariableName {
  /// for documentation only
}

/// The [VariableValue]s are initialized when the [Variables] are given
/// to the [TemplateEngine] as a constructor parameter.
/// The [VariableValue]s can be manipulated during when
/// the [TemplateEngine.render] method is called.
///
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

/// A [RenderNode] to render a [VariableValue]
class VariableNode extends RenderNode {
  final List<String> namePath;
  final ErrorSource source;

  VariableNode({
    required this.source,

    /// See [VariableName]
    required String namePath,
  }) : namePath = namePath.split('.');

  @override
  String render(RenderContext context) {
    try {
      var value = findVariableValue(context.variables, namePath);
      return value.toString();
    } on VariableException catch (e) {
      context.errors.add(
          Error(stage: ErrorStage.render, message: e.message, source: source));
      return '';
    }
  }

  Object? findVariableValue(
      Map<String, Object?> variables, List<String> namePath,
      [namePathIndex = 0]) {
    if (variables.containsKey(namePath[namePathIndex])) {
      var value = variables[namePath[namePathIndex]];
      if (namePath.length == namePathIndex + 1) {
        return value;
      } else if (value != null && value is Map<String, Object?>) {
        // recursive:
        return findVariableValue(value, namePath, namePathIndex + 1);
      }
    }
    throw VariableException('Variable name path could not be found: '
        '${namePath.sublist(0, namePathIndex + 1).join('.')}');
  }
}

class VariableException implements Exception {
  final String message;

  VariableException(this.message);
}
