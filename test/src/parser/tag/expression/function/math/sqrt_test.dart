import 'dart:math';

import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{sqrt(9)}} should render as: ${sqrt(7).toString()}', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{sqrt(9)}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be(sqrt(9).toString());
  });
}
