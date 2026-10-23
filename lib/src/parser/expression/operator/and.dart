import 'package:template_engine/template_engine.dart';

final standardAndOperators = <BinaryOperatorDefinition>[andOperator];

final andOperator = BinaryOperatorDefinition(
  symbol: '&',
  precedence: .and,
  associativity: .left,
  signatures: [
    BinaryOperatorSignature<int, int, int>(
      description: 'Bitwise AND operation on two integers',
      function: (left, right) => left & right,
      examples: [
        ExpressionBlockExample(
          (delimiter) => '${delimiter.start}5&4${delimiter.end}',
          shouldRender: '4',
        ),
        TestFileExample.fromProjectFilePath(
          'test/src/parser/expression/operator/and/'
          'int_and_test.dart',
        ),
      ],
    ),
    BinaryOperatorSignature<bool, bool, bool>(
      description: 'Logical AND operation on two booleans',
      function: (left, right) => left & right,
      examples: [
        ExpressionBlockExample(
          (delimiter) => '${delimiter.start}true&true${delimiter.end}',
          shouldRender: 'true',
        ),
        TestFileExample.fromProjectFilePath(
          'test/src/parser/expression/operator/and/'
          'bool_and_test.dart',
        ),
      ],
    ),
    BinaryOperatorSignature<String, String, String>(
      description: 'Concatenate two strings',
      function: (left, right) => '$left$right',
      examples: [
        ExpressionBlockExample(
          (delimiter) => '${delimiter.start}"Hel"&"lo"${delimiter.end}',
          shouldRender: "Hello",
        ),
        TestFileExample.fromProjectFilePath(
          'test/src/parser/expression/operator/and/'
          'string_concatenate_test.dart',
        ),
      ],
    ),
  ],
);
