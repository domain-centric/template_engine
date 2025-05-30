import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{x=12}} should return ""', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{x=12}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('');
  });

  test('{{x=12}}{{x}} should return 12', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{x=12}}{{x}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('12');
  });

  test('{{ x =  12   }}{{  x }} should return 12', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{ x =  12   }}{{  x }}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('12');
  });

  test('{{x=12}}{{x+3}} should return 15', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{x=12}}{{x+3}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('15');
  });

  test('{{x=2}}{{x=x+3}}{{x}} should return 5', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{x=2}}{{x=x+3}}{{x}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('5');
  });

  test('{{1=2}} should result in an error', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{1=2}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('{{ERROR}}');
    renderResult.errorMessage.should.be(
      "Render error in: '{{1=2}}':\n"
      "  1:4: The left side of the = operation "
      "must be a valid variable name",
    );
  });

  test('{{x.y=2}} should result in an error', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{x.y=2}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('{{ERROR}}');
    renderResult.errorMessage.should.be(
      "Render error in: '{{x.y=2}}':\n"
      "  1:6: The left side of the = operation "
      "must be a name of a root variable (not contain dots)",
    );
  });
}
