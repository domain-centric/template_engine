import 'package:template_engine/template_engine.dart';

class Comparisons extends OperatorGroup {
  Comparisons()
    : super('Comparisons', [
        EqualsOperator(),
        NotEqualsOperator(),
        GreaterThanOrEqualOperator(),
        GreaterThanOperator(),
        LessThanOrEqualOperator(),
        LessThanOperator(),
      ]);
}

class EqualsOperator extends OperatorWith2Values {
  EqualsOperator()
    : super(
        name: 'Equals',
        symbol: '==',
        associativity: OperatorAssociativity.left,
        variants: [
          TwoValueOperatorVariant<Object, Object>(
            description: 'Checks if two values are equal',
            expressionExample: '{{5==2+3}}',
            expressionExampleResult: 'true',
            codeExample: ProjectFilePath(
              'test/src/parser/tag/expression/operator/comparison/'
              'equals_test.dart',
            ),
            function: (left, right) => left == right,
          ),
        ],
      );
}

class NotEqualsOperator extends OperatorWith2Values {
  NotEqualsOperator()
    : super(
        name: 'Not Equals',
        symbol: '!=',
        associativity: OperatorAssociativity.left,
        variants: [
          TwoValueOperatorVariant<Object, Object>(
            description: 'Checks if two values are NOT equal',
            expressionExample: '{{4!=2+3}}',
            expressionExampleResult: 'true',
            codeExample: ProjectFilePath(
              'test/src/parser/tag/expression/operator/comparison/'
              'not_equals_test.dart',
            ),
            function: (left, right) => left != right,
          ),
        ],
      );
}

class GreaterThanOperator extends OperatorWith2Values {
  GreaterThanOperator()
    : super(
        name: 'Greater Than',
        symbol: '>',
        associativity: OperatorAssociativity.left,
        variants: [
          TwoValueOperatorVariant<num, num>(
            description:
                'Checks if the left value is greater than the right value',
            expressionExample: '{{2>1}}',
            expressionExampleResult: 'true',
            codeExample: ProjectFilePath(
              'test/src/parser/tag/expression/operator/comparison/'
              'greater_than_test.dart',
            ),
            function: (left, right) => left > right,
          ),
        ],
      );
}

class GreaterThanOrEqualOperator extends OperatorWith2Values {
  GreaterThanOrEqualOperator()
    : super(
        name: 'Greater Than Or Equal',
        symbol: '>=',
        associativity: OperatorAssociativity.left,
        variants: [
          TwoValueOperatorVariant<num, num>(
            description:
                'Checks if the left value is greater than '
                'or equal to the right value',
            expressionExample: '{{2>=2}}',
            expressionExampleResult: 'true',
            codeExample: ProjectFilePath(
              'test/src/parser/tag/expression/operator/comparison/'
              'greater_than_or_equal_test.dart',
            ),
            function: (left, right) => left >= right,
          ),
        ],
      );
}

class LessThanOperator extends OperatorWith2Values {
  LessThanOperator()
    : super(
        name: 'Less Than',
        symbol: '<',
        associativity: OperatorAssociativity.left,
        variants: [
          TwoValueOperatorVariant<num, num>(
            description:
                'Checks if the left value is less than the right value',
            expressionExample: '{{2>1}}',
            expressionExampleResult: 'true',
            codeExample: ProjectFilePath(
              'test/src/parser/tag/expression/operator/comparison/'
              'less_than_test.dart',
            ),
            function: (left, right) => left < right,
          ),
        ],
      );
}

class LessThanOrEqualOperator extends OperatorWith2Values {
  LessThanOrEqualOperator()
    : super(
        name: 'Less Than Or Equal',
        symbol: '<=',
        associativity: OperatorAssociativity.left,
        variants: [
          TwoValueOperatorVariant<num, num>(
            description:
                'Checks if the left value is less than '
                'or equal to the right value',
            expressionExample: '{{2<=2}}',
            expressionExampleResult: 'true',
            codeExample: ProjectFilePath(
              'test/src/parser/tag/expression/operator/comparison/'
              'less_than_or_equal_test.dart',
            ),
            function: (left, right) => left <= right,
          ),
        ],
      );
}
