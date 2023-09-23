import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{false^false}} should render: false', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(TextTemplate('{{false^false}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('false');
  });
  test('{{false^true}} should render: true', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(TextTemplate('{{false^true}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('true');
  });
  test('{{true^false}} should render: true', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(TextTemplate('{{true^false}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('true');
  });
  test('{{true^true}} should render: false', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(TextTemplate('{{true^true}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('false');
  });
}
