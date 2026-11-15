import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{"-"*3}} should render: "---"', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{"-"*3}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('---');
  });

  test('{{"Hello"*2}} should render: "HelloHello"', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{"Hello"*2}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('HelloHello');
  });

  test('{{ "!" * (2+3) }} should render: "!!!!!"', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{ "!" * (2+3) }}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('!!!!!');
  });
}
