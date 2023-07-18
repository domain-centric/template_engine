import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  given('expressionParser(ParserContext())', () {
    var parser = expressionParser(ParserContext(engine: TemplateEngine()));
    var context = RenderContext();

    when('calling parser.parse("length(\'Hello\')")', () {
      var result = parser.parse("length('Hello')");
      then('result.value should be an Expression', () {
        result.value.should.beAssignableTo<Expression>();
      });
      then('result.value.render(context) should be 5', () {
        (result.value.render(context) as num).should.be(5);
      });
    });

    when('calling parser.parse("length(\'Hello\' + " world")")', () {
      var result = parser.parse("length('Hello' + \" world\")");
      then('result.value should be an Expression', () {
        result.value.should.beAssignableTo<Expression>();
      });
      then('result.value.render(context) should be 11', () {
        (result.value.render(context) as num).should.be(11);
      });
    });
  });
}
