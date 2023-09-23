import 'dart:math';

import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{tan(7)}} should render as: ${tan(7).toString()}', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(TextTemplate('{{tan(7)}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be(tan(7).toString());
  });
}
