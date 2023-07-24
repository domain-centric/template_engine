import 'package:petitparser/petitparser.dart';
import 'package:template_engine/template_engine.dart';

/// A [variable](https://en.wikipedia.org/wiki/Variable_(computer_science)) is
/// a named container for some type of information
/// (like [num], [bool], [String] etc...)
abstract class Variable {
  // documentation only
}

/// * Variables are stored as key, value pairs in a dart Map<String, Object> where:
///   * String=Variable name
///   * Object=Variable value
/// * Variables be used in an [ExpressionTag]
/// * Initial variable values are passed to the TemplateEngine.render method
/// * Variables can be modified during rendering
typedef Variables = Map<String, Object>;

/// An expression to return a variable value
class VariableExpression extends Expression {
  final Source source;
  VariableExpression(this.source, this.namePath);

  final String namePath;

  @override
  String toString() => 'Variable{$namePath}';

  Object _findVariableValue(
      Variables variables, List<String> namePath, namePathIndex) {
    var name = namePath[namePathIndex];

    if (variables.containsKey(name)) {
      var value = variables[name];
      if (namePath.length == namePathIndex + 1) {
        if (value == null) {
          VariableException('Variable: $namePath may not be null');
        }
        return value!;
      } else if (value is Map<String, Object>) {
        // recursive:
        return _findVariableValue(value, namePath, namePathIndex + 1);
      }
    }
    throw VariableException('Variable does not exist: '
        '${namePath.sublist(0, namePathIndex + 1).join('.')}');
  }

  @override
  Object render(RenderContext context) {
    try {
      return _findVariableValue(context.variables, namePath.split('.'), 0);
    } on VariableException catch (e) {
      context.errors.add(Error.fromSource(
          stage: ErrorStage.render, source: source, message: e.message));
      return namePath;
    }
  }
}

Parser<Expression<Object>> variableParser(Template template) {
  return (VariableName.pathParser & char('(').trim().not())
      .flatten('variable expected')
      .trim()
      .valueContextMap((name, context) =>
          VariableExpression(Source.fromContext(template, context), name));
}

class VariableException implements Exception {
  final String message;

  VariableException(this.message);
}

/// The [VariableName] identifies the [Variable] and corresponds with the keys
/// in the [Variables] map.
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
///
/// Examples:
/// * [Variable Example](https://github.com/domain-centric/template_engine/blob/main/example/tag_variable_simple.dart)
/// * [Nested Variable Example](https://github.com/domain-centric/template_engine/blob/main/example/tag_variable_nested.dart)

class VariableName {
  static final _parser = (letter().plus() & digit().star()).plus();
  static final pathParser = (_parser & (char('.') & _parser).star());

  static validate(String namePath) {
    var result = pathParser.end().parse(namePath);
    if (result.isFailure) {
      throw VariableException(
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
