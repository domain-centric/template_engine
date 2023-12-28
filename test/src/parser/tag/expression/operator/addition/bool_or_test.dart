import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{false|false}} should render: false', () async {
    var engine = TemplateEngine();
    var parseResult = engine.parseTemplate(TextTemplate('{{false|false}}'));
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('false');
  });
  test('{{false|true}} should render: true', () async {
    var engine = TemplateEngine();
    var parseResult = engine.parseTemplate(TextTemplate('{{false|true}}'));
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('true');
  });
  test('{{true|false}} should render: true', () async {
    var engine = TemplateEngine();
    var parseResult = engine.parseTemplate(TextTemplate('{{true|false}}'));
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('true');
  });
  test('{{true|true}} should render: true', () async {
    var engine = TemplateEngine();
    var parseResult = engine.parseTemplate(TextTemplate('{{true|true}}'));
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('true');
  });

  test('{{false | FALSE | falsE}} should render: false', () async {
    var engine = TemplateEngine();
    var parseResult =
        engine.parseTemplate(TextTemplate('{{false | FALSE | falsE}}'));
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('false');
  });
  test('{{ true | FALSE | truE }} should render: true', () async {
    var engine = TemplateEngine();
    var parseResult =
        engine.parseTemplate(TextTemplate('{{ true | FALSE | truE }}'));
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('true');
  });
  test('{{"text"|"text"}} should result in an error', () async {
    var engine = TemplateEngine();
    var parseResult = engine.parseTemplate(TextTemplate('{{"text"|"text"}}'));
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('{{ERROR}}');
    renderResult.errorMessage.should
        .be('Render error in: \'{{"text"|"text"}}\':\n'
            '  1:9: left and right of the | operator must be a boolean');
  });
}
