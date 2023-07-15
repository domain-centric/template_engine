import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  given('expressionParser(ParserContext())', () {
    var parser = expressionParser(ParserContext(engine: TemplateEngine()));
    var context = RenderContext();
    when('calling: parser.parse("false").value.render(context)', () {
      var result = parser.parse("false").value.render(context);
      var expected = false;
      then('result should be: $expected', () => result.should.be(expected));
    });

    when('calling: parser.parse("FALse").value.render(context)', () {
      var result = parser.parse("FALse").value.render(context);
      var expected = false;
      then('result should be: $expected', () => result.should.be(expected));
    });

    when('calling: parser.parse("   FALse").value.render(context)', () {
      var result = parser.parse("   FALse").value.render(context);
      var expected = false;
      then('result should be: $expected', () => result.should.be(expected));
    });

    when('calling: parser.parse("   FALse   ").value.render(context)', () {
      var result = parser.parse("   FALse   ").value.render(context);
      var expected = false;
      then('result should be: $expected', () => result.should.be(expected));
    });
  });
}
