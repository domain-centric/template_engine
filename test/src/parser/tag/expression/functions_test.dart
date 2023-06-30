import 'dart:math';

import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  given('expressionParser()', () {
    var parser = expressionParser();
    var delta = 0.00001;
    when('calling: parser.parse("exp(7)").value.eval({}) as num', () {
      var result = parser.parse("exp(7)").value.eval({}) as num;
      var expected = exp(7);
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });

    when('calling: parser.parse("log(7)").value.eval({}) as num', () {
      var result = parser.parse("log(7)").value.eval({}) as num;
      var expected = log(7);
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });

    when('calling: parser.parse("sin(7)").value.eval({})) as num', () {
      var result = parser.parse("sin(7)").value.eval({}) as num;
      var expected = sin(7);
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });

    when('calling: parser.parse("asin(0.5)").value.eval({})) as num', () {
      var result = parser.parse("asin(0.5)").value.eval({}) as num;
      var expected = asin(0.5);
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });

    when('calling: parser.parse("cos(7)").value.eval({})) as num', () {
      var result = parser.parse("cos(7)").value.eval({}) as num;
      var expected = cos(7);
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });

    when('calling: parser.parse("acos(0.5)").value.eval({})) as num', () {
      var result = parser.parse("acos(0.5)").value.eval({}) as num;
      var expected = acos(0.5);
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });

    when('calling: parser.parse("tan(7)").value.eval({})) as num', () {
      var result = parser.parse("tan(7)").value.eval({}) as num;
      var expected = tan(7);
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });

    when('calling: parser.parse("atan(0.5)").value.eval({})) as num', () {
      var result = parser.parse("atan(0.5)").value.eval({}) as num;
      var expected = atan(0.5);
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });

    when('calling: parser.parse("sqrt(2)").value.eval({})) as num', () {
      var result = parser.parse("sqrt(2)").value.eval({}) as num;
      var expected = sqrt(2);
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });
  });
}