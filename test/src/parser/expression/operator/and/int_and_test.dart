import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{0&4}} should render: 0', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{0&4}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('0');
  });
  test('{{6&2}} should render: 2', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{6&2}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('2');
  });
  test('{{ "text" & 7 }} should result in an error', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{ "text" & 7 }}');
    var renderResult = await engine.render(parseResult);
    Should.satisfyAllConditions([
      () => renderResult.text.should.be('{{ERROR}}'),
      () => renderResult.errors.should.haveCount(1),
      () => renderResult.errors.first.message.should.be(
        "left of the & operator must be a int, "
        "or left and right of the & operator must be a boolean, "
        "or right of the & operator must be a String",
      ),
      () =>
          renderResult.errors.first.location.should.be(TemplateLocation(1, 11)),
    ]);
  });
}
