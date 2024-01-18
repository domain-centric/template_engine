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
      var parseResult = parser.parse(input);
      var expected = 'MapEntry(parameter: PrefixExpression{-})';

      then(
          'result should be of type Success',
          () => parseResult.should
              .beOfType<Success<MapEntry<String, Expression<Object>>>>());
      then('result.value should be: $expected',
          () => parseResult.value.toString().should.be(expected));
    });

    input = ' true';
    when('calling parser.parse("$input")', () {
      var parseResult = parser.parse(input);
      var expected = MapEntry('parameter', Value(true)).toString();

      then(
          'result should be of type Success',
          () => parseResult.should
              .beOfType<Success<MapEntry<String, Expression<Object>>>>());
      then('result.value should be: $expected',
          () => parseResult.value.toString().should.be(expected));
    });

    input = ' FALse';
    when('calling parser.parse("$input")', () {
      var parseResult = parser.parse(input);
      var expected = MapEntry('parameter', Value(false)).toString();

      then(
          'result should be of type Success',
          () => parseResult.should
              .beOfType<Success<MapEntry<String, Expression<Object>>>>());
      then('result.value should be: $expected',
          () => parseResult.value.toString().should.be(expected));
    });

    input = '  "Hello"';
    when('calling parser.parse("$input")', () {
      var parseResult = parser.parse(input);

      then(
          'result should not be of type Success',
          () => parseResult.should
              .beOfType<Success<MapEntry<String, Expression<Object>>>>());

      var expected = MapEntry('parameter', Value('Hello')).toString();
      then('result.value should be: $expected',
          () => parseResult.value.toString().should.be(expected));
    });

    input = "  'Hello'   ";
    when('calling parser.parse("$input")', () {
      var parseResult = parser.parse(input);
      var expected = MapEntry('parameter', Value('Hello')).toString();

      then(
          'result should be of type Success',
          () => parseResult.should
              .beOfType<Success<MapEntry<String, Expression<Object>>>>());
      then('result.value should be: $expected',
          () => parseResult.value.toString().should.be(expected));
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
      var parseResult = parser.parse(input);
      var expected = 'MapEntry(parameter: PrefixExpression{-})';
      then('result.value should be: $expected',
          () => parseResult.value.toString().should.be(expected));
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
      var parseResult = parser.parse(input);
      var expected = MapEntry('parameter', Value(true)).toString();

      then(
          'result should be of type Success',
          () => parseResult.should
              .beOfType<Success<MapEntry<String, Expression<Object>>>>());
      then('result.value should be: $expected',
          () => parseResult.value.toString().should.be(expected));
    });

    input = ' parameter  =FALse';
    when('calling parser.parse("$input")', () {
      var parseResult = parser.parse(input);
      var expected = MapEntry('parameter', Value(false)).toString();

      then(
          'result should be of type Success',
          () => parseResult.should
              .beOfType<Success<MapEntry<String, Expression<Object>>>>());
      then('result.value should be: $expected',
          () => parseResult.value.toString().should.be(expected));
    });

    input = ' PARAmeter=   "Hello"';
    when('calling parser.parse("$input")', () {
      var parseResult = parser.parse(input);

      then('result should be of type Failure',
          () => parseResult.should.beOfType<Failure>());

      var expected = '"parameter" expected';
      then('result.value should be: $expected',
          () => parseResult.message.should.be(expected));
    });

    input = " parameter  =   'Hello'   ";
    when('calling parser.parse("$input")', () {
      var parseResult = parser.parse(input);
      var expected = MapEntry('parameter', Value('Hello')).toString();

      then(
          'result should be of type Success',
          () => parseResult.should
              .beOfType<Success<MapEntry<String, Expression<Object>>>>());
      then('result.value should be: $expected',
          () => parseResult.value.toString().should.be(expected));
    });

    input = " bogus=bogus";
    when('calling parser.parse("$input")', () {
      var parseResult = parser.parse(input);
      var expected = '"parameter" expected';

      then('result should be of type Failure',
          () => parseResult.should.beOfType<Failure>());
      then('result.message should be: $expected',
          () => parseResult.message.should.be(expected));
    });

    input = " parameter";
    when('calling parser.parse("$input")', () {
      var parseResult = parser.parse(input);
      var expected = '"=" expected';

      then('result should be of type Failure',
          () => parseResult.should.beOfType<Failure>());
      then('result.message should be: $expected',
          () => parseResult.message.should.be(expected));
    });
  });

  given('an TemplateEngine with a GreetingTag', () {
    var engine = TemplateEngine();
    engine.functionGroups
        .add(FunctionGroup('Greeting', [GreetingWithParameterFunction()]));

    var input1 = '{{greeting()}}.';
    when('calling: await engine.parseText("$input1"))', () {
      then('result.errorMessage should be empty', () async {
        var parseResult = await engine.parseText(input1);
        parseResult.errorMessage.should.beNullOrEmpty();
      });
      then('result should contain 2 nodes', () async {
        var parseResult = await engine.parseText(input1);
        var templateParseResult = parseResult.children.first;
        templateParseResult.children.length.should.be(2);
      });

      then('result 1st node : "Function{greeting}"', () async {
        var parseResult = await engine.parseText(input1);
        var templateParseResult = parseResult.children.first;
        templateParseResult.children[0]
            .toString()
            .should
            .be('Function{greeting}');
      });

      then('result 2nd node : "."', () async {
        var result = await engine.parseText(input1);
        var templateParseResult = result.children.first;
        templateParseResult.children[1].should.be('.');
      });

      then('await engine.render(result).text should be "Hello world."',
          () async {
        var parseResult = await engine.parseText(input1);
        var renderResult = await engine.render(parseResult);
        renderResult.text.should.be("Hello world.");
      });
    });

    var input2 = '{{greeting("Jane Doe") }}.';
    when('calling: await engine.parseText("$input2"))', () {
      then('result.errorMessage should be empty', () async {
        var parseResult = await engine.parseText(input2);
        parseResult.errorMessage.should.beNullOrEmpty();
      });
      then('result should contain 2 node', () async {
        var parseResult = await engine.parseText(input2);
        var templateParseResult = parseResult.children.first;
        templateParseResult.children.length.should.be(2);
      });

      then('result 1st node : Function{greeting}', () async {
        var parseResult = await engine.parseText(input2);
        var templateParseResult = parseResult.children.first;
        templateParseResult.children[0]
            .toString()
            .should
            .be('Function{greeting}');
      });
      then('result 2nd node : "."', () async {
        var parseResult = await engine.parseText(input2);
        var templateParseResult = parseResult.children.first;
        templateParseResult.children[1].should.be('.');
      });
      then('result should be: "Hello Jane Doe."', () async {
        var parseResult = await engine.parseText(input2);
        var renderResult = await engine.render(parseResult);
        renderResult.text.should.be("Hello Jane Doe.");
      });
    });

    var inputTag1 = '{{greeting("Jane Doe", invalidParameter=invalidValue)}}';
    var input3 = '$inputTag1.';
    when('calling: await engine.parseText("$input3"))', () {
      String expected =
          'Parse error in: \'{{greeting("Jane Doe", invalidParameter=...\':\n'
          '  1:22: invalid function parameter syntax: '
          ', invalidParameter=invalidValue';
      then('result.errorMessage should be "$expected"', () async {
        var parseResult = await engine.parseText(input3);
        parseResult.errorMessage.should.be(expected);
      });

      then('result 1st node : must be a FunctionExpression', () async {
        var parseResult = await engine.parseText(input1);
        var templateParseResult = parseResult.children.first;
        templateParseResult.children[0].should.beOfType<FunctionExpression>();
      });
      then('result 2nd node : "."', () async {
        var parseResult = await engine.parseText(input1);
        var templateParseResult = parseResult.children.first;
        templateParseResult.children[1].should.be('.');
      });
    });

    var inputTag2 =
        '{{greeting name= "Jane Doe" invalidParameter"invalidValue" }}';
    var input4 = '$inputTag2.';
    when('calling: await engine.parseText("$input4"))', () {
      String expected =
          'Parse error in: \'{{greeting name= "Jane Doe" invalidParam...\':\n'
          '  1:12: invalid tag syntax';
      then('result.errorMessage should be "$expected"', () async {
        var parseResult = await engine.parseText(input4);
        parseResult.errorMessage.should.be(expected);
      });

      then('result 1st node should be of type FunctionExpression', () async {
        var parseResult = await engine.parseText(input2);
        var templateParseResult = parseResult.children.first;
        templateParseResult.children[0].should.beOfType<FunctionExpression>();
      });
      then('result 2nd node : "."', () async {
        var parseResult = await engine.parseText(input2);
        var templateParseResult = parseResult.children.first;
        templateParseResult.children[1].should.be('.');
      });
    });
  });

  given('a TemplateEngine with an ParameterTestFunction and one parameter', () {
    var parameterName = 'testParameter';
    var parameterTestFunction =
        ParameterTestFunction([Parameter(name: parameterName)]);
    var engine = TemplateEngine();
    engine.functionGroups.add(FunctionGroup('Test', [parameterTestFunction]));

    var input5 = '{{123true}}';
    when('calling await engine.parseText("$input5")', () {
      var expected = 'Parse error in: \'{{123true}}\':\n'
          '  1:6: invalid tag syntax';
      then('result.errorMessage should be: "$expected"', () async {
        var result = await engine.parseText(input5);
        result.errorMessage.should.be(expected);
      });
    });

    var input6 = '{{${ParameterTestFunction.tagName}(-123e-1)}}';
    when('calling await engine.parseText("$input6")', () {
      then('parserResult.errorMessage should be empty', () async {
        var parserResult = await engine.parseText(input6);
        parserResult.errorMessage.should.beNullOrEmpty();
      });
      then('parserResult should have 1 node', () async {
        var parserResult = await engine.parseText(input6);
        parserResult.children.length.should.be(1);
      });
      when('calling: await engine.render(parserResult)', () {
        var expected = {parameterName: -12.3};

        then('renderResult.text should be: "$expected"', () async {
          var parserResult = await engine.parseText(input6);
          var renderResult = await engine.render(parserResult);
          renderResult.text.should.be(expected.toString());
        });
      });
    });

    var input7 = '{{${ParameterTestFunction.tagName}(true)}}';
    when('calling await engine.parseText("$input7")', () {
      then('parseResult.errorMessage should be empty', () async {
        var parseResult = await engine.parseText(input7);
        parseResult.errorMessage.should.beNullOrEmpty();
      });
      then('parseResult should have 1 node', () async {
        var parseResult = await engine.parseText(input7);
        parseResult.children.length.should.be(1);
      });

      when('calling: await engine.render(parseResult)', () {
        var expected = {parameterName: true};
        then('result first node should be: "$expected"', () async {
          var parseResult = await engine.parseText(input7);
          var renderResult = await engine.render(parseResult);
          renderResult.text.should.be(expected.toString());
        });
      });
    });

    var input8 = '{{${ParameterTestFunction.tagName} (FALse)}}';
    when('calling: await engine.parseText("$input8"))', () {
      then('parseResult.errorMessage should be empty', () async {
        var parseResult = await engine.parseText(input8);
        parseResult.errorMessage.should.beNullOrEmpty();
      });
      then('parseResult should have 1 node', () async {
        var parseResult = await engine.parseText(input8);
        parseResult.children.length.should.be(1);
      });

      when('calling: ', () {
        var expected = {parameterName: false};
        then('renderResult.text should be: "$expected"', () async {
          var parseResult = await engine.parseText(input8);
          var renderResult = await engine.render(parseResult);
          renderResult.text.should.be(expected.toString());
        });
      });
    });

    var input9 = '{{${ParameterTestFunction.tagName}("Hello")}}';
    when('calling: await engine.parseText("$input9"))', () {
      then('parseResult.errorMessage should be empty', () async {
        var parseResult = await engine.parseText(input9);
        parseResult.errorMessage.should.beNullOrEmpty();
      });
      then('parseResult should have 1 node', () async {
        var parseResult = await engine.parseText(input9);
        parseResult.children.length.should.be(1);
      });

      var expected = {parameterName: 'Hello'};
      then('renderResult.text should be: "$expected"', () async {
        var parseResult = await engine.parseText(input9);
        var renderResult = await engine.render(parseResult);
        renderResult.text.should.be(expected.toString());
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

    var input10 = '{{${ParameterTestFunction.tagName}'
        '($parameterName1=true$parameterName2="$test")}}';
    when('calling await engine.parseText("$input10")', () {
      var expected =
          'Parse error in: \'{{test(parameter1=trueparameter2="Test")...\':\n'
          '  1:23: invalid function parameter syntax: '
          'parameter2="Test"';
      then('result.errorMessage should be: "$expected"', () async {
        var result = await engine.parseText(input10);
        result.errorMessage.should.be(expected);
      });
    });

    var input11 = '{{${ParameterTestFunction.tagName} '
        '($parameterName1=true, $parameterName3="$test")}}';
    when('calling await engine.parseText("$input11")', () {
      var expected =
          'Parse error in: \'{{test (parameter1=true, parameter3="Tes...\':\n'
          '  1:43: missing mandatory function parameter: parameter2';
      then('result.errorMessage should be: "$expected"', () async {
        var result = await engine.parseText(input11);
        result.errorMessage.should.be(expected);
      });
    });

    var input12 =
        '{{${ParameterTestFunction.tagName} ( $parameterName3="$test" )}}';
    when('calling await engine.parseText("$input12")', () {
      var expected = 'Parse error in: \'{{test ( parameter3="Test" )}}\':\n'
          '  1:28: missing mandatory function parameters: '
          'parameter1, parameter2';
      then('result.errorMessage should be: "$expected"', () async {
        var result = await engine.parseText(input12);
        result.errorMessage.should.be(expected);
      });
    });

    var input12b = '{{${ParameterTestFunction.tagName}'
        '($parameterName2="$test" ,$parameterName1=false)}}';
    when('calling await engine.parseText("$input12b")', () {
      var expected =
          'Parse error in: \'{{test(parameter2="Test" ,parameter1=fal...\':\n'
          '  1:43: missing mandatory function parameter: parameter3';
      then('result.errorMessage should be: "$expected"', () async {
        var result = await engine.parseText(input12b);
        result.errorMessage.should.be(expected);
      });
    });

    var input13 = '{{${ParameterTestFunction.tagName}  '
        '($parameterName3=-123e-1, $parameterName1=false )  }}';
    when('calling await engine.parseText("$input13")', () {
      var expected =
          'Parse error in: \'{{test  (parameter3=-123e-1, parameter1=...\':\n'
          '  1:47: missing mandatory function parameter: parameter2';
      then('result.errorMessage should be: "$expected"', () async {
        var parseResult = await engine.parseText(input13);
        parseResult.errorMessage.should.be(expected);
      });
    });

    var input14 = '{{${ParameterTestFunction.tagName}( $parameterName3=-123e-1,'
        '$parameterName2="$test",   $parameterName1=false    )  }}';
    when('calling await engine.parseText("$input14")', () {
      var expected = {
        parameterName3: -12.3,
        parameterName2: test,
        parameterName1: false,
      };

      then('parseResult.errorMessage should be empty', () async {
        var parseResult = await engine.parseText(input14);
        parseResult.errorMessage.should.beNullOrEmpty();
      });
      then('parseResult should have 1 node', () async {
        var parseResult = await engine.parseText(input14);
        parseResult.children.length.should.be(1);
      });
      when('calling: await engine.render(parseResult)', () {
        then('renderResult first node should be: "$expected"', () async {
          var parseResult = await engine.parseText(input14);
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

    var input15 = '{{${ParameterTestFunction.tagName} '
        '$parameterName1=true$parameterName2="$test"}}';
    when('calling await engine.parseText("$input15")', () {
      var expected =
          'Parse error in: \'{{test parameter1=trueparameter2="Test"}...\':\n'
          '  1:8: invalid tag syntax';
      then('result.errorMessage should be: "$expected"', () async {
        var parseResult = await engine.parseText(input15);
        parseResult.errorMessage.should.be(expected);
      });
    });

    var input16 = '{{${ParameterTestFunction.tagName}'
        '( $parameterName1=true, $parameterName3="$test")}}';
    when('calling await engine.parseText("$input16")', () {
      var expected =
          'Parse error in: \'{{test( parameter1=true, parameter3="Tes...\':\n'
          '  1:43: missing mandatory function parameter: parameter4';
      then('result.errorMessage should be: "$expected"', () async {
        var parseResult = await engine.parseText(input16);
        parseResult.errorMessage.should.be(expected);
      });
    });

    var input17 = '{{${ParameterTestFunction.tagName}($parameterName2="$test",'
        '$parameterName1=false)}}';
    when('calling await engine.parseText("$input17")', () {
      var expected =
          'Parse error in: \'{{test(parameter2="Test",parameter1=fals...\':\n'
          '  1:42: missing mandatory function parameters: '
          'parameter3, parameter4';
      then('result.errorMessage should be: "$expected"', () async {
        var parseResult = await engine.parseText(input17);
        parseResult.errorMessage.should.be(expected);
      });
    });

    var input18 =
        '{{${ParameterTestFunction.tagName} ( $parameterName3=-123e-1 ,'
        '$parameterName1=false   )}}';
    when('calling await engine.parseText("$input18")', () {
      var expected =
          'Parse error in: \'{{test ( parameter3=-123e-1 ,parameter1=...\':\n'
          '  1:49: missing mandatory function parameter: parameter4';
      then('result.errorMessage should be: "$expected"', () async {
        var parseResult = await engine.parseText(input18);
        parseResult.errorMessage.should.be(expected);
      });
    });

    var input19 = '{{${ParameterTestFunction.tagName}($parameterName3=-123e-1,'
        '$parameterName1=true,$parameterName4="$test")}}';
    when('calling await engine.parseText("$input19")', () {
      var expected = {
        parameterName3: -12.3,
        parameterName1: true,
        parameterName4: test,
      };

      then('parseResult.errorMessage should be empty', () async {
        var parseResult = await engine.parseText(input19);
        parseResult.errorMessage.should.beNullOrEmpty();
      });
      then('parseResult should have 1 node', () async {
        var parseResult = await engine.parseText(input19);
        parseResult.children.length.should.be(1);
      });
      when('calling: await engine.render(parseResult)', () {
        then('renderResult.text should be: "$expected"', () async {
          var parseResult = await engine.parseText(input19);
          var renderResult = await engine.render(parseResult);
          renderResult.text.should.be(expected.toString());
        });
      });
    });

    var input20 = '{{${ParameterTestFunction.tagName}($parameterName3=-123e-1 ,'
        '   $parameterName2=true    ,$parameterName4="$test" ) }}';
    when('calling await engine.parseText("$input20")', () {
      var expected = {
        parameterName3: -12.3,
        parameterName2: true,
        parameterName4: test,
        parameterName1: false,
      };

      then('parseResult.errorMessage should should be empty', () async {
        var parseResult = await engine.parseText(input20);
        parseResult.errorMessage.should.beNullOrEmpty();
      });
      then('parseResult should have 1 node', () async {
        var parseResult = await engine.parseText(input20);
        parseResult.children.length.should.be(1);
      });
      when('calling: await engine.render(parseResult)', () {
        then('renderResult.text should be: "$expected"', () async {
          var parseResult = await engine.parseText(input20);
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
    var input21 = '{{length("Hello" + " " & "world.") + 3}}';
    when('calling await engine.parseText("$input21")', () {
      when('calling: await engine.render(parseResult).text', () {
        var expected = (('Hello world.'.length) + 3).toString();
        then('result should be: $expected', () async {
          var parseResult = await engine.parseText(input21);
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
    var input22 = '{{sin(asin(0.5))}}';
    when('calling await engine.parseText("$input22")', () {
      when('calling: await engine.render(parseResult).text', () {
        var expected = '0.5';
        then('result should be: $expected', () async {
          var parseResult = await engine.parseText(input22);
          var renderResult = await engine.render(parseResult);
          renderResult.text.should.be(expected);
        });
      });
    });
  });
  given('A function with a missing parameter', () {
    var engine = TemplateEngine();
    var input23 = '{{sin()}}';
    when('calling await engine.parseText("$input23")', () {
      var expected = 'Parse error in: \'{{sin()}}\':\n'
          '  1:7: missing mandatory function parameter: radians';
      then('parseResult.errors.first.message should be "$expected"', () async {
        var parseResult = await engine.parseText(input23);
        parseResult.errorMessage.should.be(expected);
      });
      when('calling: await engine.render(parseResult).text', () {
        then('renderResult.text should be: "{{sin()}}"', () async {
          var parseResult = await engine.parseText(input23);
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
