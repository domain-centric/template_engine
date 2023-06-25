import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  given('expressionParser', () {
    var parser = numExpressionParser;
    double delta = 0.00001;
    when('calling: parser.parse("2 + 3").value.eval({})', () {
      var result = parser.parse("2 + 3").value.eval({});
      var expected = 5;
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });

    when('calling: parser.parse("2 + 3 + 4").value.eval({})', () {
      var result = parser.parse("2 + 3 + 4").value.eval({});
      var expected = 9;
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });

    when('calling: parser.parse("5 - 3").value.eval({})', () {
      var result = parser.parse("5 - 3").value.eval({});
      var expected = 2;
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });

    when('calling: parser.parse("5 - 3 - 4").value.eval({})', () {
      var result = parser.parse("5 - 3 - 4").value.eval({});
      var expected = -2;
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });
  });
}
