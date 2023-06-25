import 'dart:math';
import 'package:petitparser/petitparser.dart';

final numExpressionParser = () {
  final builder = ExpressionBuilder<Expression<num>>();
  builder
    ..primitive((digit().plus() &
            (char('.') & digit().plus()).optional() &
            (pattern('eE') & pattern('+-').optional() & digit().plus())
                .optional())
        .flatten('number expected')
        .trim()
        .map((value) => Value<num>(num.parse(value))))
    ..primitive(ChoiceParser(constants.keys.map((name) => string(name)))
        .flatten('constant expected')
        .trim()
        .map((name) => Value<num>(constants[name]!)))
    ..primitive((letter() & word().star())
        .flatten('variable expected')
        .trim()
        .map((name) => Variable<num>(name)));
  builder.group()
    ..wrapper(
        seq2(
          word().plusString('function expected').trim(),
          char('(').trim(),
        ),
        char(')').trim(),
        (left, value, right) =>
            TagFunction<num>(left.first, value, functions[left.first]!))
    ..wrapper(
        char('(').trim(), char(')').trim(), (left, value, right) => value);
  builder.group()
    ..prefix(char('+').trim(), (op, a) => a)
    ..prefix(
        char('-').trim(), (op, a) => UnaryOperator<num>('-', a, (x) => -x));
  builder
      .group()
      .right(char('^').trim(), (a, op, b) => BinaryOperator('^', a, b, pow));
  builder.group()
    ..left(char('*').trim(),
        (a, op, b) => BinaryOperator('*', a, b, (x, y) => x * y))
    ..left(char('/').trim(),
        (a, op, b) => BinaryOperator('/', a, b, (x, y) => x / y))
    ..left(char('%').trim(),
        (a, op, b) => BinaryOperator('%', a, b, (x, y) => x % y));
  builder.group()
    ..left(char('+').trim(),
        (a, op, b) => BinaryOperator('+', a, b, (x, y) => x + y))
    ..left(char('-').trim(),
        (a, op, b) => BinaryOperator('-', a, b, (x, y) => x - y));
  return builder.build().end();
}();

/// Common mathematical constants.
final constants = {
  'e': e,
  'pi': pi,
};

/// Common mathematical functions.
final functions = {
  'exp': exp,
  'log': log,
  'sin': sin,
  'asin': asin,
  'cos': cos,
  'acos': acos,
  'tan': tan,
  'atan': atan,
  'sqrt': sqrt,
};

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

/// a [Variable] is an abstract storage location paired with an associated
/// symbolic name, which contains some known or unknown quantity of information
/// referred to as a value; or in simpler terms, a [Variable] is a
/// named container for a particular set of bits or type of data
/// (like [num], [bool], [String] etc...)
class Variable<T extends Object> extends Expression<T> {
  Variable(this.name);

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
class TagFunction<T extends Object> extends Expression<T> {
  TagFunction(this.name, this.value, this.function);

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
