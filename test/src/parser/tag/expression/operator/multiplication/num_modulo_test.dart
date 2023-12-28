import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{5%3}} should render: 2', () async {
    var engine = TemplateEngine();
    var parseResult = engine.parseTemplate(TextTemplate('{{5%3}}'));
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('2');
  });

  test('{{-5 % 3}} should render: 1', () async {
    var engine = TemplateEngine();
    var parseResult = engine.parseTemplate(TextTemplate('{{-5 % 3}}'));
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('1');
  });

  test('{{ 20 % 15 % 3 }} should render: 2', () async {
    var engine = TemplateEngine();
    var parseResult = engine.parseTemplate(TextTemplate('{{ 20 % 15 % 3 }}'));
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('2');
  });
}
