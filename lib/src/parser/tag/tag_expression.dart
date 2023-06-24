import 'dart:math';

import 'package:petitparser/petitparser.dart';

final mathParser = () {
  final builder = ExpressionBuilder<Expression>();
  builder
    ..primitive((digit().plus() &
            (char('.') & digit().plus()).optional() &
            (pattern('eE') & pattern('+-').optional() & digit().plus())
                .optional())
        .flatten('number expected')
        .trim()
        .map(_createValue))
    ..primitive((letter() & word().star())
        .flatten('variable expected')
        .trim()
        .map(_createVariable));
  builder.group()
    ..wrapper(
        seq2(
          word().plusString('function expected').trim(),
          char('(').trim(),
        ),
        char(')').trim(),
        (left, value, right) => _createFunction(left.first, value))
    ..wrapper(
        char('(').trim(), char(')').trim(), (left, value, right) => value);
  builder.group()
    ..prefix(char('+').trim(), (op, a) => a)
    ..prefix(char('-').trim(), (op, a) => Unary('-', a, (x) => -x));
  builder.group().right(char('^').trim(), (a, op, b) => Binary('^', a, b, pow));
  builder.group()
    ..left(char('*').trim(), (a, op, b) => Binary('*', a, b, (x, y) => x * y))
    ..left(char('/').trim(), (a, op, b) => Binary('/', a, b, (x, y) => x / y));
  builder.group()
    ..left(char('+').trim(), (a, op, b) => Binary('+', a, b, (x, y) => x + y))
    ..left(char('-').trim(), (a, op, b) => Binary('-', a, b, (x, y) => x - y));
  return builder.build().end();
}();

Expression _createValue(String value) => Value(num.parse(value));

Expression _createVariable(String name) =>
    constants.containsKey(name) ? Value(constants[name]!) : Variable(name);

Expression _createFunction(String name, Expression expression) =>
    Unary(name, expression, functions[name]!);

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
abstract class Expression {
  /// Evaluates the expression with the provided [variables].
  num eval(Map<String, num> variables);
}

/// A value expression.
class Value extends Expression {
  Value(this.value);

  final num value;

  @override
  num eval(Map<String, num> variables) => value;

  @override
  String toString() => 'Value{$value}';
}

/// A variable expression.
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

/// An unary expression.
class Unary extends Expression {
  Unary(this.name, this.value, this.function);

  final String name;
  final Expression value;
  final num Function(num value) function;

  @override
  num eval(Map<String, num> variables) => function(value.eval(variables));

  @override
  String toString() => 'Unary{$name}';
}

/// A binary expression.
class Binary extends Expression {
  Binary(this.name, this.left, this.right, this.function);

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
