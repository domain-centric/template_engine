import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  given('expressionParser()', () {
    var parser = expressionParser();

    when('calling: parser.parse("true").value.eval({})', () {
      var result = parser.parse("true").value.eval({});
      var expected = true;
      then('result should be: $expected', () => result.should.be(expected));
    });

    when('calling: parser.parse("trUE").value.eval({})', () {
      var result = parser.parse("trUE").value.eval({});
      var expected = true;
      then('result should be: $expected', () => result.should.be(expected));
    });

    when('calling: parser.parse("   trUE").value.eval({})', () {
      var result = parser.parse("   trUE").value.eval({});
      var expected = true;
      then('result should be: $expected', () => result.should.be(expected));
    });

    when('calling: parser.parse("   trUE   ").value.eval({})', () {
      var result = parser.parse("   trUE   ").value.eval({});
      var expected = true;
      then('result should be: $expected', () => result.should.be(expected));
    });
  });
}