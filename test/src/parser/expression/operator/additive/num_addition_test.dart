import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{2+3}} should render: 5', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{2+3}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('5');
  });

  test('{{ 2 + 3 + 4 }} should render: 9', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{ 2 + 3 + 4 }}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('9');
  });
}
