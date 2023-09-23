import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{x}} should render variable x', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(TextTemplate('{{x}}'));
    var renderResult = engine.render(parseResult, {'x': 42});
    renderResult.text.should.be('42');
  });

  test('{{x / y}} should render variable x divided by variable y', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(TextTemplate('{{x / y}}'));
    var renderResult = engine.render(parseResult, {'x': 6, 'y': 2});
    renderResult.text.should.be('3.0');
  });

  test('"Hello {{name}}." should render a proper greeting', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(TextTemplate('Hello {{name}}.'));
    var renderResult = engine.render(parseResult, {'name': 'world'});
    renderResult.text.should.be('Hello world.');
  });
}
