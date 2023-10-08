import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';
import 'dart:math';

void main() {
  test('{{-3}} should render: -3', () {
    var engine = TemplateEngine();
    var parseResult = engine.parseTemplate(TextTemplate('{{-3}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('-3');
  });
  test('{{-pi}} should render: -$pi', () {
    var engine = TemplateEngine();
    var parseResult = engine.parseTemplate(TextTemplate('{{-pi}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('-$pi');
  });

  test('{{-"text"}} should result in an error', () {
    var engine = TemplateEngine();
    var parseResult = engine.parseTemplate(TextTemplate('{{-"text"}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('{{ERROR}}');
    renderResult.errorMessage.should.be('Render error in: \'{{-"text"}}\':\n'
        '  1:3: number expected after the - operator');
  });
}
