import 'package:template_engine/template_engine.dart';

final standardRelationalOperators = <BinaryOperatorDefinition>[
  greaterThanOperator,
  greaterThanOrEqualsOperator,
  lessThanOperator,
  lessThanOrEqualsOperator,
];

final greaterThanOperator = BinaryOperatorDefinition(
  symbol: '>',
  precedence: .relational,
  associativity: .left,
  signatures: [
    BinaryOperatorSignature<num, num, bool>(
      description: 'Checks if the left value is greater than the right value',

      function: (left, right) => left > right,
      examples: [
        ExpressionBlockExample(
          (delimiter) => '${delimiter.start}2>1${delimiter.end}',
          shouldRender: 'true',
        ),
        TestFileExample.fromProjectFilePath(
          'test/src/parser/expression/operator/comparison/'
          'greater_than_test.dart',
        ),
      ],
    ),
  ],
);

final greaterThanOrEqualsOperator = BinaryOperatorDefinition(
  symbol: '>=',
  precedence: .relational,
  associativity: .left,
  signatures: [
    BinaryOperatorSignature<num, num, bool>(
      description:
          'Checks if the left value is greater than '
          'or equal to the right value',
      function: (left, right) => left >= right,
      examples: [
        ExpressionBlockExample(
          (delimiter) => '${delimiter.start}2>=2${delimiter.end}',
          shouldRender: 'true',
        ),
        TestFileExample.fromProjectFilePath(
          'test/src/parser/expression/operator/comparison/'
          'greater_than_or_equal_test.dart',
        ),
      ],
    ),
  ],
);

final lessThanOperator = BinaryOperatorDefinition(
  symbol: '<',
  precedence: .relational,
  associativity: .left,
  signatures: [
    BinaryOperatorSignature<num, num, bool>(
      description: 'Checks if the left value is less than the right value',
      function: (left, right) => left < right,
      examples: [
        ExpressionBlockExample(
          (delimiter) => '${delimiter.start}1<2${delimiter.end}',
          shouldRender: 'true',
        ),
        TestFileExample.fromProjectFilePath(
          'test/src/parser/expression/operator/comparison/'
          'less_than_test.dart',
        ),
      ],
    ),
  ],
);

final lessThanOrEqualsOperator = BinaryOperatorDefinition(
  symbol: '<=',
  precedence: .relational,
  associativity: .left,
  signatures: [
    BinaryOperatorSignature<num, num, bool>(
      description:
          'Checks if the left value is less than '
          'or equal to the right value',
      function: (left, right) => left <= right,
      examples: [
        ExpressionBlockExample(
          (delimiter) => '${delimiter.start}2<=2${delimiter.end}',
          shouldRender: 'true',
        ),
        TestFileExample.fromProjectFilePath(
          'test/src/parser/expression/operator/comparison/'
          'less_than_or_equal_test.dart',
        ),
      ],
    ),
  ],
);
