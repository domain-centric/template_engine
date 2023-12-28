import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{x}} should render variable x', () async {
    var engine = TemplateEngine();
    var parseResult = engine.parseTemplate(TextTemplate('{{x}}'));
    var renderResult = await engine.render(parseResult, {'x': 42});
    renderResult.text.should.be('42');
  });

  test('{{x / y}} should render variable x divided by variable y', () async {
    var engine = TemplateEngine();
    var parseResult = engine.parseTemplate(TextTemplate('{{x / y}}'));
    var renderResult = await engine.render(parseResult, {'x': 6, 'y': 2});
    renderResult.text.should.be('3.0');
  });

  test('"Hello {{name}}." should render a proper greeting', () async {
    var engine = TemplateEngine();
    var parseResult = engine.parseTemplate(TextTemplate('Hello {{name}}.'));
    var renderResult = await engine.render(parseResult, {'name': 'world'});
    renderResult.text.should.be('Hello world.');
  });
}
