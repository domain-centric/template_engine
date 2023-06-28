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

/// Common mathematical constants.
final constants = {
  'e': e,
  'pi': pi,
};

/// Returns a list of functions that return a number
List<TagFunctionDefinition<num>> numFunctions() => [
      ExpFunction(),
      LogFunction(),
      SinFunction(),
      AsinFunction(),
      CosFunction(),
      AcosFunction(),
      TanFunction(),
      AtanFunction(),
      SqrtFunction(),
      StringLengthFunction(),
    ];

class ExpFunction extends TagFunctionDefinition<num> {
  ExpFunction()
      : super(
            name: 'exp',
            function: (parameters) => exp(parameters['value'] as num));
}

class LogFunction extends TagFunctionDefinition<num> {
  LogFunction()
      : super(
            name: 'log',
            function: (parameters) => log(parameters['value'] as num));
}

class SinFunction extends TagFunctionDefinition<num> {
  SinFunction()
      : super(
            name: 'sin',
            function: (parameters) => sin(parameters['value'] as num));
}

class AsinFunction extends TagFunctionDefinition<num> {
  AsinFunction()
      : super(
            name: 'asin',
            function: (parameters) => asin(parameters['value'] as num));
}

class CosFunction extends TagFunctionDefinition<num> {
  CosFunction()
      : super(
            name: 'cos',
            function: (parameters) => cos(parameters['value'] as num));
}

class AcosFunction extends TagFunctionDefinition<num> {
  AcosFunction()
      : super(
            name: 'acos',
            function: (parameters) => acos(parameters['value'] as num));
}

class TanFunction extends TagFunctionDefinition<num> {
  TanFunction()
      : super(
            name: 'tan',
            function: (parameters) => tan(parameters['value'] as num));
}

class AtanFunction extends TagFunctionDefinition<num> {
  AtanFunction()
      : super(
            name: 'atan',
            function: (parameters) => atan(parameters['value'] as num));
}

class SqrtFunction extends TagFunctionDefinition<num> {
  SqrtFunction()
      : super(
            name: 'sqrt',
            function: (parameters) => sqrt(parameters['value'] as num));
}

class StringLengthFunction extends TagFunctionDefinition<num> {
  StringLengthFunction()
      : super(
            name: 'length',
            function: (parameters) {
              var value = parameters['value'];
              if (value is String) {
                return value.length;
              } else {
                throw ParameterException(
                    'String expected'); //TODO add TemplateSource
              }
            });
}

class ParameterException implements Exception {
  final String message;

  ParameterException(this.message);
}
