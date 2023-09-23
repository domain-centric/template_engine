import 'dart:math';

import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{log10e}} should render: $log10e', () async {
    var engine = TemplateEngine();
    var parseResult = engine.parse(TextTemplate('{{log10e}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be(log10e.toString());
  });
}
