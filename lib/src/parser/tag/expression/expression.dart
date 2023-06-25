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

/// An [Operator] that uses one [value]
/// e.g. making a number negative
class TagFunction2<T extends Object> extends Expression<T> {
  TagFunction2(this.name, this.value, this.function);

  final String name;
  final Expression<T> value;
  final T Function(T value) function; //TODO replace value with parameters

  @override
  T eval(Map<String, Object> variables) => function(value.eval(variables));

  @override
  String toString() => 'Function{$name}';
}

/// An [Operator] behaves generally like functions,
/// but differs syntactically or semantically.
abstract class Operator<T extends Object> implements Expression<T> {
  // for documentation only
}

/// An [Operator] that uses one [value]
/// e.g. making a number negative
class UnaryOperator<T extends Object> extends Operator<T> {
  UnaryOperator(this.name, this.value, this.function);

  final String name;
  final Expression<T> value;
  final T Function(T value) function;

  @override
  T eval(Map<String, Object> variables) => function(value.eval(variables));

  @override
  String toString() => 'UnaryOperator{$name}';
}

/// An [Operator] that uses the two values [left] and [right]
/// An example of an opperation: a + b
class BinaryOperator<T extends Object> extends Operator<T> {
  BinaryOperator(this.name, this.left, this.right, this.function);

  final String name;
  final Expression<T> left;
  final Expression<T> right;
  final T Function(T left, T right) function;

  @override
  T eval(Map<String, Object> variables) =>
      function(left.eval(variables), right.eval(variables));

  @override
  String toString() => 'BinaryOperator{$name}';
}
