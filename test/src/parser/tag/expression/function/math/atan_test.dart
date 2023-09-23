import 'dart:math';

import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{atan(0.5)}} should render as: ${atan(0.5).toString()}', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(TextTemplate('{{atan(0.5)}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be(atan(0.5).toString());
  });
}
