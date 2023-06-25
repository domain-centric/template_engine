import 'dart:math';
import 'package:petitparser/petitparser.dart';
import 'package:template_engine/template_engine.dart';

Parser<num> numberParser() => (digit().plus() &
        (char('.') & digit().plus()).optional() &
        (pattern('eE') & pattern('+-').optional() & digit().plus()).optional())
    .flatten('number expected')
    .trim()
    .map((value) => num.parse(value));

Parser<Expression<num>> numExpressionParser() {
  final builder = ExpressionBuilder<Expression<num>>();
  builder
    ..primitive(numberParser().map((number) => Value<num>(number)))
    ..primitive(ChoiceParser(constants.keys.map((name) => string(name)))
        .flatten('constant expected')
        .trim()
        .map((name) => Value<num>(constants[name]!)))
    ..primitive((letter() & word().star())
        .flatten('variable expected')
        .trim()
        .map((name) => Variable2<num>(name)));
  builder.group()
    ..wrapper(
        seq2(
          word().plusString('function expected').trim(),
          char('(').trim(),
        ),
        char(')').trim(),
        (left, value, right) =>
            TagFunction2<num>(left.first, value, functions[left.first]!))
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
  return builder.build();
}

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
