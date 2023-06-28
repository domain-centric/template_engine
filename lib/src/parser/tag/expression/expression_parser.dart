import 'package:petitparser/petitparser.dart';
import 'package:template_engine/template_engine.dart';

Parser<Expression> expressionParser() {
  final builder = ExpressionBuilder<Expression>();
  builder
    ..primitive(numberParser().map((number) => Value<num>(number)))
    ..primitive(quotedStringParser().map((string) => Value<String>(string)))
    ..primitive(boolParser().map((boolean) => Value<bool>(boolean)))
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

  ParenthesesOperator().addParser(group);
  // group.wrapper(
  //     char('(').trim(), char(')').trim(), (left, value, right) => value);
  group = builder.group();
  PositiveOperator().addParser(group);
  group.prefix(char('-').trim(),
      (op, a) => UnaryOperator<num>('-', a as Expression<num>, (x) => -x));

  group = builder.group();
  PowerOperator().addParser(group);
  // builder.group().right(
  //     char('^').trim(),
  //     (a, op, b) => BinaryOperator<num>('^', a as Expression<num>,
  //         b as Expression<num>, (x, y) => pow(x, y)));
  builder.group()
    ..left(
        char('*').trim(),
        (a, op, b) => BinaryOperator<num>(
            '*', a as Expression<num>, b as Expression<num>, (x, y) => x * y))
    ..left(
        char('/').trim(),
        (a, op, b) => BinaryOperator<num>(
            '/', a as Expression<num>, b as Expression<num>, (x, y) => x / y))
    ..left(
        char('%').trim(),
        (a, op, b) => BinaryOperator<num>(
            '%', a as Expression<num>, b as Expression<num>, (x, y) => x % y));
  builder.group()
    ..left(
        char('+').trim(),
        (a, op, b) => BinaryOperator<num>(
            '+', a as Expression<num>, b as Expression<num>, (x, y) => x + y))
    ..left(
        char('-').trim(),
        (a, op, b) => BinaryOperator<num>(
            '-', a as Expression<num>, b as Expression<num>, (x, y) => x - y));
  return builder.build();
}
