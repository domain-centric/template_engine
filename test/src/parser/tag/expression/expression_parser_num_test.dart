import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  given('expressionParser(ParserContext())', () {
    var parser = expressionParser(ParserContext(engine: TemplateEngine()));
    var input = "0";
    double delta = 0.00001;
    var context = RenderContext();
    when('calling: parser.parse("$input").value.render(context) as num', () {
      var result = parser.parse(input).value.render(context) as num;
      var expected = 0;
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });

    input = "42";
    when('calling: parser.parse("$input").value.render(context) as num', () {
      var result = parser.parse(input).value.render(context) as num;
      var expected = 42;
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });

    input = "3.141";
    when('calling: parser.parse("$input").value.render(context) as num', () {
      var result = parser.parse(input).value.render(context) as num;
      var expected = 3.141;
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });

    input = "1.2e5";
    when('parsing "$input"', () {
      var result = parser.parse(input).value.render(context) as num;
      var expected = 1.2e5;
      then('calling: parser.parse("$input").value.render(context) as num',
          () => result.should.beCloseTo(expected, delta: delta));
    });

    input = "3.4e-1";
    when('calling: parser.parse("$input").value.render(context) as num', () {
      var result = parser.parse(input).value.render(context) as num;
      var expected = 3.4e-1;
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });
  });
}
