import 'dart:math';

import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{acos(0.5)}} should render as: ${acos(0.5).toString()}', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(const TextTemplate('{{acos(0.5)}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be(acos(0.5).toString());
  });
}
