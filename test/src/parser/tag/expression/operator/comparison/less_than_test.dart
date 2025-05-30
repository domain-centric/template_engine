import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{1<2}} should return true', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{1<2}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('true');
  });
  test('{{4<2+3}} should return true', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{4<2+3}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('true');
  });

  test('{{ 4  < 2  + 3 }} should return true', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{ 4  < 2  + 3 }}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('true');
  });

  test('{{2<1}} should return false', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{2<1}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('false');
  });

  test("{{two<1}} should return false", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{two<1}}");
    var renderResult = await engine.render(parseResult, {'two': 2});
    renderResult.text.should.be('false');
  });

  test("{{two<3}} should return true", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{two<3}}");
    var renderResult = await engine.render(parseResult, {'two': 2});
    renderResult.text.should.be('true');
  });

  test("{{'2'<1}} should result in false", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{'2'<1}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('{{ERROR}}');
    renderResult.errorMessage.should.be(
      "Render error in: '{{'2'<1}}':\n"
      "  1:6: left of the < operator must be a number",
    );
  });
}
