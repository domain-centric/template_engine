import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{6/4}} should render: 1.5', () {
    var engine = TemplateEngine();
    var parseResult = engine.parseTemplate(TextTemplate('{{6/4}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('1.5');
  });

  test('{{ 6 / 3 / 2 }} should render: 1.0', () {
    var engine = TemplateEngine();
    var parseResult = engine.parseTemplate(TextTemplate('{{ 6 / 3 / 2}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('1.0');
  });
}
