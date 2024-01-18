import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';
import 'dart:math';

void main() {
  test('{{-3}} should render: -3', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{-3}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('-3');
  });
  test('{{-pi}} should render: -$pi', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{-pi}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('-$pi');
  });

  test('{{-"text"}} should result in an error', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{-"text"}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('{{ERROR}}');
    renderResult.errorMessage.should.be('Render error in: \'{{-"text"}}\':\n'
        '  1:3: number expected after the - operator');
  });
}
