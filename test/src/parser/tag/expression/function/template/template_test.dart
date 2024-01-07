import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  given('Template engine', () {
    var engine = TemplateEngine();

    when("call: engine.parse(TemplateWithTemplateSourceFunction())", () {
      var parseResult =
          engine.parseTemplate(TemplateWithTemplateSourceFunction());
      when('calling: await engine.render(parseResult)', () {
        var expected = TemplateWithTemplateSourceFunction().source;
        then('renderResult.text be: "$expected"', () async {
          var renderResult = await engine.render(parseResult);
          return renderResult.text.should.be(expected);
        });
      });
    });
  });
}

class TemplateWithTemplateSourceFunction extends Template {
  TemplateWithTemplateSourceFunction()
      : super(
            source: 'doc/template/generic/generated.md.template',
            text: '{{templateSource()}}');
}
