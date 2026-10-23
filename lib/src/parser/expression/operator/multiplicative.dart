import 'package:template_engine/template_engine.dart';

final standardMultiplicativeOperators = <BinaryOperatorDefinition>[
  multiplyOperator,
  divideOperator,
  moduloOperator,
];

final multiplyOperator = BinaryOperatorDefinition(
  symbol: '*',
  precedence: .multiplicative,
  associativity: .left,
  signatures: [
    BinaryOperatorSignature<num, num, num>(
      description: 'Multiplies 2 numbers',
      function: (left, right) => left * right,
      examples: [
        ExpressionBlockExample(
          (delimiter) => '${delimiter.start}2*3${delimiter.end}',
          shouldRender: '6',
        ),
        TestFileExample.fromProjectFilePath(
          'test/src/parser/expression/operator/multiplication/'
          'num_multiply_test.dart',
        ),
      ],
    ),
  ],
);

final divideOperator = BinaryOperatorDefinition(
  symbol: '/',
  precedence: .multiplicative,
  associativity: .left,
  signatures: [
    BinaryOperatorSignature<num, num, num>(
      description: 'Divides 2 numbers',
      function: (left, right) => left / right,
      examples: [
        ExpressionBlockExample(
          (delimiter) => '${delimiter.start}6/4${delimiter.end}',
          shouldRender: '1.5',
        ),
        TestFileExample.fromProjectFilePath(
          'test/src/parser/expression/operator/multiplication/'
          'num_divide_test.dart',
        ),
      ],
    ),
  ],
);

final moduloOperator = BinaryOperatorDefinition(
  symbol: '%',
  precedence: .multiplicative,
  associativity: .left,
  signatures: [
    BinaryOperatorSignature<num, num, num>(
      description: 'Calculates the modulo (rest value of a division)',
      function: (left, right) => left % right,
      examples: [
        ExpressionBlockExample(
          (delimiter) => '${delimiter.start}7%3${delimiter.end}',
          shouldRender: '1',
        ),
        TestFileExample.fromProjectFilePath(
          'test/src/parser/expression/operator/multiplication/'
          'num_modulo_test.dart',
        ),
      ],
    ),
  ],
);
