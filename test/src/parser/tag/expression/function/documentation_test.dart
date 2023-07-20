import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  given('Template engine', () {
    var engine = TemplateEngine();
    when(
        "call: engine.parse(const "
        "TextTemplate('{{engine.tag.documentation()}}'))", () {
      var parseResult =
          engine.parse(const TextTemplate('{{engine.tag.documentation()}}'));
      var expected = '# ExpressionTag\n'
          'Example: The cos of 2 pi = {{cos(2 * pi)}}. '
          'The volume of a sphere = {{ (3/4) * pi * (radius ^ 3) }}.\n'
          'Evaluates an expression that can contain values (bool, num, string),'
          ' operators, functions, constants and variables.\n';
      then('parseResult.errors.length should be0',
          () => parseResult.errors.length.should.be(0));
      when('calling: engine.render(parseResult)', () {
        var renderResult = engine.render(parseResult);

        then('renderResult.text be: "$expected"',
            () => renderResult.text.should.be(expected));
      });
    });
  });
}
