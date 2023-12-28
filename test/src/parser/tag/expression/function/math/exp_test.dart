import 'dart:math';

import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{exp(7)}} should render as: ${exp(7).toString()}', () async {
    var engine = TemplateEngine();
    var parseResult = engine.parseTemplate(TextTemplate('{{exp(7)}}'));
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be(exp(7).toString());
  });
}
