import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{2>=1}} should return true', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{2>=1}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('true');
  });
  test('{{2>=2}} should return true', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{2>=2}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('true');
  });
  test('{{6>=2+3}} should return true', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{6>=2+3}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('true');
  });
  test('{{6>=3+3}} should return true', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{6>=3+3}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('true');
  });

  test('{{ 6  >= 3  + 3 }} should return true', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{ 6  >= 3  + 3 }}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('true');
  });

  test('{{1>=2}} should return false', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{1>=2}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('false');
  });

  test("{{two>=1}} should return true", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{two>=1}}");
    var renderResult = await engine.render(parseResult, variables: {'two': 2});
    renderResult.text.should.be('true');
  });

  test("{{two>=3}} should return false", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{two>=3}}");
    var renderResult = await engine.render(parseResult, variables: {'two': 2});
    renderResult.text.should.be('false');
  });

  test("{{'2'>=1}} should result in false", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{'2'>=1}}");
    var renderResult = await engine.render(parseResult);
    Should.satisfyAllConditions([
      () => renderResult.text.should.be('{{ERROR}}'),
      () => renderResult.errors.should.haveCount(1),
      () => renderResult.errors.first.message.should.be(
        "left of the >= operator must be a number",
      ),
      () =>
          renderResult.errors.first.location.should.be(TemplateLocation(1, 6)),
    ]);
  });
}
