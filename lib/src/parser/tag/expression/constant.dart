import 'dart:math';

import 'package:collection/collection.dart';
import 'package:petitparser/petitparser.dart';
import 'package:template_engine/template_engine.dart';

class Constant {
  Constant(
      {required this.name, required this.description, required this.value});
  final String name;
  final String description;
  final double value;
}

class DefaultConstants extends DelegatingList<Constant> {
  DefaultConstants()
      : super([
          Constant(
              name: 'e',
              description: 'Base of the natural logarithms.',
              value: e),
          Constant(
              name: 'ln10',
              description: 'Natural logarithm of 10.',
              value: ln10),
          Constant(
              name: 'ln2', description: 'Natural logarithm of 2.', value: ln2),
          Constant(
              name: 'log10e',
              description: 'Base-10 logarithm of e.',
              value: log10e),
          Constant(
              name: 'log2e',
              description: 'Base-2 logarithm of e.',
              value: log2e),
          Constant(
              name: 'pi',
              description:
                  "The ratio of a circle's circumference to its diameter",
              value: pi),
        ]);
}

Parser<Expression<num>> constantParser(List<Constant> constants) {
  return ChoiceParser(constants.map((constant) => string(constant.name)))
      .flatten('constant expected')
      .trim()
      .map((name) => Value<num>(
          constants.firstWhere((constant) => constant.name == name).value));
}
