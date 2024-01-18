import 'dart:math';

import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{tan(7)}} should render as: ${tan(7).toString()}', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{tan(7)}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be(tan(7).toString());
  });
}
