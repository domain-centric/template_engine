import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  given('expressionParser(ParserContext()).end()', () {
    var parser = expressionParser(ParserContext()); //.end();
    var context = RenderContext();
    when('calling parser.parse("\'Hello\'")', () {
      var result = parser.parse("'Hello'");
      then('result.value should be an Expression<String>', () {
        result.value.should.beAssignableTo<Expression<String>>();
      });
      then('result.value.render(context) should be "Hello"', () {
        result.value.render(context).should.be('Hello');
      });
    });

    when('calling parser.parse("123.45")', () {
      var result = parser.parse("123.45");
      then('result.value should be an Expression<num>', () {
        result.value.should.beAssignableTo<Expression<num>>();
      });
      then('result.value.render(context) should be 123.45', () {
        (result.value.render(context) as num)
            .should
            .beCloseTo(123.45, delta: 0.001);
      });
    });

    when('calling parser.parse("length(\'Hello\')")', () {
      var result = parser.parse("length('Hello')");
      then('result.value should be an Expression', () {
        result.value.should.beAssignableTo<Expression>();
      });
      then('result.value.render(context) should be 5', () {
        (result.value.render(context) as num).should.be(5);
      });
    });

    when('calling parser.parse("length(\'Hello\')+3")', () {
      var result = parser.parse("length('Hello')+3");
      then('result.value should be an Expression', () {
        result.value.should.beAssignableTo<Expression>();
      });
      then('result.value.render(context) should be 8', () {
        (result.value.render(context) as num).should.be(8);
      });
    });
  });
}
