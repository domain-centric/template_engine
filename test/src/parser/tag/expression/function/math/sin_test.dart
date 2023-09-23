import 'dart:math';

import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{sin(7)}} should render as: ${sin(7).toString()}', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(TextTemplate('{{sin(7)}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be(sin(7).toString());
  });
}
