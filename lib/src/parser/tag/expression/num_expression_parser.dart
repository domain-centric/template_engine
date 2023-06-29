import 'dart:math';
import 'package:petitparser/petitparser.dart';
import 'package:template_engine/template_engine.dart';

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

  var group = builder.group();
  for (var definition in numFunctions()) {
    group.wrapper(
        seq2(
          string(definition.name, 'expected function name: ${definition.name}'),
          char('(').trim(),
        ),
        char(')').trim(),
        (left, parameterValue, right) =>
            TagFunction2<num>(definition, parameterValue));
  }
  group.wrapper(
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
