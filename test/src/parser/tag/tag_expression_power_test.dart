import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/src/parser/tag/tag_expression.dart';

void main() {
  given('expressionParser', () {
    var parser = expressionParser;
    double delta = 0.00001;
    when('calling: parser.parse("2 ^ 3").value.eval({})', () {
      var result = parser.parse("2 ^ 3").value.eval({});
      var expected = 8;
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });

    when('calling: parser.parse("2 ^ -3").value.eval({})', () {
      var result = parser.parse("2 ^ -3").value.eval({});
      var expected = 0.125;
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });

    when('calling: parser.parse("-2 ^ 3").value.eval({})', () {
      var result = parser.parse("-2 ^ 3").value.eval({});
      var expected = -8;
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });

    when('calling: parser.parse("-2 ^ -3").value.eval({})', () {
      var result = parser.parse("-2 ^ -3").value.eval({});
      var expected = -0.125;
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });
  });
}
