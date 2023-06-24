import 'dart:math';

import 'package:petitparser/petitparser.dart';

final expressionParser = () {
  final builder = ExpressionBuilder<Expression>();
  builder
    ..primitive((digit().plus() &
            (char('.') & digit().plus()).optional() &
            (pattern('eE') & pattern('+-').optional() & digit().plus())
                .optional())
        .flatten('number expected')
        .trim()
        .map((value) => Value(num.parse(value))))
    ..primitive(
        ChoiceParser(constants.keys.map((name) => string(name)))
            .flatten('constant expected')
            .trim()
            .map((name) => Value(constants[name]!)))
    ..primitive((letter() & word().star())
        .flatten('variable expected')
        .trim()
        .map((name) => Variable(name)));
  builder.group()
    ..wrapper(
        seq2(
          word().plusString('function expected').trim(),
          char('(').trim(),
        ),
        char(')').trim(),
        (left, value, right) =>
            TagFunction(left.first, value, functions[left.first]!))
    ..wrapper(
        char('(').trim(), char(')').trim(), (left, value, right) => value);
  builder.group()
    ..prefix(char('+').trim(), (op, a) => a)
    ..prefix(char('-').trim(), (op, a) => UnaryOperator('-', a, (x) => -x));
  builder
      .group()
      .right(char('^').trim(), (a, op, b) => BinaryOperator('^', a, b, pow));
  builder.group()
    ..left(char('*').trim(),
        (a, op, b) => BinaryOperator('*', a, b, (x, y) => x * y))
    ..left(char('/').trim(),
        (a, op, b) => BinaryOperator('/', a, b, (x, y) => x / y));
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
abstract class Expression {
  /// Evaluates the expression with the provided [variables].
  num eval(Map<String, num> variables);
}

/// A [Value] expression that does not change when evaluated.
/// e.g. it can be like a [num], [bool], [String] etc...
class Value extends Expression {
  Value(this.value);

  final num value;

  @override
  num eval(Map<String, num> variables) => value;

  @override
  String toString() => 'Value{$value}';
}

/// a [Variable] is an abstract storage location paired with an associated
/// symbolic name, which contains some known or unknown quantity of information
/// referred to as a value; or in simpler terms, a [Variable] is a
/// named container for a particular set of bits or type of data
/// (like [num], [bool], [String] etc...)
class Variable extends Expression {
  Variable(this.name);

  final String name;

  @override
  num eval(Map<String, num> variables) => variables.containsKey(name)
      ? variables[name]!
      : throw 'Unknown variable $name';

  @override
  String toString() => 'Variable{$name}';
}

/// An [Operator] that uses one [value]
/// e.g. making a number negative
class TagFunction extends Operator {
  TagFunction(this.name, this.value, this.function);

  final String name;
  final Expression value;
  final num Function(num value) function;

  @override
  num eval(Map<String, num> variables) => function(value.eval(variables));

  @override
  String toString() => 'Function{$name}';
}

/// An [Operator] behaves generally like functions,
/// but differs syntactically or semantically.
abstract class Operator implements Expression {
  // for documentation only
}

/// An [Operator] that uses one [value]
/// e.g. making a number negative
class UnaryOperator extends Operator {
  UnaryOperator(this.name, this.value, this.function);

  final String name;
  final Expression value;
  final num Function(num value) function;

  @override
  num eval(Map<String, num> variables) => function(value.eval(variables));

  @override
  String toString() => 'Unary{$name}';
}

/// An [Operator] that uses the two values [left] and [right]
/// An example of an opperation: a + b
class BinaryOperator extends Operator {
  BinaryOperator(this.name, this.left, this.right, this.function);

  final String name;
  final Expression left;
  final Expression right;
  final num Function(num left, num right) function;

  @override
  num eval(Map<String, num> variables) =>
      function(left.eval(variables), right.eval(variables));

  @override
  String toString() => 'Binary{$name}';
}
