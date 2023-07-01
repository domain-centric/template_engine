/// An abstract expression that can be evaluated.
/// It is a combination of one or more:
/// * [Value]s
/// * [Variable]s
/// * [TagFunction]s
/// * [Operator]s
abstract class Expression<T extends Object> {
  /// Evaluates the expression with the provided [variables].
  T eval(Map<String, Object> variables);
}

/// A [Value] expression that does not change when evaluated.
/// e.g. it can be like a [num], [bool], [String] etc...
class Value<T extends Object> extends Expression<T> {
  Value(this.value);

  final T value;

  @override
  T eval(Map<String, Object> variables) => value;

  @override
  String toString() => 'Value{$value}';
}

/// An [Operator] that uses one [parameter]
/// e.g. making a number negative
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

class TagFunction<R extends Object> {
  TagFunction({
    required this.name,
    this.description,
    required this.function,
  });

  final String name;
  final String? description;
  final R Function(Map<String, Object> parameters) function;
}
