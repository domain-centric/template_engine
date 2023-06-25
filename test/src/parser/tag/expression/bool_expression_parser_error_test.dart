import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  given('boolExpressionParser()', () {
    var parser = boolExpressionParser();

    when('calling: parser.parse("tru")', () {
      var result = parser.parse("tru");

      then('result.isFailure should be true',
          () => result.isFailure.should.beTrue());

      var expected = 'boolean expected';
      then('result.message should be: $expected',
          () => result.message.should.be(expected));
    });

    when('calling: parser.parse("  f@lse")', () {
      var result = parser.parse(" f@lse");

      then('result.isFailure should be true',
          () => result.isFailure.should.beTrue());

      var expected = 'boolean expected';
      then('result.message should be: $expected',
          () => result.message.should.be(expected));
    });
  });
}
