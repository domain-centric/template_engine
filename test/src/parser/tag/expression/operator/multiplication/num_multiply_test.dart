import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{2*3}} should render: 6', () async {
    var engine = TemplateEngine();
    var parseResult = engine.parseTemplate(TextTemplate('{{2*3}}'));
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('6');
  });

  test('{{1.3*4}} should render: 5.2', () async {
    var engine = TemplateEngine();
    var parseResult = engine.parseTemplate(TextTemplate('{{1.3*4}}'));
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('5.2');
  });

  test('{{ 2 * 3 * 4 }} should render: 24', () async {
    var engine = TemplateEngine();
    var parseResult = engine.parseTemplate(TextTemplate('{{ 2 * 3 * 4 }}'));
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('24');
  });
}
