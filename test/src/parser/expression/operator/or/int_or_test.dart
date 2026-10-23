import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{0|4}} should render: 4', () async {
    final engine = TemplateEngine();
    final parseResult = await engine.parseText('{{0|4}}');
    final renderResult = await engine.render(parseResult);
    renderResult.text.should.be('4');
  });
  test('{{5|2}} should render: 7', () async {
    final engine = TemplateEngine();
    final parseResult = await engine.parseText('{{5|2}}');
    final renderResult = await engine.render(parseResult);
    renderResult.text.should.be('7');
  });
  test('{{ "text" | 6.5 }} should result in an error', () async {
    final engine = TemplateEngine();
    final parseResult = await engine.parseText('{{ "text" | 6.5 }}');
    final renderResult = await engine.render(parseResult);
    Should.satisfyAllConditions([
      () => renderResult.text.should.be('{{ERROR}}'),
      () => renderResult.errors.should.haveCount(1),
      () => renderResult.errors.first.message.should.be(
        "left and right of the | operator must be a int, "
        "or left and right of the | operator must be a boolean",
      ),
      () =>
          renderResult.errors.first.location.should.be(TemplateLocation(1, 11)),
    ]);
  });
}
