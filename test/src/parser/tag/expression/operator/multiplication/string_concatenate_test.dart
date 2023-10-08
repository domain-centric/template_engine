import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{"Hel" & \'lo\'}} should render: "Hello"', () {
    var engine = TemplateEngine();
    var parseResult = engine.parseTemplate(TextTemplate('{{"Hel" & \'lo\'}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('Hello');
  });
}
