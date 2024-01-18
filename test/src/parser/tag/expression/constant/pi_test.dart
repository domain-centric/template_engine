import 'dart:math';

import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{pi}} should render: $pi', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseTemplate(TextTemplate('{{pi}}'));
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be(pi.toString());
  });
}
