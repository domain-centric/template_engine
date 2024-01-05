import 'package:petitparser/petitparser.dart';
import 'package:template_engine/template_engine.dart';

/// A [variable](https://en.wikipedia.org/wiki/Variable_(computer_science)) is
/// a named container for some type of information
/// (like [num], [bool], [String] etc...)
abstract class Variable {}

class VariableExamples implements ExampleFactory {
  @override
  List<String> createMarkdownExamples(
          RenderContext renderContext, int titleLevel) =>
      [
        '* ${ProjectFilePath('test/src/parser/tag/expression/variable/'
            'variable_test.dart').githubMarkdownLink}',
        '* ${ProjectFilePath('test/src/parser/tag/expression/variable/'
            'nested_variable_test.dart').githubMarkdownLink}',
      ];
}

/// A [DataMap] is a structure that stores information with keys and values.
/// The key is a name that identifies a value
/// A value can is normally on of the following types:
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
///   * String=Variable name
///   * dynamic=Variable value
/// * Variables can be used in an [ExpressionTag]
/// * Initial variable values are passed to the TemplateEngine.render method
/// * Variables can be modified during rendering
typedef VariableMap = DataMap;

/// An expression to return a variable value
class VariableExpression extends Expression {
  final String namePath;
  final String position;
  VariableExpression({required this.position, required this.namePath});

  @override
  String toString() => 'Variable{$namePath}';

  Future<Object> _findVariableValue(
      VariableMap variables, List<String> namePath, namePathIndex) async {
    var name = namePath[namePathIndex];

    if (variables.containsKey(name)) {
      var value = variables[name];
      if (namePath.length == namePathIndex + 1) {
        if (value == null) {
          throw VariableException(
              message: 'Variable: $namePath may not be null',
              position: position);
        }
        return Future.value(value!);
      } else if (value is VariableMap) {
        // recursive:
        return await _findVariableValue(value, namePath, namePathIndex + 1);
      }
    }
    throw VariableException(
        message: 'Variable does not exist: '
            '${namePath.sublist(0, namePathIndex + 1).join('.')}',
        position: position);
  }

  @override
  Future<Object> render(RenderContext context) {
    try {
      return _findVariableValue(context.variables, namePath.split('.'), 0);
    } on VariableException catch (e) {
      throw RenderException(message: e.message, position: position);
    }
  }
}

Parser<Expression<Object>> variableParser(Template template) {
  return (VariableName.namePathParser & char('(').trim().not())
      .flatten('variable expected')
      .trim()
      .valueContextMap((name, context) => VariableExpression(
          namePath: name, position: context.toPositionString()));
}

class VariableException extends RenderException {
  VariableException({required super.message, required super.position});
}

/// The [VariableName] identifies the [Variable] and corresponds with the keys
/// in the [VariableMap] map.
///
/// The [VariableName]:
/// * must be unique and does not match a other [Tag] syntax
/// * must start with a letter, optionally followed by letters and or digits
/// * is case sensitive (convention: use [camelCase](https://en.wikipedia.org/wiki/Camel_case))
///
/// Variables can be nested. Concatenate [VariableName]s separated with dot's
/// to get the [VariableValue] of a nested [Variable].
///
/// E.g.:<br>
/// Variable map: {'person': {'name': 'John Doe', 'age',30}}<br>
/// Variable Name person.name: refers to the variable value of 'John Doe'

class VariableName {
  static final nameParser = (letter().plus() & digit().star()).plus();
  static final namePathParser = (nameParser & (char('.') & nameParser).star());

  static validateName(String name) {
    var result = nameParser.end().parse(name);
    if (result is Failure) {
      throw Exception('Variable name: "$name" is invalid: ${result.message} '
          'at position: ${result.position}');
    }
  }

  static validateNamePath(String namePath) {
    var result = namePathParser.end().parse(namePath);
    if (result is Failure) {
      throw Exception(
          'Variable name: "$namePath" is invalid: ${result.message} '
          'at position: ${result.position}');
    }
  }
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
