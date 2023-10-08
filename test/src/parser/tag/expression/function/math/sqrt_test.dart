import 'dart:math';

import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{sqrt(9)}} should render as: ${sqrt(7).toString()}', () {
    var engine = TemplateEngine();
    var parseResult = engine.parseTemplate(TextTemplate('{{sqrt(9)}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be(sqrt(9).toString());
  });
}
