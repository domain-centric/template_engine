import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  given('expressionParser()', () {
    var parser = expressionParser();
    when('calling: parser.parse("x").value.eval({"x": 42})', () {
      var result = parser.parse("x").value.eval({"x": 42});
      var expected = 42;
      then('result should be: $expected', () => result.should.be(expected));
    });

    when('calling: parser.parse("x / y").value.eval({"x": 6, "y": 2})', () {
      var result = parser.parse("x / y").value.eval({"x": 6, "y": 2});
      var expected = 3;
      then('result should be: $expected', () => result.should.be(expected));
    });

    //TODO add tests like tag_variable_test.dart
  });
}
