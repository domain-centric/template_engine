import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  given('Template engine', () {
    var engine = TemplateEngine();
    var template = TemplateWithTemplateSourceFunction();
    when("call: engine.parse(TemplateWithTemplateSourceFunction())", () {
      when('calling: await engine.render(parseResult)', () {
        var expected = template.source;
        then('renderResult.text be: "$expected"', () async {
          var parseResult = await engine.parseTemplate(template);
          var renderResult = await engine.render(parseResult);
          return renderResult.text.should.be(expected);
        });
      });
    });
  });
}

class TemplateWithTemplateSourceFunction extends Template {
  TemplateWithTemplateSourceFunction() {
    source = 'doc/template/generic/generated.md.template';
    sourceTitle = source;
    text = Future.value('{{templateSource()}}');
  }
}
