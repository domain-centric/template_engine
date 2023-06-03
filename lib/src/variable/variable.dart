import 'package:collection/collection.dart';
import 'package:petitparser/petitparser.dart';

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

  void validateNames() {
    var variableName = VariableName();
    for (var namePath in namePaths) {
      variableName.validate(namePath);
    }
  }
}

class VariableException implements Exception {
  final String message;

  VariableException(this.message);
}

/// The [VariableName] identifies the [Variable] and corresponds with the keys
/// in the [Variables] map.
///
/// The [VariableName]:
/// * must be unique and does not match a [TagName]
/// * must start with a letter, optionally followed by letters and or digits.
/// * is case sensitive.
///
/// Variables can be nested. Concatenate [VariableName]s separated with dot's
/// to get the [VariableValue] of a nested [Variable].
///
/// E.g.:
/// [Variables] map: {'person': {'name': 'John Doe', 'age',30}}
/// [VariableName] person.name: refers to the [VariableValue] of 'John Doe'
class VariableName {
  static final nameParser = (letter().plus() & digit().star()).plus();
  static final namePathParser =
      (nameParser & (char('.') & nameParser).star()).end();

  validate(String namePath) {
    var result = namePathParser.parse(namePath);
    if (result.isFailure) {
      throw VariableException(
          'Variable name: $namePath is invalid: ${result.message} at position: ${result.position}');
    }
  }
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
