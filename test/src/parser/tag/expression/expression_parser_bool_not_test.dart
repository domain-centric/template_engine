import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  given('expressionParser(ParserContext())', () {
    var parser = expressionParser(ParserContext());
    var context = RenderContext();
    when('calling: parser.parse("!FAlse").value.render(context)', () {
      var result = parser.parse("!FALSE").value.render(context);
      var expected = true;
      then('result should be: $expected', () => result.should.be(expected));
    });

    when('calling: parser.parse("  !  true  ").value.render(context)', () {
      var result = parser.parse("  !  true  ").value.render(context);
      var expected = false;
      then('result should be: $expected', () => result.should.be(expected));
    });

    when('calling: parser.parse("false | !FAlse").value.render(context)', () {
      var result = parser.parse("false | !FAlse").value.render(context);
      var expected = true;
      then('result should be: $expected', () => result.should.be(expected));
    });

    when('calling: parser.parse("  !FALse & !FAlSE  ").value.render(context)',
        () {
      var result = parser.parse("  !FALse & !FAlSE  ").value.render(context);
      var expected = true;
      then('result should be: $expected', () => result.should.be(expected));
    });

    when('calling: parser.parse("   false & ! true ").value.render(context)',
        () {
      var result = parser.parse("   false & ! true ").value.render(context);
      var expected = false;
      then('result should be: $expected', () => result.should.be(expected));
    });

    when('calling: parser.parse("   true &!False").value.render(context)', () {
      var result = parser.parse("   true &!False").value.render(context);
      var expected = true;
      then('result should be: $expected', () => result.should.be(expected));
    });

    when('calling: parser.parse("  ! TRUE |  ! true   ").value.render(context)',
        () {
      var result = parser.parse("  ! TRUE |  ! true   ").value.render(context);
      var expected = false;
      then('result should be: $expected', () => result.should.be(expected));
    });

    when('calling: parser.parse("   !true &False&false").value.render(context)',
        () {
      var result = parser.parse("   !true &False&false").value.render(context);
      var expected = false;
      then('result should be: $expected', () => result.should.be(expected));
    });

    when('calling: parser.parse("   false &False&trUE ").value.render(context)',
        () {
      var result = parser.parse("   false &False&trUE ").value.render(context);
      var expected = false;
      then('result should be: $expected', () => result.should.be(expected));
    });

    when(
        'calling: parser.parse("   true &TRUE&  ! falSE ").value.render(context)',
        () {
      var result =
          parser.parse("   true &TRUE&  ! falSE ").value.render(context);
      var expected = true;
      then('result should be: $expected', () => result.should.be(expected));
    });
  });
}
