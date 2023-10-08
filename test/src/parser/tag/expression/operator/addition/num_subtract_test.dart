import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{5-3}} should render: 2', () {
    var engine = TemplateEngine();
    var parseResult = engine.parseTemplate(TextTemplate('{{5-3}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('2');
  });

  test('{{ 5 - 3 - 4 }} should render: -2', () {
    var engine = TemplateEngine();
    var parseResult = engine.parseTemplate(TextTemplate('{{ 5 - 3 - 4 }}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('-2');
  });
}
