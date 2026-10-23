import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{0}} should be rendered as 0', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{0}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('0');
  });

  test('{{-42}} should be rendered as -42', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{-42}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('-42');
  });

  test('{{3.141}} should be rendered as 3.141', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{3.141}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('3.141');
  });

  test('{{-1.2e5}} should be rendered as -120000.0', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{-1.2e5}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('-120000.0');
  });

  test('{{-1.2e+3}} should be rendered as -1200.0', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{-1.2e3}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('-1200.0');
  });

  test('{{-1.2e-5}} should be rendered as -0.000012', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{-1.2e-5}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('-0.000012');
  });

  test('{{0x1f}} should be rendered as 31', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{0x1f}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('31');
  });

  test('{{0xfF}} should be rendered as 255', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{0xfF}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('255');
  });

  test('{{-0xFF}} should be rendered as -255', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{-0xFF}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('-255');
  });
}
