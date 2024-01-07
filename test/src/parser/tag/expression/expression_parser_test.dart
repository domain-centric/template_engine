import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  given('expressionParser(ParserContext()).end()', () {
    var engine = TemplateEngine();
    var template = TextTemplate('');
    var parser = expressionParser(ParserContext(engine, template)); //.end();
    var context = RenderContext(
        engine: engine, templateBeingRendered: template, parsedTemplates: []);
    when('calling parser.parse("\'Hello\'")', () {
      var parseResult = parser.parse("'Hello'");
      then('result.value should be an Expression<String>', () {
        parseResult.value.should.beAssignableTo<Expression<String>>();
      });
      then('result.value.render(context) should be "Hello"', () async {
        var text = await parseResult.value.render(context);
        text.should.be('Hello');
      });
    });

    when('calling parser.parse("123.45")', () {
      var parseResult = parser.parse("123.45");

      then('result.value should be an Expression<num>', () async {
        var value = await parseResult.value.render(context);
        value.should.beAssignableTo<double>();
      });
      then('result.value.render(context) should be 123.45', () async {
        var value = await parseResult.value.render(context);
        (value as num).should.beCloseTo(123.45, delta: 0.001);
      });
    });

    when('calling parser.parse("length(\'Hello\')")', () {
      var result = parser.parse("length('Hello')");
      then('result.value should be an Expression', () {
        result.value.should.beAssignableTo<Expression>();
      });
      then('result.value.render(context) should be 5', () async {
        (await result.value.render(context) as num).should.be(5);
      });
    });

    when('calling parser.parse("length(\'Hello\')+3")', () {
      var result = parser.parse("length('Hello')+3");
      then('result.value should be an Expression', () {
        result.value.should.beAssignableTo<Expression>();
      });
      then('result.value.render(context) should be 8', () async {
        (await result.value.render(context) as num).should.be(8);
      });
    });
  });
}
