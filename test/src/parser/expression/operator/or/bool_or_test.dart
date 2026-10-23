import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{false|false}} should render: false', () async {
    final engine = TemplateEngine();
    final parseResult = await engine.parseText('{{false|false}}');
    final renderResult = await engine.render(parseResult);
    renderResult.text.should.be('false');
  });
  test('{{false|true}} should render: true', () async {
    final engine = TemplateEngine();
    final parseResult = await engine.parseText('{{false|true}}');
    final renderResult = await engine.render(parseResult);
    renderResult.text.should.be('true');
  });
  test('{{true|false}} should render: true', () async {
    final engine = TemplateEngine();
    final parseResult = await engine.parseText('{{true|false}}');
    final renderResult = await engine.render(parseResult);
    renderResult.text.should.be('true');
  });
  test('{{true|true}} should render: true', () async {
    final engine = TemplateEngine();
    final parseResult = await engine.parseText('{{true|true}}');
    final renderResult = await engine.render(parseResult);
    renderResult.text.should.be('true');
  });

  test('{{false | FALSE | falsE}} should render: false', () async {
    final engine = TemplateEngine();
    final parseResult = await engine.parseText('{{false | FALSE | falsE}}');
    final renderResult = await engine.render(parseResult);
    renderResult.text.should.be('false');
  });
  test('{{ true | FALSE | truE }} should render: true', () async {
    final engine = TemplateEngine();
    final parseResult = await engine.parseText('{{ true | FALSE | truE }}');
    final renderResult = await engine.render(parseResult);
    renderResult.text.should.be('true');
  });
  test('{{"text"|"text"}} should result in an error', () async {
    final engine = TemplateEngine();
    final parseResult = await engine.parseText('{{"text"|"text"}}');
    final renderResult = await engine.render(parseResult);
    Should.satisfyAllConditions([
      () => renderResult.text.should.be('{{ERROR}}'),
      () => renderResult.errors.should.haveCount(1),
      () => renderResult.errors.first.message.should.be(
        "left and right of the | operator must be a int, "
        "or left and right of the | operator must be a boolean",
      ),
      () =>
          renderResult.errors.first.location.should.be(TemplateLocation(1, 9)),
    ]);
  });
}
