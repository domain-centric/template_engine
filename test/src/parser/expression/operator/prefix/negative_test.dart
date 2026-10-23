import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';
import 'dart:math';

void main() {
  test('{{-3}} should render: -3', () async {
    final engine = TemplateEngine();
    final parseResult = await engine.parseText('{{-3}}');
    final renderResult = await engine.render(parseResult);
    renderResult.text.should.be('-3');
  });
  test('{{-pi}} should render: -$pi', () async {
    final engine = TemplateEngine();
    final parseResult = await engine.parseText('{{-pi}}');
    final renderResult = await engine.render(parseResult);
    renderResult.text.should.be('-$pi');
  });

  test('{{-"text"}} should result in an error', () async {
    final engine = TemplateEngine();
    final parseResult = await engine.parseText('{{-"text"}}');
    final renderResult = await engine.render(parseResult);
    Should.satisfyAllConditions([
      () => renderResult.text.should.be('{{ERROR}}'),
      () => renderResult.errors.should.haveCount(1),
      () => renderResult.errors.first.message.should.be(
        "number expected after the - operator",
      ),
      () =>
          renderResult.errors.first.location.should.be(TemplateLocation(1, 3)),
    ]);
  });
}
