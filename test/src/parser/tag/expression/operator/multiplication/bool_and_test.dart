import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{false&false}} should render: false', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{false&false}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('false');
  });
  test('{{false&true}} should render: false', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{false&true}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('false');
  });
  test('{{true&false}} should render: false', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{true&false}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('false');
  });
  test('{{true&true}} should render: true', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{true&true}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('true');
  });

  test('{{false & true & false}} should render: false', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{false & true & false}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('false');
  });
  test('{{ true & TRUE & truE }} should render: true', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{ true & TRUE & truE }}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('true');
  });
}
