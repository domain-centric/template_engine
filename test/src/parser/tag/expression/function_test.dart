import 'dart:math';

import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  given('expressionParser(ParserContext())', () {
    var delta = 0.00001;
    var context = RenderContext();
    when('calling: parser.parse("exp(7)").value.render(context) as num', () {
      var parse = expressionParser(ParserContext()).parse("exp(7)");
      var result = parse.value.render(context) as num;

      var expected = exp(7);
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });

    when('calling: parser.parse("log(7)").value.render(context) as num', () {
      var result = expressionParser(ParserContext())
          .parse("log(7)")
          .value
          .render(context) as num;
      var expected = log(7);
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });

    when('calling: parser.parse("sin(7)").value.render(context)) as num', () {
      var result = expressionParser(ParserContext())
          .parse("sin(7)")
          .value
          .render(context) as num;
      var expected = sin(7);
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });

    when('calling: parser.parse("asin(0.5)").value.render(context)) as num',
        () {
      var result = expressionParser(ParserContext())
          .parse("asin(0.5)")
          .value
          .render(context) as num;
      var expected = asin(0.5);
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });

    when('calling: parser.parse("cos(7)").value.render(context)) as num', () {
      var result = expressionParser(ParserContext())
          .parse("cos(7)")
          .value
          .render(context) as num;
      var expected = cos(7);
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });

    when('calling: parser.parse("acos(0.5)").value.render(context)) as num',
        () {
      var result = expressionParser(ParserContext())
          .parse("acos(0.5)")
          .value
          .render(context) as num;
      var expected = acos(0.5);
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });

    when('calling: parser.parse("tan(7)").value.render(context)) as num', () {
      var result = expressionParser(ParserContext())
          .parse("tan(7)")
          .value
          .render(context) as num;
      var expected = tan(7);
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });

    when('calling: parser.parse("atan(0.5)").value.render(context)) as num',
        () {
      var result = expressionParser(ParserContext())
          .parse("atan(0.5)")
          .value
          .render(context) as num;
      var expected = atan(0.5);
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });

    when('calling: parser.parse("sqrt(2)").value.render(context)) as num', () {
      var result = expressionParser(ParserContext())
          .parse("sqrt(2)")
          .value
          .render(context) as num;
      var expected = sqrt(2);
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });
  });

  given('TemplateEngine() and a custom function', () {
    var functions = DefaultFunctions();
    functions.add(GreetingWithParameter());
    var engine = TemplateEngine(tags: DefaultTags(functions: functions));
    when(
        "calling: engine.parse(TextTemplate('{{greeting()}}.'), "
        "functions: functions)", () {
      var parseResult = engine.parse(TextTemplate('{{greeting()}}.'));
      when('calling: engine.render(parseResult).text', () {
        var renderResult = engine.render(parseResult).text;
        var expected = 'Hello world.';
        then('result should be: $expected',
            () => renderResult.should.be(expected));
      });
    });

    when(
        "calling: engine.parse(TextTemplate({{greeting(\"Jane Doe\")}}.), "
        "functions: functions)", () {
      var parseResult = engine.parse(TextTemplate('{{greeting("Jane Doe")}}.'));

      when('calling: engine.render(parseResult).text', () {
        var renderResult = engine.render(parseResult).text;
        var expected = 'Hello Jane Doe.';
        then('result should be: $expected',
            () => renderResult.should.be(expected));
      });
    });
  });

  given(
      'A function with a parameter that contains operators '
      '(needs to be rendered first)', () {
    var engine = TemplateEngine();
    when(
        "calling: engine.parse(TextTemplate"
        "('{{length(\"Hello\" + \" \" & \"world.\") + 3}}')) ", () {
      var parseResult = engine
          .parse(TextTemplate('{{length("Hello" + " " & "world.") + 3}}'));
      when('calling: engine.render(parseResult).text', () {
        var renderResult = engine.render(parseResult).text;
        var expected = (('Hello world.'.length) + 3).toString();
        then('result should be: $expected',
            () => renderResult.should.be(expected));
      });
    });
  });

  given(
      'A function with a parameter that contains a function '
      '(needs to be rendered first)', () {
    var engine = TemplateEngine();
    when("calling: engine.parse(TextTemplate('{{sin(asin(0.5))}}'))", () {
      var parseResult = engine.parse(TextTemplate('{{sin(asin(0.5))}}'));
      when('calling: engine.render(parseResult).text', () {
        var renderResult = engine.render(parseResult).text;
        var expected = '0.5';
        then('result should be: $expected',
            () => renderResult.should.be(expected));
      });
    });
  });
  given('A function with a missing parameter', () {
    var engine = TemplateEngine();
    when("calling: engine.parse(TextTemplate('{{sin()}}'))", () {
      var parseResult = engine.parse(TextTemplate('{{sin()}}'));
      when('calling: engine.render(parseResult).text', () {
        var renderResult = engine.render(parseResult);
        then('parseResult.errors.length should be 1',
            () => parseResult.errors.length.should.be(1));
        then(
            'parseResult.errors.first.message should be "Parse Error: '
            'Missing mandatory parameter: value position: 1:7 source: Text"',
            () => parseResult.errors.first.message.should
                .be("Parse Error: Missing mandatory parameter: "
                    "value position: 1:7 source: Text"));
        then('renderResult.text should be: "{{sin()}}"',
            () => renderResult.text.should.be('{{sin()}}'));
      });
    });
  });
}

class GreetingWithParameter extends TagFunction {
  GreetingWithParameter()
      : super(
          name: 'greeting',
          description: 'A tag that shows a greeting using attribute: name',
          parameters: [
            Parameter(
                name: "name",
                presence: Presence.optionalWithDefaultValue('world'))
          ],
          function: (parameters) => 'Hello ${parameters['name']}',
        );
}
