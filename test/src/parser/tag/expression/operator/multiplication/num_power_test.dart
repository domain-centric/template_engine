import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{2^3}} should render: 8', () async {
    var engine = TemplateEngine();
    var parseResult = engine.parseTemplate(TextTemplate('{{2^3}}'));
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('8');
  });

  test('{{2^-3}} should render: 0.125', () async {
    var engine = TemplateEngine();
    var parseResult = engine.parseTemplate(TextTemplate('{{2^-3}}'));
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('0.125');
  });

  test('{{ -2 ^ 3 }} should render: -8', () async {
    var engine = TemplateEngine();
    var parseResult = engine.parseTemplate(TextTemplate('{{ -2 ^ 3 }}'));
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('-8');
  });

  test('{{ -2 ^ -3 }} should render: -0.125', () async {
    var engine = TemplateEngine();
    var parseResult = engine.parseTemplate(TextTemplate('{{ -2 ^ -3 }}'));
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('-0.125');
  });
}
