import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/src/parser/tag/tag_expression.dart';

void main() {
  given('expressionParser', () {
    var parser = numExpressionParser;
    double delta = 0.00001;
    when('calling: parser.parse("2 * 3").value.eval({})', () {
      var result = parser.parse("2 * 3").value.eval({});
      var expected = 6;
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });

    when('calling: parser.parse("2 * 3 * 4").value.eval({})', () {
      var result = parser.parse("2 * 3 * 4").value.eval({});
      var expected = 24;
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });

    when('calling: parser.parse("6 / 3").value.eval({})', () {
      var result = parser.parse("6 / 3").value.eval({});
      var expected = 2;
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });

    when('calling: parser.parse("6 / 3 / 2").value.eval({})', () {
      var result = parser.parse("6 / 3 / 2").value.eval({});
      var expected = 1;
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });
  });
}
