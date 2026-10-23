import 'package:template_engine/template_engine.dart';

final standardDynamicMethods = <MethodDefinition<dynamic, dynamic>>[
  toStringMethod,
  typeMethod,
];

final toStringMethod = MethodDefinition<dynamic, String>(
  name: 'toString',
  parameters: [],
  method: (context) => Future.value(context.owner.toString()),
  description: 'Returns the string representation of the object',
  examples: [
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}12.5.toString()${delimiter.end}',
      shouldRender: '12.5',
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/dynamic/to_string_test.dart',
    ),
  ],
);

final typeMethod = MethodDefinition<dynamic, String>(
  name: 'type',
  parameters: [],
  method: (context) => Future.value(
    context.owner.runtimeType.toString().replaceFirst(RegExp('^_'), ''),
  ),
  description: 'Returns the type of the object',
  examples: [
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}12.5.type()${delimiter.end}',
      shouldRender: 'double',
    ),
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}12.type()${delimiter.end}',
      shouldRender: 'int',
    ),
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}"Hello".type()${delimiter.end}',
      shouldRender: 'String',
    ),

    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/dynamic/type_test.dart',
    ),
  ],
);
