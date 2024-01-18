import 'dart:math';

import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{log2e}} should render: $log2e', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseTemplate(TextTemplate('{{log2e}}'));
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be(log2e.toString());
  });
}
