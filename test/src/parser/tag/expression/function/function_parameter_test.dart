import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:petitparser/petitparser.dart';
import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';

import '../../../../template_engine_test.dart';

void main() {
  given('Parameter', () {
    when('Calling constructor', () {
      then('Should throw a ParameterException with a valid error message', () {
        Should.throwException<ParameterException>(
                () => Parameter(name: 'inv@lid'))!
            .message
            .should
            .be('Parameter name: "inv@lid" is invalid: end of input expected at position: 3');
      });
    });
  });

  given('ParameterNameAndValueParser with a nameless parameter', () {
    var parserContext = ParserContext(TemplateEngine());
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
      var expected = MapEntry(
              'parameter', NegativeNumberExpression(DummySource(), Value(12.3)))
          .toString();

      then('result.value should be: $expected',
          () => result.value.toString().should.be(expected));
    });

    input = ' -123e-1';
    when('calling parser.parse("$input")', () {
      var result = parser.parse(input);
      var expected = MapEntry(
              'parameter', NegativeNumberExpression(DummySource(), Value(12.3)))
          .toString();

      then('result should have no failures',
          () => result.isFailure.should.beFalse());
      then('result.value should be: $expected',
          () => result.value.toString().should.be(expected));
    });

    input = ' true';
    when('calling parser.parse("$input")', () {
      var result = parser.parse(input);
      var expected = MapEntry('parameter', Value(true)).toString();

      then('result should have no failures',
          () => result.isFailure.should.beFalse());
      then('result.value should be: $expected',
          () => result.value.toString().should.be(expected));
    });

    input = ' FALse';
    when('calling parser.parse("$input")', () {
      var result = parser.parse(input);
      var expected = MapEntry('parameter', Value(false)).toString();

      then('result should have no failures',
          () => result.isFailure.should.beFalse());
      then('result.value should be: $expected',
          () => result.value.toString().should.be(expected));
    });

    input = '  "Hello"';
    when('calling parser.parse("$input")', () {
      var result = parser.parse(input);

      then('result should not be a failure',
          () => result.isFailure.should.beFalse());

      var expected = MapEntry('parameter', Value('Hello')).toString();
      then('result.value should be: $expected',
          () => result.value.toString().should.be(expected));
    });

    input = "  'Hello'   ";
    when('calling parser.parse("$input")', () {
      var result = parser.parse(input);
      var expected = MapEntry('parameter', Value('Hello')).toString();

      then('result should have no failures',
          () => result.isFailure.should.beFalse());
      then('result.value should be: $expected',
          () => result.value.toString().should.be(expected));
    });
  });

  given('ParameterNameAndValueParser with parameter: parameter', () {
    var parserContext = ParserContext(TemplateEngine());
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
      var expected = MapEntry(
              'parameter', NegativeNumberExpression(DummySource(), Value(12.3)))
          .toString();

      then('result.value should be: $expected',
          () => result.value.toString().should.be(expected));
    });

    input = ' parameter =  -123e-1';
    when('calling parser.parse("$input")', () {
      var result = parser.parse(input);
      var expected = MapEntry(
              'parameter', NegativeNumberExpression(DummySource(), Value(12.3)))
          .toString();

      then('result should have no failures',
          () => result.isFailure.should.beFalse());
      then('result.value should be: $expected',
          () => result.value.toString().should.be(expected));
    });

    input = '  parameter=true';
    when('calling parser.parse("$input")', () {
      var result = parser.parse(input);
      var expected = MapEntry('parameter', Value(true)).toString();

      then('result should have no failures',
          () => result.isFailure.should.beFalse());
      then('result.value should be: $expected',
          () => result.value.toString().should.be(expected));
    });

    input = ' parameter  =FALse';
    when('calling parser.parse("$input")', () {
      var result = parser.parse(input);
      var expected = MapEntry('parameter', Value(false)).toString();

      then('result should have no failures',
          () => result.isFailure.should.beFalse());
      then('result.value should be: $expected',
          () => result.value.toString().should.be(expected));
    });

    input = ' PARAmeter=   "Hello"';
    when('calling parser.parse("$input")', () {
      var result = parser.parse(input);

      then(
          'result should be a failure', () => result.isFailure.should.beTrue());

      var expected = '"parameter" expected';
      then('result.value should be: $expected',
          () => result.message.should.be(expected));
    });

    input = " parameter  =   'Hello'   ";
    when('calling parser.parse("$input")', () {
      var result = parser.parse(input);
      var expected = MapEntry('parameter', Value('Hello')).toString();

      then('result should have no failures',
          () => result.isFailure.should.beFalse());
      then('result.value should be: $expected',
          () => result.value.toString().should.be(expected));
    });

    input = " bogus=bogus";
    when('calling parser.parse("$input")', () {
      var result = parser.parse(input);
      var expected = '"parameter" expected';

      then('result should have failures',
          () => result.isFailure.should.beTrue());
      then('result.message should be: $expected',
          () => result.message.should.be(expected));
    });

    input = " parameter";
    when('calling parser.parse("$input")', () {
      var result = parser.parse(input);
      var expected = '"=" expected';

      then('result should have failures',
          () => result.isFailure.should.beTrue());
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
      var result = engine.parse(TextTemplate(input));

      then('result.errors should be empty',
          () => result.errors.should.beEmpty());
      then('result should contain 2 nodes',
          () => result.nodes.length.should.be(2));

      then('result 1st node : "Function{greeting}"',
          () => result.nodes[0].toString().should.be('Function{greeting}'));

      then('result 2nd node : "."', () => result.nodes[1].should.be('.'));

      then('engine.render(result).text should be "Hello world."', () {
        engine.render(result).text.should.be("Hello world.");
      });
    });

    input = '{{greeting("Jane Doe") }}.';
    when('calling: engine.parse(TextTemplate("$input"))', () {
      var result = engine.parse(TextTemplate(input));

      then('result.errors should be empty',
          () => result.errors.should.beEmpty());
      then('result should contain 2 node',
          () => result.nodes.length.should.be(2));

      then('result 1st node : Function{greeting}',
          () => result.nodes[0].toString().should.be('Function{greeting}'));
      then('result 2nd node : "."', () => result.nodes[1].should.be('.'));
      then('', () => engine.render(result).text.should.be("Hello Jane Doe."));
    });

    var inputTag1 = '{{greeting("Jane Doe", invalidParameter=invalidValue)}}';
    var input1 = '$inputTag1.';
    when('calling: engine.parse(TextTemplate("$input1"))', () {
      var parseResult = engine.parse(TextTemplate(input1));

      then('result.errors should contain 1 error',
          () => parseResult.errors.length.should.be(1));
      String expected = 'Parse Error: invalid function parameter syntax: '
          ', invalidParameter=invalidValue, position: 1:22, source: Text';
      then('result.errorMessage should be "$expected"',
          () => parseResult.errorMessage.should.be(expected));

      then('result 1st node : "$inputTag1"',
          () => parseResult.nodes[0].should.be(inputTag1));
      then('result 2nd node : "."', () => parseResult.nodes[1].should.be('.'));
    });

    var inputTag2 =
        '{{greeting name= "Jane Doe" invalidParameter"invalidValue" }}';
    var input2 = '$inputTag2.';
    when('calling: engine.parse(TextTemplate("$input2"))', () {
      var parseResult = engine.parse(TextTemplate(input2));

      then('result.errors should contain 1 error',
          () => parseResult.errors.length.should.be(1));

      String expected = 'Parse Error: invalid tag syntax, '
          'position: 1:12, source: Text';
      then('result.errorMessage should be "$expected"',
          () => parseResult.errorMessage.should.be(expected));

      then('result 1st node : "$inputTag2"',
          () => parseResult.nodes[0].should.be(inputTag2));
      then('result 2nd node : "."', () => parseResult.nodes[1].should.be('.'));
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
      var result = engine.parse(TextTemplate(input));
      then('result should have 1 error',
          () => result.errors.length.should.be(1));

      var expected = 'Parse Error: invalid tag syntax, '
          'position: 1:6, source: Text';
      then('result.errorMessage should be: "$expected"',
          () => result.errorMessage.should.be(expected));
    });

    input = '{{${ParameterTestFunction.tagName}(-123e-1)}}';
    when('calling engine.parse(TextTemplate("$input"))', () {
      var parserResult = engine.parse(TextTemplate(input));

      then('parserResult should have no errors',
          () => parserResult.errors.should.beEmpty());
      then('parserResult should have 1 node',
          () => parserResult.nodes.length.should.be(1));
      when('calling: engine.render(parserResult)', () {
        var renderResult = engine.render(parserResult);
        var expected = {parameterName: -12.3};

        then('renderResult.text should be: "$expected"',
            () => renderResult.text.should.be(expected.toString()));
      });
    });

    input = '{{${ParameterTestFunction.tagName}(true)}}';
    when('calling engine.parse(TextTemplate("$input"))', () {
      var parseResult = engine.parse(TextTemplate(input));

      then('parseResult should have no errors',
          () => parseResult.errors.should.beEmpty());
      then('parseResult should have 1 node',
          () => parseResult.nodes.length.should.be(1));

      when('calling: engine.render(parseResult)', () {
        var renderResult = engine.render(parseResult);
        var expected = {parameterName: true};
        then('result first node should be: "$expected"',
            () => renderResult.text.should.be(expected.toString()));
      });
    });

    input = '{{${ParameterTestFunction.tagName} (FALse)}}';
    when('calling: engine.parse(TextTemplate("$input"))', () {
      var parseResult = engine.parse(TextTemplate(input));

      then('parseResult should have no errors',
          () => parseResult.errors.should.beEmpty());
      then('parseResult should have 1 node',
          () => parseResult.nodes.length.should.be(1));

      when('calling: ', () {
        var renderResult = engine.render(parseResult);
        var expected = {parameterName: false};
        then('renderResult.text should be: "$expected"',
            () => renderResult.text.should.be(expected.toString()));
      });
    });

    input = '{{${ParameterTestFunction.tagName}("Hello")}}';
    when('calling engine.parse(TextTemplate("$input"))', () {
      var parseResult = engine.parse(TextTemplate(input));

      then('parseResult should have no errors',
          () => parseResult.errors.should.beEmpty());
      then('parseResult should have 1 node',
          () => parseResult.nodes.length.should.be(1));

      when('', () {
        var renderResult = engine.render(parseResult);
        var expected = {parameterName: 'Hello'};
        then('renderResult.text should be: "$expected"',
            () => renderResult.text.should.be(expected.toString()));
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
      var result = engine.parse(TextTemplate(input));
      then('result should have 1 error',
          () => result.errors.length.should.be(1));

      var expected = 'Parse Error: invalid function parameter syntax: '
          'parameter2="Test", position: 1:23, source: Text';
      then('result.errorMessage should be: "$expected"',
          () => result.errorMessage.should.be(expected));
    });

    input = '{{${ParameterTestFunction.tagName} '
        '($parameterName1=true, $parameterName3="$test")}}';
    when('calling engine.parse(TextTemplate("$input"))', () {
      var result = engine.parse(TextTemplate(input));
      then('result should have 1 error',
          () => result.errors.length.should.be(1));

      var expected = 'Parse Error: missing mandatory function parameter: '
          'parameter2, position: 1:43, source: Text';
      then('result.errorMessage should be: "$expected"',
          () => result.errorMessage.should.be(expected));
    });

    input = '{{${ParameterTestFunction.tagName} ( $parameterName3="$test" )}}';
    when('calling engine.parse(TextTemplate("$input"))', () {
      var result = engine.parse(TextTemplate(input));
      then('result should have 1 error',
          () => result.errors.length.should.be(1));

      var expected = 'Parse Error: missing mandatory function parameters: '
          'parameter1, parameter2, position: 1:28, source: Text';
      then('result.errorMessage should be: "$expected"',
          () => result.errorMessage.should.be(expected));
    });
    input = '{{${ParameterTestFunction.tagName}'
        '($parameterName2="$test" ,$parameterName1=false)}}';
    when('calling engine.parse(TextTemplate("$input"))', () {
      var result = engine.parse(TextTemplate(input));
      then('result should have 1 error',
          () => result.errors.length.should.be(1));

      var expected = 'Parse Error: missing mandatory function parameter: '
          'parameter3, position: 1:43, source: Text';
      then('result.errorMessage should be: "$expected"',
          () => result.errorMessage.should.be(expected));
    });

    input = '{{${ParameterTestFunction.tagName}  '
        '($parameterName3=-123e-1, $parameterName1=false )  }}';
    when('calling engine.parse(TextTemplate("$input"))', () {
      var result = engine.parse(TextTemplate(input));
      then('result should have 1 error',
          () => result.errors.length.should.be(1));

      var expected = 'Parse Error: missing mandatory function parameter: '
          'parameter2, position: 1:47, source: Text';
      then('result.errorMessage should be: "$expected"',
          () => result.errorMessage.should.be(expected));
    });

    input = '{{${ParameterTestFunction.tagName}( $parameterName3=-123e-1,'
        '$parameterName2="$test",   $parameterName1=false    )  }}';
    when('calling engine.parse(TextTemplate("$input"))', () {
      var parseResult = engine.parse(TextTemplate(input));
      var expected = {
        parameterName3: -12.3,
        parameterName2: test,
        parameterName1: false,
      };

      then('parseResult should have no errors',
          () => parseResult.errors.should.beEmpty());
      then('parseResult should have 1 node',
          () => parseResult.nodes.length.should.be(1));
      when('calling: engine.render(parseResult)', () {
        var renderResult = engine.render(parseResult);
        then('renderResult first node should be: "$expected"',
            () => renderResult.text.should.be(expected.toString()));
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
      var result = engine.parse(TextTemplate(input));
      then('result should have 1 error',
          () => result.errors.length.should.be(1));

      var expected = 'Parse Error: invalid tag syntax, '
          'position: 1:8, source: Text';
      then('result.errorMessage should be: "$expected"',
          () => result.errorMessage.should.be(expected));
    });

    input = '{{${ParameterTestFunction.tagName}'
        '( $parameterName1=true, $parameterName3="$test")}}';
    when('calling engine.parse(TextTemplate("$input"))', () {
      var result = engine.parse(TextTemplate(input));
      then('result should have 1 error',
          () => result.errors.length.should.be(1));

      var expected = 'Parse Error: missing mandatory function parameter: '
          'parameter4, position: 1:43, source: Text';
      then('result.errorMessage should be: "$expected"',
          () => result.errorMessage.should.be(expected));
    });

    input = '{{${ParameterTestFunction.tagName}($parameterName2="$test",'
        '$parameterName1=false)}}';
    when('calling engine.parse(TextTemplate("$input"))', () {
      var result = engine.parse(TextTemplate(input));
      then('result should have 1 error',
          () => result.errors.length.should.be(1));

      var expected = 'Parse Error: missing mandatory function parameters: '
          'parameter3, parameter4, position: 1:42, source: Text';
      then('result.errorMessage should be: "$expected"',
          () => result.errorMessage.should.be(expected));
    });

    input = '{{${ParameterTestFunction.tagName} ( $parameterName3=-123e-1 ,'
        '$parameterName1=false   )}}';
    when('calling engine.parse(TextTemplate("$input"))', () {
      var result = engine.parse(TextTemplate(input));
      then('result should have 1 error',
          () => result.errors.length.should.be(1));

      var expected = 'Parse Error: missing mandatory function parameter: '
          'parameter4, position: 1:49, source: Text';
      then('result.errorMessage should be: "$expected"',
          () => result.errorMessage.should.be(expected));
    });

    input = '{{${ParameterTestFunction.tagName}($parameterName3=-123e-1,'
        '$parameterName1=true,$parameterName4="$test")}}';
    when('calling engine.parse(TextTemplate("$input"))', () {
      var parseResult = engine.parse(TextTemplate(input));
      var expected = {
        parameterName3: -12.3,
        parameterName1: true,
        parameterName4: test,
      };

      then('parseResult should have no errors',
          () => parseResult.errors.should.beEmpty());
      then('parseResult should have 1 node',
          () => parseResult.nodes.length.should.be(1));
      when('calling: engine.render(parseResult)', () {
        var renderResult = engine.render(parseResult);
        then('renderResult.text should be: "$expected"',
            () => renderResult.text.should.be(expected.toString()));
      });
    });

    input = '{{${ParameterTestFunction.tagName}($parameterName3=-123e-1 ,'
        '   $parameterName2=true    ,$parameterName4="$test" ) }}';
    when('calling engine.parse(TextTemplate("$input"))', () {
      var parseResult = engine.parse(TextTemplate(input));
      var expected = {
        parameterName3: -12.3,
        parameterName2: true,
        parameterName4: test,
        parameterName1: false,
      };

      then('parseResult should have no errors',
          () => parseResult.errors.should.beEmpty());
      then('parseResult should have 1 node',
          () => parseResult.nodes.length.should.be(1));
      when('calling: engine.render(parseResult)', () {
        var renderResult = engine.render(parseResult);

        then('renderResult.text should be: "$expected"',
            () => renderResult.text.should.be(expected.toString()));
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
            function: (renderContext, parameters) =>
                'Hello ${parameters['name']}');
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
            function: (renderContext, parameters) => parameters);
}

class DummySource extends Source {
  DummySource() : super.fromPosition(DummyTemplate(), '1,1');
}
