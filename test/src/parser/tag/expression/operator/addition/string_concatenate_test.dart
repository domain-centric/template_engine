import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{"Hel" + \'lo\'}} should render: "Hello"', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{"Hel" + \'lo\'}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('Hello');
  });
}
