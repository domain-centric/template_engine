import 'dart:math';

import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{pi}} should render: $pi', () async {
    var engine = TemplateEngine();
    var parseResult = engine.parse(const TextTemplate('{{pi}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be(pi.toString());
  });
}
