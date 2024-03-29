import 'dart:math';

import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{e}} should render: $e', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseTemplate(TextTemplate('{{e}}'));
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be(e.toString());
  });
}
