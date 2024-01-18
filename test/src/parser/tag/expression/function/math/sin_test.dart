import 'dart:math';

import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{sin(7)}} should render as: ${sin(7).toString()}', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{sin(7)}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be(sin(7).toString());
  });
}
