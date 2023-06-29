import 'dart:math';

import 'package:template_engine/template_engine.dart';

/// Returns a list of functions that return a number
List<TagFunctionDefinition<num>> numFunctions() => [
      ExpFunction(),
      LogFunction(),
      SinFunction(),
      AsinFunction(),
      CosFunction(),
      AcosFunction(),
      TanFunction(),
      AtanFunction(),
      SqrtFunction(),
      StringLengthFunction(),
    ];

class ExpFunction extends TagFunctionDefinition<num> {
  ExpFunction()
      : super(
            name: 'exp',
            function: (parameters) => exp(parameters['value'] as num));
}

class LogFunction extends TagFunctionDefinition<num> {
  LogFunction()
      : super(
            name: 'log',
            function: (parameters) => log(parameters['value'] as num));
}

class SinFunction extends TagFunctionDefinition<num> {
  SinFunction()
      : super(
            name: 'sin',
            function: (parameters) => sin(parameters['value'] as num));
}

class AsinFunction extends TagFunctionDefinition<num> {
  AsinFunction()
      : super(
            name: 'asin',
            function: (parameters) => asin(parameters['value'] as num));
}

class CosFunction extends TagFunctionDefinition<num> {
  CosFunction()
      : super(
            name: 'cos',
            function: (parameters) => cos(parameters['value'] as num));
}

class AcosFunction extends TagFunctionDefinition<num> {
  AcosFunction()
      : super(
            name: 'acos',
            function: (parameters) => acos(parameters['value'] as num));
}

class TanFunction extends TagFunctionDefinition<num> {
  TanFunction()
      : super(
            name: 'tan',
            function: (parameters) => tan(parameters['value'] as num));
}

class AtanFunction extends TagFunctionDefinition<num> {
  AtanFunction()
      : super(
            name: 'atan',
            function: (parameters) => atan(parameters['value'] as num));
}

class SqrtFunction extends TagFunctionDefinition<num> {
  SqrtFunction()
      : super(
            name: 'sqrt',
            function: (parameters) => sqrt(parameters['value'] as num));
}

class StringLengthFunction extends TagFunctionDefinition<num> {
  StringLengthFunction()
      : super(
            name: 'length',
            function: (parameters) {
              var value = parameters['value'];
              if (value is String) {
                return value.length;
              } else {
                throw ParameterException(
                    'String expected'); //TODO add TemplateSource
              }
            });
}

class ParameterException implements Exception {
  final String message;

  ParameterException(this.message);
}
