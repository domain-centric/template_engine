import 'dart:math';

import 'package:template_engine/template_engine.dart';

final standardExponentiationOperators = <BinaryOperatorDefinition>[
  exponentOperator,
];

final exponentOperator = BinaryOperatorDefinition(
  symbol: '**',
  precedence: .exponentiation,
  associativity: .right,
  signatures: [
    BinaryOperatorSignature<num, num, num>(
      description: 'Calculates a number to the power of the exponent number',
      function: (left, right) => pow(left, right),
      examples: [
        ExpressionBlockExample(
          (delimiter) => '${delimiter.start}2**3${delimiter.end}',
          shouldRender: '8',
        ),
        TestFileExample.fromProjectFilePath(
          'test/src/parser/expression/operator/exponentiation/'
          'num_power_test.dart',
        ),
      ],
    ),
  ],
);
