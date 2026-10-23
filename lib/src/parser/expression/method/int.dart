import 'package:template_engine/template_engine.dart';

final standardIntMethods = <MethodDefinition<int, dynamic>>[
  _toRadixStringMethod,
];

final _toRadixStringMethod = MethodDefinition<int, String>(
  name: 'toRadixString',
  parameters: [
    Parameter<int>(
      name: 'radix',
      description:
          'the base or the number of unique digits (including zero) used '
          'to represent numbers in a positional numeral system, '
          'e.g.: 2= binary, 8= octal, 10= decimal, 16=hexadecimal. '
          'radix must be an integer in the range 2 to 36',
      presence: PresenceMandatory(),
    ),
  ],
  method: (context) {
    var radix = context.argumentValues['radix'];
    if (radix < 2) {
      radix = 2;
      context.addWarning(
        'Parameter radix must be >=2',
        context.argumentLocations['radix']!,
      );
    }
    if (radix > 36) {
      radix = 36;
      context.addWarning(
        'Parameter radix must be <=36',
        context.argumentLocations['radix']!,
      );
    }
    return Future.value(context.owner.toRadixString(radix));
  },

  description:
      "Converts this [int] to a string representation in the given [radix]. "
      "In the string representation, lower-case letters are used for digits above "
      "'9', with 'a' being 10 and 'z' being 35.",
  examples: [
    ExpressionBlockExample(
      (delimiter) => '${delimiter.start}12.toRadixString(2)${delimiter.end}',
      shouldRender: "1100",
    ),
    TestFileExample.fromProjectFilePath(
      'test/src/parser/expression/method/int/to_radix_string_test.dart',
    ),
  ],
);
