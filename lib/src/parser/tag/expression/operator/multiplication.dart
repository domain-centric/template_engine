import 'dart:math';

import 'package:petitparser/parser.dart';
import 'package:template_engine/template_engine.dart';

class Multiplication extends OperatorGroup {
  Multiplication()
      : super('Multiplication', [
          CaretOperator(),
          MultiplyOperator(),
          DivideOperator(),
          ModuloOperator(),
          AndOperator()
        ]);
}

class CaretOperator extends OperatorWith2Values {
  CaretOperator()
      : super('^', [
          TwoValueOperatorVariant<num>(
              'Calculates a number to the power '
              'of the exponent number, e.g.: 2^3=8',
              pow),
          TwoValueOperatorVariant<bool>(
              'Logical XOR with two booleans, e.g.: true^false=true',
              (left, right) => left ^ right)
        ]);

  @override
  void addParser(Template template, ExpressionGroup2<Expression> group) {
    group.right(
        char(operator).trim(),
        (context, left, op, right) => createExpression(
            Source.fromContext(template, context), left, right));
  }
}

class MultiplyOperator extends OperatorWith2Values {
  MultiplyOperator()
      : super('*', [
          TwoValueOperatorVariant<num>('Multiplies 2 numbers, e.g.: 2*3=6',
              (left, right) => left * right)
        ]);

  @override
  void addParser(Template template, ExpressionGroup2<Expression> group) {
    group.left(
        char(operator).trim(),
        (context, left, op, right) => createExpression(
            Source.fromContext(template, context), left, right));
  }
}

class DivideOperator extends OperatorWith2Values {
  DivideOperator()
      : super(
          '/',
          [
            TwoValueOperatorVariant<num>('Divides 2 numbers, e.g.: 6*4=1.5',
                (left, right) => left / right)
          ],
        );

  @override
  void addParser(Template template, ExpressionGroup2<Expression> group) {
    group.left(
        char(operator).trim(),
        (context, left, op, right) => createExpression(
            Source.fromContext(template, context), left, right));
  }
}

class ModuloOperator extends OperatorWith2Values {
  ModuloOperator()
      : super(
          '%',
          [
            TwoValueOperatorVariant<num>(
                'Calculates the modulo (rest value of a division), e.g.: 8%3=2',
                (left, right) => left % right)
          ],
        );

  @override
  void addParser(Template template, ExpressionGroup2<Expression> group) {
    group.left(
        char(operator).trim(),
        (context, left, op, right) => createExpression(
            Source.fromContext(template, context), left, right));
  }
}

class AndOperator extends OperatorWith2Values {
  AndOperator()
      : super(
          '&',
          [
            TwoValueOperatorVariant<bool>(
                'Logical AND operation on two booleans, e.g.: true&true=true',
                (left, right) => left & right),
            TwoValueOperatorVariant<String>(
                'Concatenates two strings, e.g.: "Hel"&"lo"="Hello"',
                (left, right) => '$left$right')
          ],
        );

  @override
  void addParser(Template template, ExpressionGroup2<Expression> group) {
    group.left(
        char(operator).trim(),
        (context, left, op, right) => createExpression(
            Source.fromContext(template, context), left, right));
  }
}
