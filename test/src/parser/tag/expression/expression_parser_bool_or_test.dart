import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  given('expressionParser(ParserContext())', () {
    var parser = expressionParser(ParserContext());

    when('calling: parser.parse("false | FAlse").value.eval({})', () {
      var result = parser.parse("false | FAlse").value.eval({});
      var expected = false;
      then('result should be: $expected', () => result.should.be(expected));
    });

    when('calling: parser.parse("  FALse | FAlSE  ").value.eval({})', () {
      var result = parser.parse("  FALse | FAlSE  ").value.eval({});
      var expected = false;
      then('result should be: $expected', () => result.should.be(expected));
    });

    when('calling: parser.parse("   false | true ").value.eval({})', () {
      var result = parser.parse("   false | true ").value.eval({});
      var expected = true;
      then('result should be: $expected', () => result.should.be(expected));
    });

    when('calling: parser.parse("   true |False").value.eval({})', () {
      var result = parser.parse("   true |False").value.eval({});
      var expected = true;
      then('result should be: $expected', () => result.should.be(expected));
    });

    when('calling: parser.parse("   TRUE |   true   ").value.eval({})', () {
      var result = parser.parse("   TRUE |   true   ").value.eval({});
      var expected = true;
      then('result should be: $expected', () => result.should.be(expected));
    });

    when('calling: parser.parse("   true |False|false").value.eval({})', () {
      var result = parser.parse("   true |False|false").value.eval({});
      var expected = true;
      then('result should be: $expected', () => result.should.be(expected));
    });

    when('calling: parser.parse("   false |False|trUE ").value.eval({})', () {
      var result = parser.parse("   false |False|trUE ").value.eval({});
      var expected = true;
      then('result should be: $expected', () => result.should.be(expected));
    });
  });
}
