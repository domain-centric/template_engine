import 'dart:math';

import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{cos(7)}} should render as: ${cos(7).toString()}', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseTemplate(TextTemplate('{{cos(7)}}'));
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be(cos(7).toString());
  });
}
