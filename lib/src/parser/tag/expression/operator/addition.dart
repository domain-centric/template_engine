import 'package:petitparser/parser.dart';
import 'package:template_engine/template_engine.dart';

class Additions extends OperatorGroup {
  Additions()
      : super('Additions', [AddOperator(), SubtractOperator(), OrOperator()]);
}

class AddOperator extends OperatorWith2Values {
  AddOperator()
      : super('+', [
          TwoValueOperatorVariant<num>(
              description: 'Adds two numbers',
              expressionExample: '{{2+3}}',
              expressionExampleResult: '5',
              codeExample: ProjectFilePath(
                  '/test/src/parser/tag/expression/operator/addition/'
                  'num_addition_test.dart'),
              function: (left, right) => left + right),
          TwoValueOperatorVariant<String>(
              description: 'Concatenates two strings',
              expressionExample: '{{"Hel"+"lo"}}',
              expressionExampleResult: "Hello",
              codeExample: ProjectFilePath(
                  '/test/src/parser/tag/expression/operator/addition/'
                  'string_concatenate_test.dart'),
              function: (left, right) => '$left$right')
        ]);

  @override
  void addParser(Template template, ExpressionGroup2<Expression> group) {
    group.left(
        char(operator).trim(),
        (context, left, op, right) => createExpression(
            Source.fromContext(template, context), left, right));
  }
}

class SubtractOperator extends OperatorWith2Values {
  SubtractOperator()
      : super(
          '-',
          [
            TwoValueOperatorVariant<num>(
                description: 'Subtracts two numbers',
                expressionExample: '{{5-3}}',
                expressionExampleResult: '2',
                codeExample: ProjectFilePath(
                    '/test/src/parser/tag/expression/operator/addition/'
                    'num_subtract_test.dart'),
                function: (left, right) => left - right)
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

class OrOperator extends OperatorWith2Values {
  OrOperator()
      : super(
          '|',
          [
            TwoValueOperatorVariant<bool>(
                description: 'Logical OR operation on two booleans',
                expressionExample: '{{false|true}}',
                expressionExampleResult: 'true',
                codeExample: ProjectFilePath(
                    '/test/src/parser/tag/expression/operator/addition/'
                    'bool_or_test.dart'),
                function: (left, right) => left | right)
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
