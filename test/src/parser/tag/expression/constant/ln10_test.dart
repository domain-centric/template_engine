import 'dart:math';

import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{ln10}} should render: $ln10', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseTemplate(TextTemplate('{{ln10}}'));
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be(ln10.toString());
  });
}
