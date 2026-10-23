import 'dart:math';

import 'package:template_engine/template_engine.dart';

final standardMathFunctions = FunctionGroup('Math Functions', [
  expFunction,
  logFunction,
  sinFunction,
  aSinFunction,
  cosFunction,
  aCosFunction,
  tanFunction,
  aTanFunction,
  sqrtFunction,
  roundFunction,
]);

final expFunction = FunctionDefinition<num>(
  name: 'exp',

  parameters: [Parameter<num>(name: 'value', presence: PresenceMandatory())],
  function: (context) {
    var value = context.argumentValues['value'] as num;
    return Future.value(exp(value));
  },
  documentation: FunctionDefinitionDocumentation(
    description:
        'Returns the natural exponent e, '
        'to the power of the value',
    examples: [
      ExpressionBlockExample(
        (delimiter) => '${delimiter.start}exp(7)${delimiter.end}',
        shouldRender: exp(7).toString(),
      ),

      TestFileExample.fromProjectFilePath(
        'test/src/parser/expression/function/math/exp_test.dart',
      ),
    ],
  ),
);

final logFunction = FunctionDefinition<num>(
  name: 'log',
  parameters: [Parameter<num>(name: 'value', presence: PresenceMandatory())],
  function: (context) {
    var value = context.argumentValues['value'] as num;
    return Future.value(log(value));
  },
  documentation: FunctionDefinitionDocumentation(
    description: 'Returns the natural logarithm of the value',
    examples: [
      ExpressionBlockExample(
        (delimiter) => '${delimiter.start}log(7)${delimiter.end}',
        shouldRender: log(7).toString(),
      ),
      TestFileExample.fromProjectFilePath(
        'test/src/parser/expression/function/math/log_test.dart',
      ),
    ],
  ),
);

final sinFunction = FunctionDefinition<num>(
  name: 'sin',
  parameters: [Parameter<num>(name: 'radians', presence: PresenceMandatory())],
  function: (context) {
    var radians = context.argumentValues['radians'] as num;
    return Future.value(sin(radians));
  },
  documentation: FunctionDefinitionDocumentation(
    description: 'Returns the sine of the radians',
    examples: [
      ExpressionBlockExample(
        (delimiter) => '${delimiter.start}sin(7)${delimiter.end}',
        shouldRender: sin(7).toString(),
      ),
      TestFileExample.fromProjectFilePath(
        'test/src/parser/expression/function/math/sin_test.dart',
      ),
    ],
  ),
);

final aSinFunction = FunctionDefinition<num>(
  name: 'asin',
  parameters: [Parameter<num>(name: 'value', presence: PresenceMandatory())],
  function: (context) {
    var value = context.argumentValues['value'] as num;
    return Future.value(asin(value));
  },
  documentation: FunctionDefinitionDocumentation(
    description: 'Returns the values arc sine in radians',
    examples: [
      ExpressionBlockExample(
        (delimiter) => '${delimiter.start}asin(0.5)${delimiter.end}',
        shouldRender: asin(0.5).toString(),
      ),
      TestFileExample.fromProjectFilePath(
        'test/src/parser/expression/function/math/asin_test.dart',
      ),
    ],
  ),
);

final cosFunction = FunctionDefinition<num>(
  name: 'cos',
  parameters: [Parameter<num>(name: 'radians', presence: PresenceMandatory())],
  function: (context) {
    var radians = context.argumentValues['radians'] as num;
    return Future.value(cos(radians));
  },
  documentation: FunctionDefinitionDocumentation(
    description: 'Returns the cosine of the radians',
    examples: [
      ExpressionBlockExample(
        (delimiter) => '${delimiter.start}cos(7)${delimiter.end}',
        shouldRender: cos(7).toString(),
      ),
      TestFileExample.fromProjectFilePath(
        'test/src/parser/expression/function/math/cos_test.dart',
      ),
    ],
  ),
);

final aCosFunction = FunctionDefinition<num>(
  name: 'acos',
  parameters: [Parameter<num>(name: 'value', presence: PresenceMandatory())],
  function: (context) {
    var value = context.argumentValues['value'] as num;
    return Future.value(acos(value));
  },
  documentation: FunctionDefinitionDocumentation(
    description: 'Returns the values arc cosine in radians',
    examples: [
      ExpressionBlockExample(
        (delimiter) => '${delimiter.start}acos(0.5)${delimiter.end}',
        shouldRender: acos(0.5).toString(),
      ),
      TestFileExample.fromProjectFilePath(
        'test/src/parser/expression/function/math/acos_test.dart',
      ),
    ],
  ),
);

final tanFunction = FunctionDefinition<num>(
  name: 'tan',
  parameters: [Parameter<num>(name: 'radians', presence: PresenceMandatory())],
  function: (context) {
    var radians = context.argumentValues['radians'] as num;
    return Future.value(tan(radians));
  },
  documentation: FunctionDefinitionDocumentation(
    description: 'Returns the the tangent of the radians',
    examples: [
      ExpressionBlockExample(
        (delimiter) => '${delimiter.start}tan(7)${delimiter.end}',
        shouldRender: tan(7).toString(),
      ),
      TestFileExample.fromProjectFilePath(
        'test/src/parser/expression/function/math/tan_test.dart',
      ),
    ],
  ),
);

final aTanFunction = FunctionDefinition<num>(
  name: 'atan',

  parameters: [Parameter<num>(name: 'value', presence: PresenceMandatory())],
  function: (context) {
    var value = context.argumentValues['value'] as num;
    return Future.value(atan(value));
  },
  documentation: FunctionDefinitionDocumentation(
    description: 'Returns the values arc tangent in radians',
    examples: [
      ExpressionBlockExample(
        (delimiter) => '${delimiter.start}atan(0.5)${delimiter.end}',
        shouldRender: atan(0.5).toString(),
      ),
      TestFileExample.fromProjectFilePath(
        'test/src/parser/expression/function/math/atan_test.dart',
      ),
    ],
  ),
);

final sqrtFunction = FunctionDefinition<num>(
  name: 'sqrt',

  parameters: [Parameter<num>(name: 'value', presence: PresenceMandatory())],
  function: (context) {
    var value = context.argumentValues['value'] as num;
    return Future.value(sqrt(value));
  },
  documentation: FunctionDefinitionDocumentation(
    description: 'Returns the positive square root of the value.',
    examples: [
      ExpressionBlockExample(
        (delimiter) => '${delimiter.start}sqrt(9)${delimiter.end}',
        shouldRender: sqrt(9).toString(),
      ),
      TestFileExample.fromProjectFilePath(
        'test/src/parser/expression/function/math/sqrt_test.dart',
      ),
    ],
  ),
);

final roundFunction = FunctionDefinition<num>(
  name: 'round',

  parameters: [Parameter<num>(name: 'value', presence: PresenceMandatory())],
  function: (context) {
    var value = context.argumentValues['value'];
    return Future.value(value.round());
  },
  documentation: FunctionDefinitionDocumentation(
    description: 'Returns the a rounded number.',
    examples: [
      ExpressionBlockExample(
        (delimiter) => '${delimiter.start}round(4.445)${delimiter.end}',
        shouldRender: 4.445.round().toString(),
      ),
      TestFileExample.fromProjectFilePath(
        'test/src/parser/expression/function/math/round_test.dart',
      ),
    ],
  ),
);
