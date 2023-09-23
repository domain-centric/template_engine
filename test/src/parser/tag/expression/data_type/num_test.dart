import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{0}} should be rendered as 0', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(TextTemplate('{{0}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('0');
  });

  test('{{-42}} should be rendered as -42', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(TextTemplate('{{-42}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('-42');
  });

  test('{{3.141}} should be rendered as 3.141', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(TextTemplate('{{3.141}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('3.141');
  });

  test('{{-1.2e5}} should be rendered as -120000.0', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(TextTemplate('{{-1.2e5}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('-120000.0');
  });

  test('{{-1.2e-5}} should be rendered as -0.000012', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(TextTemplate('{{-1.2e-5}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('-0.000012');
  });
}
