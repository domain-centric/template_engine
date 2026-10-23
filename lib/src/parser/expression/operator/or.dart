import 'package:template_engine/template_engine.dart';

final standardOrOperators = <BinaryOperatorDefinition>[orOperator];

final orOperator = BinaryOperatorDefinition(
  symbol: '|',
  precedence: .or,
  associativity: .left,
  signatures: [
    BinaryOperatorSignature<int, int, int>(
      description: 'Bitwise OR operation on two integers',
      function: (left, right) => left | right,
      examples: [
        ExpressionBlockExample(
          (delimiter) => '${delimiter.start}5|2${delimiter.end}',
          shouldRender: "7",
        ),
        TestFileExample.fromProjectFilePath(
          'test/src/parser/expression/operator/or/'
          'int_or_test.dart',
        ),
      ],
    ),
    BinaryOperatorSignature<bool, bool, bool>(
      description: 'Logical OR operation on two booleans',
      function: (left, right) => left | right,
      examples: [
        ExpressionBlockExample(
          (delimiter) => '${delimiter.start}false|true${delimiter.end}',
          shouldRender: "true",
        ),
        TestFileExample.fromProjectFilePath(
          'test/src/parser/expression/operator/or/'
          'bool_or_test.dart',
        ),
      ],
    ),
  ],
);
