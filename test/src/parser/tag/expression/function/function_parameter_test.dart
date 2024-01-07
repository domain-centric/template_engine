import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:petitparser/petitparser.dart';
import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  given('Parameter', () {
    when('Calling constructor', () {
      then('Should throw a ParameterException with a valid error message', () {
        Should.throwException<ParameterException>(
                () => Parameter(name: 'inv@lid'))!
            .message
            .should
            .be('Invalid parameter name: "inv@lid", '
                'letter OR digit expected at position 3');
      });
    });
  });

  given('ParameterNameAndValueParser with a nameless parameter', () {
    var parserContext = ParserContext(TemplateEngine(), TextTemplate(''));
    var loopBackParser = SettableParser(expressionParser(parserContext));
    var parser = parameterParser(
            parserContext: parserContext,
            parameter: Parameter(name: 'parameter'),
            loopbackParser: loopBackParser,
            withName: false)
        .end();

    var input = '-123e-1';
    when('calling parser.parse("$input")', () {
      var result = parser.parse(input);
      var expected = 'MapEntry(parameter: PrefixExpression{-})';

      then('result.value should be: $expected',
          () => result.value.toString().should.be(expected));
    });

    input = ' -123e-1';
    when('calling parser.parse("$input")', () {
      var result = parser.parse(input);
      var expected = 'MapEntry(parameter: PrefixExpression{-})';

      then(
          'result should be of type Success',
          () => result.should
              .beOfType<Success<MapEntry<String, Expression<Object>>>>());
      then('result.value should be: $expected',
          () => result.value.toString().should.be(expected));
    });

    input = ' true';
    when('calling parser.parse("$input")', () {
      var result = parser.parse(input);
      var expected = MapEntry('parameter', Value(true)).toString();

      then(
          'result should be of type Success',
          () => result.should
              .beOfType<Success<MapEntry<String, Expression<Object>>>>());
      then('result.value should be: $expected',
          () => result.value.toString().should.be(expected));
    });

    input = ' FALse';
    when('calling parser.parse("$input")', () {
      var result = parser.parse(input);
      var expected = MapEntry('parameter', Value(false)).toString();

      then(
          'result should be of type Success',
          () => result.should
              .beOfType<Success<MapEntry<String, Expression<Object>>>>());
      then('result.value should be: $expected',
          () => result.value.toString().should.be(expected));
    });

    input = '  "Hello"';
    when('calling parser.parse("$input")', () {
      var result = parser.parse(input);

      then(
          'result should not be of type Success',
          () => result.should
              .beOfType<Success<MapEntry<String, Expression<Object>>>>());

      var expected = MapEntry('parameter', Value('Hello')).toString();
      then('result.value should be: $expected',
          () => result.value.toString().should.be(expected));
    });

    input = "  'Hello'   ";
    when('calling parser.parse("$input")', () {
      var result = parser.parse(input);
      var expected = MapEntry('parameter', Value('Hello')).toString();

      then(
          'result should be of type Success',
          () => result.should
              .beOfType<Success<MapEntry<String, Expression<Object>>>>());
      then('result.value should be: $expected',
          () => result.value.toString().should.be(expected));
    });
  });

  given('ParameterNameAndValueParser with parameter: parameter', () {
    var parserContext = ParserContext(TemplateEngine(), TextTemplate(''));
    var loopBackParser = SettableParser(expressionParser(parserContext));
    var parser = parameterParser(
            parserContext: parserContext,
            parameter: Parameter(name: 'parameter'),
            loopbackParser: loopBackParser,
            withName: true)
        .end();

    var input = 'parameter=-123e-1';
    when('calling parser.parse("$input")', () {
      var result = parser.parse(input);
      var expected = 'MapEntry(parameter: PrefixExpression{-})';
      then('result.value should be: $expected',
          () => result.value.toString().should.be(expected));
    });

    input = ' parameter =  -123e-1';
    when('calling parser.parse("$input")', () {
      var result = parser.parse(input);
      var expected = 'MapEntry(parameter: PrefixExpression{-})';

      then(
          'result should be of type Success',
          () => result.should
              .beOfType<Success<MapEntry<String, Expression<Object>>>>());
      then('result.value should be: $expected',
          () => result.value.toString().should.be(expected));
    });

    input = '  parameter=true';
    when('calling parser.parse("$input")', () {
      var result = parser.parse(input);
      var expected = MapEntry('parameter', Value(true)).toString();

      then(
          'result should be of type Success',
          () => result.should
              .beOfType<Success<MapEntry<String, Expression<Object>>>>());
      then('result.value should be: $expected',
          () => result.value.toString().should.be(expected));
    });

    input = ' parameter  =FALse';
    when('calling parser.parse("$input")', () {
      var result = parser.parse(input);
      var expected = MapEntry('parameter', Value(false)).toString();

      then(
          'result should be of type Success',
          () => result.should
              .beOfType<Success<MapEntry<String, Expression<Object>>>>());
      then('result.value should be: $expected',
          () => result.value.toString().should.be(expected));
    });

    input = ' PARAmeter=   "Hello"';
    when('calling parser.parse("$input")', () {
      var result = parser.parse(input);

      then('result should be of type Failure',
          () => result.should.beOfType<Failure>());

      var expected = '"parameter" expected';
      then('result.value should be: $expected',
          () => result.message.should.be(expected));
    });

    input = " parameter  =   'Hello'   ";
    when('calling parser.parse("$input")', () {
      var result = parser.parse(input);
      var expected = MapEntry('parameter', Value('Hello')).toString();

      then(
          'result should be of type Success',
          () => result.should
              .beOfType<Success<MapEntry<String, Expression<Object>>>>());
      then('result.value should be: $expected',
          () => result.value.toString().should.be(expected));
    });

    input = " bogus=bogus";
    when('calling parser.parse("$input")', () {
      var result = parser.parse(input);
      var expected = '"parameter" expected';

      then('result should be of type Failure',
          () => result.should.beOfType<Failure>());
      then('result.message should be: $expected',
          () => result.message.should.be(expected));
    });

    input = " parameter";
    when('calling parser.parse("$input")', () {
      var result = parser.parse(input);
      var expected = '"=" expected';

      then('result should be of type Failure',
          () => result.should.beOfType<Failure>());
      then('result.message should be: $expected',
          () => result.message.should.be(expected));
    });
  });

  given('an TemplateEngine with a GreetingTag', () {
    var engine = TemplateEngine();
    engine.functionGroups
        .add(FunctionGroup('Greeting', [GreetingWithParameterFunction()]));

    var input = '{{greeting()}}.';
    when('calling: engine.parse(TextTemplate("$input"))', () {
      var result = engine.parseTemplate(TextTemplate(input));
      var templateParseResult = result.children.first;

      then('result.errorMessage should be empty',
          () => result.errorMessage.should.beNullOrEmpty());
      then('result should contain 2 nodes',
          () => templateParseResult.children.length.should.be(2));

      then(
          'result 1st node : "Function{greeting}"',
          () => templateParseResult.children[0]
              .toString()
              .should
              .be('Function{greeting}'));

      then('result 2nd node : "."',
          () => templateParseResult.children[1].should.be('.'));

      then('await engine.render(result).text should be "Hello world."',
          () async {
        var renderResult = await engine.render(result);
        renderResult.text.should.be("Hello world.");
      });
    });

    input = '{{greeting("Jane Doe") }}.';
    when('calling: engine.parse(TextTemplate("$input"))', () {
      var result = engine.parseTemplate(TextTemplate(input));
      var templateParseResult = result.children.first;

      then('result.errorMessage should be empty',
          () => result.errorMessage.should.beNullOrEmpty());
      then('result should contain 2 node',
          () => templateParseResult.children.length.should.be(2));

      then(
          'result 1st node : Function{greeting}',
          () => templateParseResult.children[0]
              .toString()
              .should
              .be('Function{greeting}'));
      then('result 2nd node : "."',
          () => templateParseResult.children[1].should.be('.'));
      then('', () async {
        var renderResult = await engine.render(result);
        renderResult.text.should.be("Hello Jane Doe.");
      });
    });

    var inputTag1 = '{{greeting("Jane Doe", invalidParameter=invalidValue)}}';
    var input1 = '$inputTag1.';
    when('calling: engine.parse(TextTemplate("$input1"))', () {
      var parseResult = engine.parseTemplate(TextTemplate(input1));
      var templateParseResult = parseResult.children.first;
      String expected =
          'Parse error in: \'{{greeting("Jane Doe", invalidParameter=...\':\n'
          '  1:22: invalid function parameter syntax: '
          ', invalidParameter=invalidValue';
      then('result.errorMessage should be "$expected"',
          () => parseResult.errorMessage.should.be(expected));

      then('result 1st node : "$inputTag1"',
          () => templateParseResult.children[0].should.be(inputTag1));
      then('result 2nd node : "."',
          () => templateParseResult.children[1].should.be('.'));
    });

    var inputTag2 =
        '{{greeting name= "Jane Doe" invalidParameter"invalidValue" }}';
    var input2 = '$inputTag2.';
    when('calling: engine.parse(TextTemplate("$input2"))', () {
      var parseResult = engine.parseTemplate(TextTemplate(input2));
      var templateParseResult = parseResult.children.first;

      String expected =
          'Parse error in: \'{{greeting name= "Jane Doe" invalidParam...\':\n'
          '  1:12: invalid tag syntax';
      then('result.errorMessage should be "$expected"',
          () => parseResult.errorMessage.should.be(expected));

      then('result 1st node : "$inputTag2"',
          () => templateParseResult.children[0].should.be(inputTag2));
      then('result 2nd node : "."',
          () => templateParseResult.children[1].should.be('.'));
    });
  });

  given('a TemplateEngine with an ParameterTestFunction and one parameter', () {
    var parameterName = 'testParameter';
    var parameterTestFunction =
        ParameterTestFunction([Parameter(name: parameterName)]);
    var engine = TemplateEngine();
    engine.functionGroups.add(FunctionGroup('Test', [parameterTestFunction]));

    var input = '{{123true}}';
    when('calling engine.parse(TextTemplate("$input"))', () {
      var result = engine.parseTemplate(TextTemplate(input));

      var expected = 'Parse error in: \'{{123true}}\':\n'
          '  1:6: invalid tag syntax';
      then('result.errorMessage should be: "$expected"',
          () => result.errorMessage.should.be(expected));
    });

    input = '{{${ParameterTestFunction.tagName}(-123e-1)}}';
    when('calling engine.parse(TextTemplate("$input"))', () {
      var parserResult = engine.parseTemplate(TextTemplate(input));

      then('parserResult.errorMessage should be empty',
          () => parserResult.errorMessage.should.beNullOrEmpty());
      then('parserResult should have 1 node',
          () => parserResult.children.length.should.be(1));
      when('calling: await engine.render(parserResult)', () {
        var expected = {parameterName: -12.3};

        then('renderResult.text should be: "$expected"', () async {
          var renderResult = await engine.render(parserResult);
          renderResult.text.should.be(expected.toString());
        });
      });
    });

    input = '{{${ParameterTestFunction.tagName}(true)}}';
    when('calling engine.parse(TextTemplate("$input"))', () {
      var parseResult = engine.parseTemplate(TextTemplate(input));

      then('parseResult.errorMessage should be empty',
          () => parseResult.errorMessage.should.beNullOrEmpty());
      then('parseResult should have 1 node',
          () => parseResult.children.length.should.be(1));

      when('calling: await engine.render(parseResult)', () {
        var expected = {parameterName: true};
        then('result first node should be: "$expected"', () async {
          var renderResult = await engine.render(parseResult);
          renderResult.text.should.be(expected.toString());
        });
      });
    });

    input = '{{${ParameterTestFunction.tagName} (FALse)}}';
    when('calling: engine.parse(TextTemplate("$input"))', () {
      var parseResult = engine.parseTemplate(TextTemplate(input));

      then('parseResult.errorMessage should be empty',
          () => parseResult.errorMessage.should.beNullOrEmpty());
      then('parseResult should have 1 node',
          () => parseResult.children.length.should.be(1));

      when('calling: ', () {
        var expected = {parameterName: false};
        then('renderResult.text should be: "$expected"', () async {
          var renderResult = await engine.render(parseResult);
          renderResult.text.should.be(expected.toString());
        });
      });
    });

    input = '{{${ParameterTestFunction.tagName}("Hello")}}';
    when('calling engine.parse(TextTemplate("$input"))', () {
      var parseResult = engine.parseTemplate(TextTemplate(input));

      then('parseResult.errorMessage should be empty',
          () => parseResult.errorMessage.should.beNullOrEmpty());
      then('parseResult should have 1 node',
          () => parseResult.children.length.should.be(1));

      when('', () {
        var expected = {parameterName: 'Hello'};
        then('renderResult.text should be: "$expected"', () async {
          var renderResult = await engine.render(parseResult);
          renderResult.text.should.be(expected.toString());
        });
      });
    });
  });

  given(
      'a TemplateEngine with an ParameterTestFunction and multiple parameters',
      () {
    var parameterName1 = 'parameter1';
    var parameterName2 = 'parameter2';
    var parameterName3 = 'parameter3';
    var test = "Test";
    var testFunction = ParameterTestFunction([
      Parameter(name: parameterName1),
      Parameter(name: parameterName2),
      Parameter(name: parameterName3),
    ]);

    var engine = TemplateEngine();
    engine.functionGroups.add(FunctionGroup('Test', [testFunction]));

    var input = '{{${ParameterTestFunction.tagName}'
        '($parameterName1=true$parameterName2="$test")}}';
    when('calling engine.parse(TextTemplate("$input"))', () {
      var result = engine.parseTemplate(TextTemplate(input));

      var expected =
          'Parse error in: \'{{test(parameter1=trueparameter2="Test")...\':\n'
          '  1:23: invalid function parameter syntax: '
          'parameter2="Test"';
      then('result.errorMessage should be: "$expected"',
          () => result.errorMessage.should.be(expected));
    });

    input = '{{${ParameterTestFunction.tagName} '
        '($parameterName1=true, $parameterName3="$test")}}';
    when('calling engine.parse(TextTemplate("$input"))', () {
      var result = engine.parseTemplate(TextTemplate(input));

      var expected =
          'Parse error in: \'{{test (parameter1=true, parameter3="Tes...\':\n'
          '  1:43: missing mandatory function parameter: parameter2';
      then('result.errorMessage should be: "$expected"',
          () => result.errorMessage.should.be(expected));
    });

    input = '{{${ParameterTestFunction.tagName} ( $parameterName3="$test" )}}';
    when('calling engine.parse(TextTemplate("$input"))', () {
      var result = engine.parseTemplate(TextTemplate(input));

      var expected = 'Parse error in: \'{{test ( parameter3="Test" )}}\':\n'
          '  1:28: missing mandatory function parameters: '
          'parameter1, parameter2';
      then('result.errorMessage should be: "$expected"',
          () => result.errorMessage.should.be(expected));
    });
    input = '{{${ParameterTestFunction.tagName}'
        '($parameterName2="$test" ,$parameterName1=false)}}';
    when('calling engine.parse(TextTemplate("$input"))', () {
      var result = engine.parseTemplate(TextTemplate(input));

      var expected =
          'Parse error in: \'{{test(parameter2="Test" ,parameter1=fal...\':\n'
          '  1:43: missing mandatory function parameter: parameter3';
      then('result.errorMessage should be: "$expected"',
          () => result.errorMessage.should.be(expected));
    });

    input = '{{${ParameterTestFunction.tagName}  '
        '($parameterName3=-123e-1, $parameterName1=false )  }}';
    when('calling engine.parse(TextTemplate("$input"))', () {
      var result = engine.parseTemplate(TextTemplate(input));

      var expected =
          'Parse error in: \'{{test  (parameter3=-123e-1, parameter1=...\':\n'
          '  1:47: missing mandatory function parameter: parameter2';
      then('result.errorMessage should be: "$expected"',
          () => result.errorMessage.should.be(expected));
    });

    input = '{{${ParameterTestFunction.tagName}( $parameterName3=-123e-1,'
        '$parameterName2="$test",   $parameterName1=false    )  }}';
    when('calling engine.parse(TextTemplate("$input"))', () {
      var parseResult = engine.parseTemplate(TextTemplate(input));
      var expected = {
        parameterName3: -12.3,
        parameterName2: test,
        parameterName1: false,
      };

      then('parseResult.errorMessage should be empty',
          () => parseResult.errorMessage.should.beNullOrEmpty());
      then('parseResult should have 1 node',
          () => parseResult.children.length.should.be(1));
      when('calling: await engine.render(parseResult)', () {
        then('renderResult first node should be: "$expected"', () async {
          var renderResult = await engine.render(parseResult);
          renderResult.text.should.be(expected.toString());
        });
      });
    });
  });

  given(
      'a TemplateEngine with an ParameterTestFunction and multiple parameters',
      () {
    var parameterName1 = 'parameter1';
    var parameterName2 = 'parameter2';
    var parameterName3 = 'parameter3';
    var parameterName4 = 'parameter4';
    var test = "Test";
    var testFunction = ParameterTestFunction([
      Parameter(
          name: parameterName1,
          presence: Presence.optionalWithDefaultValue(false)),
      Parameter(name: parameterName2, presence: Presence.optional()),
      Parameter(name: parameterName3),
      Parameter(name: parameterName4),
    ]);

    var engine = TemplateEngine();
    engine.functionGroups.add(FunctionGroup('Test', [testFunction]));

    var input = '{{${ParameterTestFunction.tagName} '
        '$parameterName1=true$parameterName2="$test"}}';
    when('calling engine.parse(TextTemplate("$input"))', () {
      var result = engine.parseTemplate(TextTemplate(input));

      var expected =
          'Parse error in: \'{{test parameter1=trueparameter2="Test"}...\':\n'
          '  1:8: invalid tag syntax';
      then('result.errorMessage should be: "$expected"',
          () => result.errorMessage.should.be(expected));
    });

    input = '{{${ParameterTestFunction.tagName}'
        '( $parameterName1=true, $parameterName3="$test")}}';
    when('calling engine.parse(TextTemplate("$input"))', () {
      var result = engine.parseTemplate(TextTemplate(input));

      var expected =
          'Parse error in: \'{{test( parameter1=true, parameter3="Tes...\':\n'
          '  1:43: missing mandatory function parameter: parameter4';
      then('result.errorMessage should be: "$expected"',
          () => result.errorMessage.should.be(expected));
    });

    input = '{{${ParameterTestFunction.tagName}($parameterName2="$test",'
        '$parameterName1=false)}}';
    when('calling engine.parse(TextTemplate("$input"))', () {
      var result = engine.parseTemplate(TextTemplate(input));

      var expected =
          'Parse error in: \'{{test(parameter2="Test",parameter1=fals...\':\n'
          '  1:42: missing mandatory function parameters: '
          'parameter3, parameter4';
      then('result.errorMessage should be: "$expected"',
          () => result.errorMessage.should.be(expected));
    });

    input = '{{${ParameterTestFunction.tagName} ( $parameterName3=-123e-1 ,'
        '$parameterName1=false   )}}';
    when('calling engine.parse(TextTemplate("$input"))', () {
      var result = engine.parseTemplate(TextTemplate(input));

      var expected =
          'Parse error in: \'{{test ( parameter3=-123e-1 ,parameter1=...\':\n'
          '  1:49: missing mandatory function parameter: parameter4';
      then('result.errorMessage should be: "$expected"',
          () => result.errorMessage.should.be(expected));
    });

    input = '{{${ParameterTestFunction.tagName}($parameterName3=-123e-1,'
        '$parameterName1=true,$parameterName4="$test")}}';
    when('calling engine.parse(TextTemplate("$input"))', () {
      var parseResult = engine.parseTemplate(TextTemplate(input));
      var expected = {
        parameterName3: -12.3,
        parameterName1: true,
        parameterName4: test,
      };

      then('parseResult.errorMessage should be empty',
          () => parseResult.errorMessage.should.beNullOrEmpty());
      then('parseResult should have 1 node',
          () => parseResult.children.length.should.be(1));
      when('calling: await engine.render(parseResult)', () {
        then('renderResult.text should be: "$expected"', () async {
          var renderResult = await engine.render(parseResult);
          renderResult.text.should.be(expected.toString());
        });
      });
    });

    input = '{{${ParameterTestFunction.tagName}($parameterName3=-123e-1 ,'
        '   $parameterName2=true    ,$parameterName4="$test" ) }}';
    when('calling engine.parse(TextTemplate("$input"))', () {
      var parseResult = engine.parseTemplate(TextTemplate(input));
      var expected = {
        parameterName3: -12.3,
        parameterName2: true,
        parameterName4: test,
        parameterName1: false,
      };

      then('parseResult.errorMessage should should be empty',
          () => parseResult.errorMessage.should.beNullOrEmpty());
      then('parseResult should have 1 node',
          () => parseResult.children.length.should.be(1));
      when('calling: await engine.render(parseResult)', () {
        then('renderResult.text should be: "$expected"', () async {
          var renderResult = await engine.render(parseResult);
          renderResult.text.should.be(expected.toString());
        });
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
      var parseResult = engine.parseTemplate(
          TextTemplate('{{length("Hello" + " " & "world.") + 3}}'));
      when('calling: await engine.render(parseResult).text', () {
        var expected = (('Hello world.'.length) + 3).toString();
        then('result should be: $expected', () async {
          var renderResult = await engine.render(parseResult);
          renderResult.text.should.be(expected);
        });
      });
    });
  });

  given(
      'A function with a parameter that contains a function '
      '(needs to be rendered first)', () {
    var engine = TemplateEngine();
    when("calling: engine.parse(TextTemplate('{{sin(asin(0.5))}}'))", () {
      var parseResult =
          engine.parseTemplate(TextTemplate('{{sin(asin(0.5))}}'));
      when('calling: await engine.render(parseResult).text', () {
        var expected = '0.5';
        then('result should be: $expected', () async {
          var renderResult = await engine.render(parseResult);
          renderResult.text.should.be(expected);
        });
      });
    });
  });
  given('A function with a missing parameter', () {
    var engine = TemplateEngine();
    when("calling: engine.parse(TextTemplate('{{sin()}}'))", () {
      var parseResult = engine.parseTemplate(TextTemplate('{{sin()}}'));
      var expected = 'Parse error in: \'{{sin()}}\':\n'
          '  1:7: missing mandatory function parameter: radians';
      then('parseResult.errors.first.message should be "$expected"',
          () => parseResult.errorMessage.should.be(expected));
      when('calling: await engine.render(parseResult).text', () {
        then('renderResult.text should be: "{{sin()}}"', () async {
          var renderResult = await engine.render(parseResult);
          renderResult.text.should.be('{{sin()}}');
        });
      });
    });
  });
}

class GreetingWithParameterFunction extends ExpressionFunction {
  GreetingWithParameterFunction()
      : super(
            name: 'greeting',
            description: 'A tag that shows a greeting',
            exampleExpression: 'greeting()',
            exampleResult: 'Hello world',
            parameters: [
              Parameter(
                name: 'name',
                presence: Presence.optionalWithDefaultValue('world'),
              )
            ],
            function: (position, renderContext, parameters) =>
                Future.value('Hello ${parameters['name']}'));
}

class ParameterTestFunction extends ExpressionFunction<Map<String, Object>> {
  static const tagName = 'test';

  ParameterTestFunction(List<Parameter> parameters)
      : super(
            name: tagName,
            description: 'A tag for testing',
            exampleExpression: 'dummy',
            exampleResult: 'dummy',
            parameters: parameters,
            function: (position, renderContext, parameters) =>
                Future.value(parameters));
}
