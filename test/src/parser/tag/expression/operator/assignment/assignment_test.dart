import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{x=12}} should return ""', () {
    var engine = TemplateEngine();
    var parseResult = engine.parseTemplate(TextTemplate('{{x=12}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('');
  });

  test('{{x=12}}{{x}} should return 12', () {
    var engine = TemplateEngine();
    var parseResult = engine.parseTemplate(TextTemplate('{{x=12}}{{x}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('12');
  });

  test('{{ x =  12   }}{{  x }} should return 12', () {
    var engine = TemplateEngine();
    var parseResult = engine.parseTemplate(TextTemplate('{{ x =  12   }}{{  x }}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('12');
  });

  test('{{x=12}}{{x+3}} should return 15', () {
    var engine = TemplateEngine();
    var parseResult = engine.parseTemplate(TextTemplate('{{x=12}}{{x+3}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('15');
  });

  test('{{x=2}}{{x=x+3}}{{x}} should return 5', () {
    var engine = TemplateEngine();
    var parseResult = engine.parseTemplate(TextTemplate('{{x=2}}{{x=x+3}}{{x}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('5');
  });

}
