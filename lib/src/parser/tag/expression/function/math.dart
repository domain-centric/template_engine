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
            parameters: [
              Parameter(name: 'value', presence: Presence.mandatory())
            ],
            function: (parameters) => exp(parameters['value'] as num));
}

class Log extends ExpressionFunction<num> {
  Log()
      : super(
            name: 'log',
            parameters: [
              Parameter(name: 'value', presence: Presence.mandatory())
            ],
            function: (parameters) => log(parameters['value'] as num));
}

class Sin extends ExpressionFunction<num> {
  Sin()
      : super(
            name: 'sin',
            parameters: [
              Parameter(name: 'value', presence: Presence.mandatory())
            ],
            function: (parameters) => sin(parameters['value'] as num));
}

class Asin extends ExpressionFunction<num> {
  Asin()
      : super(
            name: 'asin',
            parameters: [
              Parameter(name: 'value', presence: Presence.mandatory())
            ],
            function: (parameters) => asin(parameters['value'] as num));
}

class Cos extends ExpressionFunction<num> {
  Cos()
      : super(
            name: 'cos',
            parameters: [
              Parameter(name: 'value', presence: Presence.mandatory())
            ],
            function: (parameters) => cos(parameters['value'] as num));
}

class Acos extends ExpressionFunction<num> {
  Acos()
      : super(
            name: 'acos',
            parameters: [
              Parameter(name: 'value', presence: Presence.mandatory())
            ],
            function: (parameters) => acos(parameters['value'] as num));
}

class Tan extends ExpressionFunction<num> {
  Tan()
      : super(
            name: 'tan',
            parameters: [
              Parameter(name: 'value', presence: Presence.mandatory())
            ],
            function: (parameters) => tan(parameters['value'] as num));
}

class Atan extends ExpressionFunction<num> {
  Atan()
      : super(
            name: 'atan',
            parameters: [
              Parameter(name: 'value', presence: Presence.mandatory())
            ],
            function: (parameters) => atan(parameters['value'] as num));
}

class Sqrt extends ExpressionFunction<num> {
  Sqrt()
      : super(
            name: 'sqrt',
            parameters: [
              Parameter(name: 'value', presence: Presence.mandatory())
            ],
            function: (parameters) => sqrt(parameters['value'] as num));
}
