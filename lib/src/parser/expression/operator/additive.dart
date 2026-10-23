import 'package:template_engine/template_engine.dart';

final standardAdditiveOperators = <BinaryOperatorDefinition>[
  addOperator,
  subtractOperator,
];

final addOperator = BinaryOperatorDefinition(
  symbol: '+',
  precedence: .additive,
  associativity: .left,
  signatures: [
    BinaryOperatorSignature<num, num, num>(
      description: 'Adds two numbers',
      function: (left, right) => left + right,
      examples: [
        ExpressionBlockExample(
          (delimiter) => '${delimiter.start}2+3${delimiter.end}',
          shouldRender: '5',
        ),
        TestFileExample.fromProjectFilePath(
          'test/src/parser/expression/operator/additive/'
          'num_addition_test.dart',
        ),
      ],
    ),
    BinaryOperatorSignature<String, String, String>(
      description: 'Concatenates two strings',
      function: (left, right) => '$left$right',
      examples: [
        ExpressionBlockExample(
          (delimiter) => '${delimiter.start}"Hel"+"lo"${delimiter.end}',
          shouldRender: "Hello",
        ),
        TestFileExample.fromProjectFilePath(
          'test/src/parser/expression/operator/additive/'
          'string_concatenate_test.dart',
        ),
      ],
    ),
  ],
);

final subtractOperator = BinaryOperatorDefinition(
  symbol: '-',
  precedence: .additive,
  associativity: .left,
  signatures: [
    BinaryOperatorSignature<num, num, num>(
      description: 'Subtracts two numbers',
      function: (left, right) => left - right,
      examples: [
        ExpressionBlockExample(
          (delimiter) => '${delimiter.start}5-3${delimiter.end}',
          shouldRender: "2",
        ),
        TestFileExample.fromProjectFilePath(
          'test/src/parser/expression/operator/additive/'
          'num_subtract_test.dart',
        ),
      ],
    ),
  ],
);
