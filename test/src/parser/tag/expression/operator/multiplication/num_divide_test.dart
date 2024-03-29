import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{6/4}} should render: 1.5', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{6/4}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('1.5');
  });

  test('{{ 6 / 3 / 2 }} should render: 1.0', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{ 6 / 3 / 2}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('1.0');
  });
}
