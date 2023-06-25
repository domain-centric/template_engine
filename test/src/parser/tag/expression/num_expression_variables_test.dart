import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  given('expressionParser', () {
    var parser = numExpressionParser;
    double delta = 0.00001;
    when('calling: parser.parse("x").value.eval({"x": 42})', () {
      var result = parser.parse("x").value.eval({"x": 42});
      var expected = 42;
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });

    when('calling: parser.parse("x / y").value.eval({"x": 1, "y": 2})', () {
      var result = parser.parse("x / y").value.eval({"x": 1, "y": 2});
      var expected = 0.5;
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });
  });
}
