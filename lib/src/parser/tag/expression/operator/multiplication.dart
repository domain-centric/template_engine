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
              description:
                  'Calculates a number to the power of the exponent number',
              expressionExample: '{{2^3}}',
              expressionExampleResult: '8',
              codeExample: ProjectFilePath(
                  '/test/src/parser/tag/expression/operator/multiplication/'
                  'num_power_test.dart'),
              function: pow),
          TwoValueOperatorVariant<bool>(
              description: 'Logical XOR with two booleans',
              expressionExample: '{{true^false}}',
              expressionExampleResult: 'true',
              codeExample: ProjectFilePath(
                  '/test/src/parser/tag/expression/operator/multiplication/'
                  'bool_xor_test.dart'),
              function: (left, right) => left ^ right)
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
          TwoValueOperatorVariant<num>(
              description: 'Multiplies 2 numbers',
              expressionExample: '{{2*3}}',
              expressionExampleResult: '6',
              codeExample: ProjectFilePath(
                  '/test/src/parser/tag/expression/operator/multiplication/'
                  'num_multiply_test.dart'),
              function: (left, right) => left * right)
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
            TwoValueOperatorVariant<num>(
                description: 'Divides 2 numbers',
                expressionExample: '{{6/4}}',
                expressionExampleResult: '1.5',
                codeExample: ProjectFilePath(
                    '/test/src/parser/tag/expression/operator/multiplication/'
                    'num_divide_test.dart'),
                function: (left, right) => left / right)
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
                description: 'Calculates the modulo (rest value of a division)',
                expressionExample: '{{8%3}}',
                expressionExampleResult: '2',
                codeExample: ProjectFilePath(
                    '/test/src/parser/tag/expression/operator/multiplication/'
                    'num_modulo_test.dart'),
                function: (left, right) => left % right)
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
                description: 'Logical AND operation on two booleans',
                expressionExample: '{{true&true}}',
                expressionExampleResult: 'true',
                codeExample: ProjectFilePath(
                    '/test/src/parser/tag/expression/operator/multiplication/'
                    'bool_and_test.dart'),
                function: (left, right) => left & right),
            TwoValueOperatorVariant<String>(
                description: 'Concatenates two strings',
                expressionExample: '{{"Hel"&"lo"}}',
                expressionExampleResult: "Hello",
                codeExample: ProjectFilePath(
                    '/test/src/parser/tag/expression/operator/multiplication/'
                    'string_concatenate_test.dart'),
                function: (left, right) => '$left$right')
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
