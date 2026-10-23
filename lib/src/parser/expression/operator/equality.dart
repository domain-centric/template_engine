import 'package:template_engine/template_engine.dart';

final standardEqualityOperators = <BinaryOperatorDefinition>{
  equalsOperator,
  notEqualsOperator,
};

final equalsOperator = BinaryOperatorDefinition(
  symbol: '==',
  precedence: .equality,
  associativity: .left,
  signatures: [
    BinaryOperatorSignature<Object, Object, Object>(
      description: 'Checks if two values are equal',
      function: (left, right) => left == right,
      examples: [
        ExpressionBlockExample(
          (delimiter) => '${delimiter.start}5==2+3${delimiter.end}',
          shouldRender: 'true',
        ),
        TestFileExample.fromProjectFilePath(
          'test/src/parser/expression/operator/comparison/'
          'equals_test.dart',
        ),
      ],
    ),
  ],
);

final notEqualsOperator = BinaryOperatorDefinition(
  symbol: '!=',
  precedence: .equality,
  associativity: .left,
  signatures: [
    BinaryOperatorSignature<Object, Object, bool>(
      description: 'Checks if two values are NOT equal',
      function: (left, right) => left != right,
      examples: [
        ExpressionBlockExample(
          (delimiter) => '${delimiter.start}4!=2+3${delimiter.end}',
          shouldRender: 'true',
        ),
        TestFileExample.fromProjectFilePath(
          'test/src/parser/expression/operator/comparison/'
          'not_equals_test.dart',
        ),
      ],
    ),
  ],
);
