import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{1 + 3 * 2}} should render: 7', () async {
    var engine = TemplateEngine();
    var parseResult = engine.parseTemplate(TextTemplate("{{1 + 3 * 2}}"));
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('7');
  });

  test('{{(1 + 3) * 2}} should render: 8', () async {
    var engine = TemplateEngine();
    var parseResult = engine.parseTemplate(TextTemplate("{{(1 + 3) * 2}}"));
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('8');
  });

  test('{{true & (false | true)}} should render: true', () async {
    var engine = TemplateEngine();
    var parseResult =
        engine.parseTemplate(TextTemplate("{{true & (false | true)}}"));
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('true');
  });
}
