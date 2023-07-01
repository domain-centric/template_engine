import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  given('expressionParser(ParserContext())', () {
    var parser = expressionParser(ParserContext());
    double delta = 0.00001;
    when('calling: parser.parse("2 * 3").value.eval({})', () {
      var result = parser.parse("2 * 3").value.eval({});
      var expected = 6;
      then('result should be: $expected', () => result.should.be(expected));
    });

    when('calling: parser.parse("1.3*4").value.eval({}) as num', () {
      var result = parser.parse("1.3*4").value.eval({}) as num;
      var expected = 5.2;
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });

    when('calling: parser.parse("2 * 3 * 4").value.eval({})', () {
      var result = parser.parse("2 * 3 * 4").value.eval({});
      var expected = 24;
      then('result should be: $expected', () => result.should.be(expected));
    });
  });
}
