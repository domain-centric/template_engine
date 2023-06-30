import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  given('expressionParser()', () {
    var parser = expressionParser();

    when('calling: parser.parse("5 - 3").value.eval({})', () {
      var result = parser.parse("5 - 3").value.eval({});
      var expected = 2;
      then('result should be: $expected', () => result.should.be(expected));
    });

    when('calling: parser.parse("5 - 3 - 4").value.eval({})', () {
      var result = parser.parse("5 - 3 - 4").value.eval({});
      var expected = -2;
      then('result should be: $expected', () => result.should.be(expected));
    });
  });
}