import 'dart:math';

import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  given('expressionParser(ParserContext())', () {
    var engine = TemplateEngine();
    var parser = expressionParser(ParserContext(engine));
    double delta = 0.00001;
    var context = RenderContext(engine);
    when('calling: parser.parse("-pi").value.render(context) as num', () {
      var result = parser.parse("-pi").value.render(context) as num;
      var expected = -pi;
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });
  });
}
