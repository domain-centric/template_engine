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

/// a [Variable2] is an abstract storage location paired with an associated
/// symbolic name, which contains some known or unknown quantity of information
/// referred to as a value; or in simpler terms, a [Variable2] is a
/// named container for a particular set of bits or type of data
/// (like [num], [bool], [String] etc...)

class Variable2<T extends Object> extends Expression<T> {
  Variable2(this.name);

  final String name;

  @override
  T eval(Map<String, Object> variables) => variables.containsKey(name)
      ? variables[name]! as T
      : throw 'Unknown variable $name';

  @override
  String toString() => 'Variable{$name}';
}

/// An [Operator] that uses one [parameter]
/// e.g. making a number negative
class TagFunction2<R extends Object> extends Expression<R> {
  final TagFunctionDefinition<R> definition;
  final Expression parameter;

  TagFunction2(
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

class TagFunctionDefinition<R extends Object> {
  TagFunctionDefinition({
    required this.name,
    required this.function,
  });

  final String name;
  final R Function(Map<String, Object> parameters) function;
}
