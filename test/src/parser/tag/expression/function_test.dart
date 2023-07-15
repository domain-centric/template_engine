import 'dart:math';

import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  given('expressionParser(ParserContext())', () {
    var parser = expressionParser(ParserContext(engine: TemplateEngine()));
    var delta = 0.00001;
    var context = RenderContext();
    when('calling: parser.parse("exp(7)").value.render(context) as num', () {
      var parseResult = parser.parse("exp(7)");
      var result = parseResult.value.render(context) as num;

      var expected = exp(7);
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });

    when('calling: parser.parse("log(7)").value.render(context) as num', () {
      var result = parser.parse("log(7)").value.render(context) as num;
      var expected = log(7);
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });

    when('calling: parser.parse("sin(7)").value.render(context)) as num', () {
      var result = parser.parse("sin(7)").value.render(context) as num;
      var expected = sin(7);
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });

    when('calling: parser.parse("asin(0.5)").value.render(context)) as num',
        () {
      var result = parser.parse("asin(0.5)").value.render(context) as num;
      var expected = asin(0.5);
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });

    when('calling: parser.parse("cos(7)").value.render(context)) as num', () {
      var result = parser.parse("cos(7)").value.render(context) as num;
      var expected = cos(7);
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });

    when('calling: parser.parse("acos(0.5)").value.render(context)) as num',
        () {
      var result = parser.parse("acos(0.5)").value.render(context) as num;
      var expected = acos(0.5);
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });

    when('calling: parser.parse("tan(7)").value.render(context)) as num', () {
      var result = parser.parse("tan(7)").value.render(context) as num;
      var expected = tan(7);
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });

    when('calling: parser.parse("atan(0.5)").value.render(context)) as num',
        () {
      var result = parser.parse("atan(0.5)").value.render(context) as num;
      var expected = atan(0.5);
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });

    when('calling: parser.parse("sqrt(2)").value.render(context)) as num', () {
      var result = parser.parse("sqrt(2)").value.render(context) as num;
      var expected = sqrt(2);
      then('result should be: $expected',
          () => result.should.beCloseTo(expected, delta: delta));
    });
  });

  given('TemplateEngine() and a custom function', () {
    var engine = TemplateEngine();
    engine.functions.add(GreetingWithParameter());
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
      then('parseResult.errors.length should be 1',
          () => parseResult.errors.length.should.be(1));
      var expected = 'Parse Error: missing mandatory function parameter: '
          'value, position: 1:7, source: Text';
      then('parseResult.errors.first.message should be "$expected"',
          () => parseResult.errors.first.toString().should.be(expected));
      when('calling: engine.render(parseResult).text', () {
        var renderResult = engine.render(parseResult);

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
