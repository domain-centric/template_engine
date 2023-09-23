import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{false|false}} should render: false', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(TextTemplate('{{false|false}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('false');
  });
  test('{{false|true}} should render: true', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(TextTemplate('{{false|true}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('true');
  });
  test('{{true|false}} should render: true', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(TextTemplate('{{true|false}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('true');
  });
  test('{{true|true}} should render: true', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(TextTemplate('{{true|true}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('true');
  });

  test('{{false | FALSE | falsE}} should render: false', () {
    var engine = TemplateEngine();
    var parseResult =
        engine.parse(TextTemplate('{{false | FALSE | falsE}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('false');
  });
  test('{{ true | FALSE | truE }} should render: true', () {
    var engine = TemplateEngine();
    var parseResult =
        engine.parse(TextTemplate('{{ true | FALSE | truE }}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('true');
  });
  test('{{"text"|"text"}} should result in an error', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(TextTemplate('{{"text"|"text"}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('{{ERROR}}');
    renderResult.errorMessage.should
        .be('Render error in: \'{{"text"|"text"}}\':\n'
  '  1:9: left and right of the | operator must be a boolean');
  });
}
