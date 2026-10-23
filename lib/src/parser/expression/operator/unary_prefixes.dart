import 'package:template_engine/template_engine.dart';

final standardUnaryOperators = <UnaryOperatorDefinition>[
  plusPreFixOperator,
  minusPreFixOperator,
  notPreFixOperator,
];

final plusPreFixOperator = UnaryOperatorDefinition(
  symbol: '+',
  signatures: [
    UnaryOperatorSignature<num, num>(
      description: 'Optional prefix for positive numbers',
      examples: [
        ExpressionBlockExample(
          (delimiter) => '${delimiter.start}+3${delimiter.end}',
          shouldRender: '3',
        ),
        TestFileExample.fromProjectFilePath(
          'test/src/parser/expression/operator/prefix/positive_test.dart',
        ),
      ],
      function: (number) => number.abs(),
    ),
  ],
);

final minusPreFixOperator = UnaryOperatorDefinition(
  symbol: '-',
  signatures: [
    UnaryOperatorSignature<num, num>(
      description: 'Prefix for a negative number',
      examples: [
        ExpressionBlockExample(
          (delimiter) => '${delimiter.start}-3${delimiter.end}',
          shouldRender: '-3',
        ),
        TestFileExample.fromProjectFilePath(
          'test/src/parser/expression/operator/prefix/negative_test.dart',
        ),
      ],
      function: (number) => -number.abs(),
    ),
  ],
);

final notPreFixOperator = UnaryOperatorDefinition(
  symbol: '!',
  signatures: [
    UnaryOperatorSignature<bool, bool>(
      description: 'Prefix to invert a boolean, e.g.: !true => false',
      function: (boolean) => !boolean,
      examples: [
        ExpressionBlockExample(
          (delimiter) => '${delimiter.start}!true${delimiter.end}',
          shouldRender: 'false',
        ),
        TestFileExample.fromProjectFilePath(
          'test/src/parser/expression/operator/prefix/not_test.dart',
        ),
      ],
    ),
  ],
);
