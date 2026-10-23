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
  test('{{12 & "text"}} should result in an error', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{ 12 & "text"}}');
    var renderResult = await engine.render(parseResult);
    Should.satisfyAllConditions([
      () => renderResult.text.should.be('{{ERROR}}'),
      () => renderResult.errors.should.haveCount(1),
      () => renderResult.errors.first.message.should.be(
        "right of the & operator must be a int, "
        "or left and right of the & operator must be a boolean, "
        "or left of the & operator must be a String",
      ),
      () =>
          renderResult.errors.first.location.should.be(TemplateLocation(1, 7)),
    ]);
  });
}
