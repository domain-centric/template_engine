import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{false&false}} should render: false', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(const TextTemplate('{{false&false}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('false');
  });
  test('{{false&true}} should render: false', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(const TextTemplate('{{false&true}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('false');
  });
  test('{{true&false}} should render: false', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(const TextTemplate('{{true&false}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('false');
  });
  test('{{true&true}} should render: true', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(const TextTemplate('{{true&true}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('true');
  });

  test('{{false & true & false}} should render: false', () {
    var engine = TemplateEngine();
    var parseResult =
        engine.parse(const TextTemplate('{{false & true & false}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('false');
  });
  test('{{ true & TRUE & truE }} should render: true', () {
    var engine = TemplateEngine();
    var parseResult =
        engine.parse(const TextTemplate('{{ true & TRUE & truE }}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('true');
  });
}
