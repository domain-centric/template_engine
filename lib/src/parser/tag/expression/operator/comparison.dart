import 'package:template_engine/template_engine.dart';

class Comparisons extends OperatorGroup {
  Comparisons()
      : super('Comparisons', [
          EqualsOperator(),
          NotEqualsOperator(),
          GreaterThanOperator(),
        ]);
}

class EqualsOperator extends OperatorWith2Values {
  EqualsOperator()
      : super('==', OperatorAssociativity.left, [
          TwoValueOperatorVariant<Object, Object>(
              description: 'Checks if two values are equal',
              expressionExample: '{{5==2+3}}',
              expressionExampleResult: 'true',
              codeExample: ProjectFilePath(
                  'test/src/parser/tag/expression/operator/comparison/'
                  'equals_test.dart'),
              function: (left, right) => left == right)
        ]);
}

class NotEqualsOperator extends OperatorWith2Values {
  NotEqualsOperator()
      : super('!=', OperatorAssociativity.left, [
          TwoValueOperatorVariant<Object, Object>(
              description: 'Checks if two values are NOT equal',
              expressionExample: '{{4!=2+3}}',
              expressionExampleResult: 'true',
              codeExample: ProjectFilePath(
                  'test/src/parser/tag/expression/operator/comparison/'
                  'not_equals_test.dart'),
              function: (left, right) => left != right)
        ]);
}

class GreaterThanOperator extends OperatorWith2Values {
  GreaterThanOperator()
      : super('>', OperatorAssociativity.left, [
          TwoValueOperatorVariant<num, num>(
              description:
                  'Checks if the left value is greater than the right value',
              expressionExample: '{{2>1}}',
              expressionExampleResult: 'true',
              codeExample: ProjectFilePath(
                  'test/src/parser/tag/expression/operator/comparison/'
                  'greater_than_test.dart'),
              function: (left, right) => left > right)
        ]);
}
