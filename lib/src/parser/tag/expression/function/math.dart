import 'dart:math';

import 'package:template_engine/template_engine.dart';

class MathFunctions extends FunctionGroup {
  MathFunctions()
      : super('Math', [
          Exp(),
          Log(),
          Sin(),
          Asin(),
          Cos(),
          Acos(),
          Tan(),
          Atan(),
          Sqrt(),
        ]);
}

class Exp extends ExpressionFunction<num> {
  Exp()
      : super(
            name: 'exp',
            description: 'Returns the natural exponent e, '
                'to the power of the value',
            exampleExpression: '{{exp(7)}}',
            exampleResult: exp(7).toString(),
            parameters: [
              Parameter<num>(name: 'value', presence: Presence.mandatory())
            ],
            function: (renderContext, parameters) =>
                exp(parameters['value'] as num));
}

class Log extends ExpressionFunction<num> {
  Log()
      : super(
            name: 'log',
            description: 'Returns the natural logarithm of the value',
            exampleExpression: '{{log(7)}}',
            exampleResult: log(7).toString(),
            parameters: [
              Parameter<num>(name: 'value', presence: Presence.mandatory())
            ],
            function: (renderContext, parameters) =>
                log(parameters['value'] as num));
}

class Sin extends ExpressionFunction<num> {
  Sin()
      : super(
            name: 'sin',
            description: 'Returns the sine of the radians',
            exampleExpression: '{{sin(7)}}',
            exampleResult: sin(7).toString(),
            parameters: [
              Parameter<num>(name: 'radians', presence: Presence.mandatory())
            ],
            function: (renderContext, parameters) =>
                sin(parameters['radians'] as num));
}

class Asin extends ExpressionFunction<num> {
  Asin()
      : super(
            name: 'asin',
            description: 'Returns the values arc sine in radians',
            exampleExpression: '{{asin(0.5)}}',
            exampleResult: asin(0.5).toString(),
            parameters: [
              Parameter<num>(name: 'value', presence: Presence.mandatory())
            ],
            function: (renderContext, parameters) =>
                asin(parameters['value'] as num));
}

class Cos extends ExpressionFunction<num> {
  Cos()
      : super(
            name: 'cos',
            description: 'Returns the cosine of the radians',
            exampleExpression: '{{cos(7)}}',
            exampleResult: cos(7).toString(),
            parameters: [
              Parameter<num>(name: 'radians', presence: Presence.mandatory())
            ],
            function: (renderContext, parameters) =>
                cos(parameters['radians'] as num));
}

class Acos extends ExpressionFunction<num> {
  Acos()
      : super(
            name: 'acos',
            description: 'Returns the values arc cosine in radians',
            exampleExpression: '{{acos(0.5)}}',
            exampleResult: acos(0.5).toString(),
            parameters: [
              Parameter<num>(name: 'value', presence: Presence.mandatory())
            ],
            function: (renderContext, parameters) =>
                acos(parameters['value'] as num));
}

class Tan extends ExpressionFunction<num> {
  Tan()
      : super(
            name: 'tan',
            description: 'Returns the the tangent of the radians',
            exampleExpression: '{{tan(7)}}',
            exampleResult: tan(7).toString(),
            parameters: [
              Parameter<num>(name: 'radians', presence: Presence.mandatory())
            ],
            function: (renderContext, parameters) =>
                tan(parameters['radians'] as num));
}

class Atan extends ExpressionFunction<num> {
  Atan()
      : super(
            name: 'atan',
            description: 'Returns the values arc tangent in radians',
            exampleExpression: '{{atan(0.5)}}',
            exampleResult: atan(0.5).toString(),
            parameters: [
              Parameter<num>(name: 'value', presence: Presence.mandatory())
            ],
            function: (renderContext, parameters) =>
                atan(parameters['value'] as num));
}

class Sqrt extends ExpressionFunction<num> {
  Sqrt()
      : super(
            name: 'sqrt',
            description: 'Returns the positive square root of the value.',
            exampleExpression: '{{sqrt(9)}}',
            exampleResult: sqrt(9).toString(),
            parameters: [
              Parameter<num>(name: 'value', presence: Presence.mandatory())
            ],
            function: (renderContext, parameters) =>
                sqrt(parameters['value'] as num));
}
