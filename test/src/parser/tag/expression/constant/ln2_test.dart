import 'dart:math';

import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{ln2}} should render: $ln2', () async {
    var engine = TemplateEngine();
    var parseResult = engine.parseTemplate(TextTemplate('{{ln2}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be(ln2.toString());
  });
}
