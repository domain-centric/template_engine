import 'package:template_engine/template_engine.dart';

final standardXorOperators = <BinaryOperatorDefinition>[xorOperator];

final xorOperator = BinaryOperatorDefinition(
  symbol: '^',
  precedence: .xor,
  associativity: .left,
  signatures: [
    BinaryOperatorSignature<int, int, int>(
      description: 'Bitwise XOR with two integers',
      function: (left, right) => left ^ right,
      examples: [
        ExpressionBlockExample(
          (delimiter) => '${delimiter.start}12^10${delimiter.end}',
          shouldRender: '6',
        ),
        TestFileExample.fromProjectFilePath(
          'test/src/parser/expression/operator/xor/'
          'int_xor_test.dart',
        ),
      ],
    ),
    BinaryOperatorSignature<bool, bool, bool>(
      description: 'Logical XOR with two booleans',
      function: (left, right) => left ^ right,
      examples: [
        ExpressionBlockExample(
          (delimiter) => '${delimiter.start}true^false${delimiter.end}',
          shouldRender: 'true',
        ),
        TestFileExample.fromProjectFilePath(
          'test/src/parser/expression/operator/xor/'
          'bool_xor_test.dart',
        ),
      ],
    ),
  ],
);
