import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{2+3}} should render: 5', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(TextTemplate('{{2+3}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('5');
  });

  test('{{ 2 + 3 + 4 }} should render: 9', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(TextTemplate('{{ 2 + 3 + 4 }}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('9');
  });
}
