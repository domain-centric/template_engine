import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{!FALSE}} should render: true', () async {
    final engine = TemplateEngine();
    final parseResult = await engine.parseText("{{!FALSE}}");
    final renderResult = await engine.render(parseResult);
    renderResult.text.should.be('true');
  });

  test('{{  !  true  }} should render: false', () async {
    final engine = TemplateEngine();
    final parseResult = await engine.parseText("{{  !  true  }}");
    final renderResult = await engine.render(parseResult);
    renderResult.text.should.be('false');
  });

  test('{{false | !FAlse}} should render: true', () async {
    final engine = TemplateEngine();
    final parseResult = await engine.parseText("{{false | !FAlse}}");
    final renderResult = await engine.render(parseResult);
    renderResult.text.should.be('true');
  });

  test('{{!"text"}} should throw in an error', () async {
    final engine = TemplateEngine();
    final parseResult = await engine.parseText('{{!"text"}}');
    final renderResult = await engine.render(parseResult);
    Should.satisfyAllConditions([
      () => renderResult.text.should.be('{{ERROR}}'),
      () => renderResult.errors.should.haveCount(1),
      () => renderResult.errors.first.message.should.be(
        "boolean expected after the ! operator",
      ),
      () =>
          renderResult.errors.first.location.should.be(TemplateLocation(1, 3)),
    ]);
  });
}
