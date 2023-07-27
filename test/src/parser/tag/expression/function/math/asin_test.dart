import 'dart:math';

import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{asin(0.5)}} should render as: ${asin(0.5).toString()}', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(const TextTemplate('{{asin(0.5)}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be(asin(0.5).toString());
  });
}
