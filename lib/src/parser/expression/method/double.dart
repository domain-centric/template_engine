import 'package:template_engine/template_engine.dart';

final standardDoubleMethods = <MethodDefinition<double, dynamic>>[
  _roundMethod,
  _truncateMethod,
  _floorMethod,
  _ceilMethod,
];

final _roundMethod = MethodDefinition<double, int>(
  name: 'round',
  parameters: [],
  method: (context) => Future.value(context.owner.round()),

  description: "Returns the integer closest to this number.",
  examples: [
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}3.5.round()${delimiter.end}',
      shouldRender: "4",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/double/round_test.dart',
    ),
  ],
);

final _truncateMethod = MethodDefinition<double, int>(
  name: 'truncate',
  parameters: [],
  method: (context) => Future.value(context.owner.truncate()),

  description:
      "Returns the integer obtained by discarding "
      "any fractional part of this number.",
  examples: [
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}2.00001.truncate()${delimiter.end}',
      shouldRender: "2",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/double/truncate_test.dart',
    ),
  ],
);

final _floorMethod = MethodDefinition<double, int>(
  name: 'floor',
  parameters: [],
  method: (context) => Future.value(context.owner.floor()),

  description: "Returns the greatest integer no greater than this number.",
  examples: [
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}1.99999.floor()${delimiter.end}',
      shouldRender: "1",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/double/floor_test.dart',
    ),
  ],
);

final _ceilMethod = MethodDefinition<double, int>(
  name: 'ceil',
  parameters: [],
  method: (context) => Future.value(context.owner.ceil()),

  description:
      "Returns the least integer that is not smaller than this number.",
  examples: [
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}1.99999.ceil()${delimiter.end}',
      shouldRender: "2",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/double/ceil_test.dart',
    ),
  ],
);
