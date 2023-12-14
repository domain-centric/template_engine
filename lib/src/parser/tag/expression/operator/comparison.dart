import 'package:template_engine/template_engine.dart';

class Comparisons extends OperatorGroup {
  Comparisons()
      : super('Comparisons', [
          EqualsOperator(),
          NotEqualsOperator(),
          GreaterThanOrQualOperator(),
          GreaterThanOperator(),
          LessThanOrQualOperator(),
          LessThanOperator(),
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

class GreaterThanOrQualOperator extends OperatorWith2Values {
  GreaterThanOrQualOperator()
      : super('>=', OperatorAssociativity.left, [
          TwoValueOperatorVariant<num, num>(
              description: 'Checks if the left value is greater than '
                  'or equal to the right value',
              expressionExample: '{{2>=2}}',
              expressionExampleResult: 'true',
              codeExample: ProjectFilePath(
                  'test/src/parser/tag/expression/operator/comparison/'
                  'greater_than_or_equal_test.dart'),
              function: (left, right) => left >= right)
        ]);
}

class LessThanOperator extends OperatorWith2Values {
  LessThanOperator()
      : super('<', OperatorAssociativity.left, [
          TwoValueOperatorVariant<num, num>(
              description:
                  'Checks if the left value is less than the right value',
              expressionExample: '{{2>1}}',
              expressionExampleResult: 'true',
              codeExample: ProjectFilePath(
                  'test/src/parser/tag/expression/operator/comparison/'
                  'less_than_test.dart'),
              function: (left, right) => left < right)
        ]);
}

class LessThanOrQualOperator extends OperatorWith2Values {
  LessThanOrQualOperator()
      : super('<=', OperatorAssociativity.left, [
          TwoValueOperatorVariant<num, num>(
              description: 'Checks if the left value is less than '
                  'or equal to the right value',
              expressionExample: '{{2<=2}}',
              expressionExampleResult: 'true',
              codeExample: ProjectFilePath(
                  'test/src/parser/tag/expression/operator/comparison/'
                  'less_than_or_equal_test.dart'),
              function: (left, right) => left <= right)
        ]);
}
