import 'dart:math';

import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  given('expressionParser(ParserContext())', () {
    var parser = expressionParser(ParserContext());
    double delta = 0.00001;
    when('calling: parser.parse("pi").value.eval({}) as num', () {
      var result = parser.parse("pi").value.eval({}) as num;
      var expected = pi;
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });

    when('calling: parser.parse("e").value.eval({}) as num', () {
      var result = parser.parse("e").value.eval({}) as num;
      var expected = e;
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });
  });
}
