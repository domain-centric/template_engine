import 'package:template_engine/template_engine.dart';

final standardNumberMethods = <MethodDefinition<num, dynamic>>[
  _toIntMethod,
  _toDoubleMethod,
  _toStringAsFixedMethod,
  _toStringAsExponentialMethod,
];

final _toIntMethod = MethodDefinition<num, int>(
  name: 'toInt',
  parameters: [],
  method: (context) => Future.value(context.owner.toInt()),

  description: 'Returns this number truncated to an integer.',
  examples: [
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}4.5.toInt()${delimiter.end}',
      shouldRender: "4",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/num/to_int_test.dart',
    ),
  ],
);

final _toDoubleMethod = MethodDefinition<num, double>(
  name: 'toDouble',
  parameters: [],
  method: (context) {
    var number = context.owner;
    if (number is double) {
      return Future.value(number);
    } else {
      return Future.value(number.toDouble());
    }
  },

  description: 'Returns this number into a double.',
  examples: [
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}4.toDouble()${delimiter.end}',
      shouldRender: "4.0",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/num/to_double_test.dart',
    ),
  ],
);

final _toStringAsFixedMethod = MethodDefinition<num, String>(
  name: 'toStringAsFixed',
  parameters: [
    Parameter<int>(
      name: 'fractionDigits',
      description: 'The number of digits after the dot',
      presence: PresenceMandatory(),
    ),
  ],
  method: (context) {
    var fractionDigits = context.argumentValues['fractionDigits'];
    if (fractionDigits < 0) {
      fractionDigits = 0;
      context.addWarning(
        'Parameter fractionDigits must be >=0',
        context.argumentLocations['fractionDigits']!,
      );
    }
    var number = context.owner;
    return Future.value(number.toStringAsFixed(fractionDigits));
  },

  description: 'Returns this number to a String with a given number of digits.',
  examples: [
    ExpressionBlockExample(
      (delimiter) =>
          '${delimiter.start}(4321.12345678).toStringAsFixed(3)${delimiter.end}',
      shouldRender: "4321.123",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/num/to_string_as_fixed_test.dart',
    ),
  ],
);

final _toStringAsExponentialMethod = MethodDefinition<num, String>(
  name: 'toStringAsExponential',
  parameters: [
    Parameter<int>(
      name: 'fractionDigits',
      description: 'The number of digits after the dot',
      presence: PresenceOptional(),
    ),
  ],
  method: (context) {
    final fractionDigits = context.argumentValues['fractionDigits'] as int?;
    var number = context.owner;
    return Future.value(number.toStringAsExponential(fractionDigits));
  },

  description:
      'Returns this number in exponential notation with optional precision.',
  examples: [
    ExpressionBlockExample(
      (delimiter) =>
          '${delimiter.start}4321.12345678.toStringAsExponential(3)${delimiter.end}',
      shouldRender: '4.321e+3',
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/num/to_string_as_exponential_test.dart',
    ),
  ],
);
