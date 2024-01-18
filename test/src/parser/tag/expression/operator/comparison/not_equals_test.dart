import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{4!=2+3}} should return true', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{4!=2+3}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('true');
  });

  test('{{ 4   != 2  + 3 }} should return true', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{ 4   != 2  + 3 }}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('true');
  });

  test('{{4!=4}} should return false', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{4!=4}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('false');
  });

  test("{{name!='World'}} should return true", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{name!='World'}}");
    var renderResult = await engine.render(parseResult, {'name': 'Joe'});
    renderResult.text.should.be('true');
  });

  test("{{name!='Devil'}} should return true", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{name!='Devil'}}");
    var renderResult = await engine.render(parseResult, {'name': 'Joe'});
    renderResult.text.should.be('true');
  });

  test("{{'1'!=1}} should result in true", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{'1'!=1}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('true');
  });
}
