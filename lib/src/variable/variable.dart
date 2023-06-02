import 'package:collection/collection.dart';

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
class Variables extends DelegatingMap<String, Object> {
  const Variables(super.base);

  List<String> get namePaths => _createNamePaths(this);

  List<String> _createNamePaths(Map<String, Object> variables,
      [String parentPath = '']) {
    List<String> namePaths = [];
    for (String name in variables.keys) {
      //TODO validate name
      String namePath = _createNamePath(parentPath, name);
      namePaths.add(namePath);
      var value = variables[name];
      if (value is Map<String, Object>) {
        // recursive call
        // TODO do we need to add something to prevent endless round trips?
        namePaths.addAll(_createNamePaths(value, namePath));
      }
    }
    return namePaths;
  }

  String _createNamePath(String parentPath, String name) {
    if (parentPath.isEmpty) {
      return name;
    } else {
      return '$parentPath.$name';
    }
  }

  Object? value(String namePath) => _findVariableValue(this, namePath, 0);
  Object? _findVariableValue(
      Map<String, Object> variables, String namePath, namePathIndex) {
    var names = namePath.split('.');
    var name = names[namePathIndex];

    if (variables.containsKey(name)) {
      var value = variables[name];
      if (names.length == namePathIndex + 1) {
        return value;
      } else if (value is Map<String, Object>) {
        // recursive:
        return _findVariableValue(value, namePath, namePathIndex + 1);
      }
    }
    throw VariableException('Variable name path could not be found: '
        '${names.sublist(0, namePathIndex + 1).join('.')}');
  }

  Variables clone() => Variables(Map<String, Object>.from(this));
}

class VariableException implements Exception {
  final String message;

  VariableException(this.message);
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
