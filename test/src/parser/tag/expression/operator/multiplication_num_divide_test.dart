import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  given('expressionParser(ParserContext())', () {
    var engine = TemplateEngine();
    var parser = expressionParser(ParserContext(engine));
    double delta = 0.00001;
    var context = RenderContext(engine);
    when('calling: parser.parse("6 / 4").value.render(context) as num', () {
      var result = parser.parse("6 / 4").value.render(context) as num;
      var expected = 1.5;
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });

    when('calling: parser.parse("6 / 3 / 2").value.render(context)', () {
      var result = parser.parse("6 / 3 / 2").value.render(context);
      var expected = 1;
      then('result should be: $expected', () => result.should.be(expected));
    });
  });
}
