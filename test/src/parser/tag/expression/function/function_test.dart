import 'package:petitparser/petitparser.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';
import 'package:shouldly/shouldly.dart';

void main() {
  group('Parameter class', () {
    test(
        'calling constructor: Parameter(name: "inv@lid")) should throw a ParameterException with a valid error message',
        () {
      Should.throwException<ParameterException>(
              () => Parameter(name: 'inv@lid'))!
          .message
          .should
          .be('Invalid parameter name: "inv@lid", '
              'letter OR digit expected at position 3');
    });
  });
  group('ArgumentsParser class', () {
    late SettableParser loopbackParser;
    late ParserContext parseContext;
    late TemplateEngine engine;

    setUp(() {
      loopbackParser = undefined();
      engine = TemplateEngine();
      var textTemplate = TextTemplate('dummy');
      parseContext = ParserContext(
          engine, textTemplate); // Replace with actual context if needed
    });

    test('parses positional arguments', () async {
      final parameters = [
        Parameter(name: 'a', presence: Presence.mandatory()),
        Parameter(name: 'b', presence: Presence.optionalWithDefaultValue(42)),
      ];

      loopbackParser.set(digit().map((d) => Value(int.parse(d))));

      final parser = ArgumentsParser(
        parserContext: parseContext,
        parameters: parameters,
        loopbackParser: loopbackParser,
      );

      final parseResult = parser.parse('1, 2)');
      parseResult.should.beOfType<Success<Map<String, Expression<Object>>>>();
      parseResult.value.should.be({
        'a': Value(1),
        'b': Value(2),
      });
    });

    test('parses named arguments', () async {
      final parameters = [
        Parameter(name: 'x', presence: Presence.mandatory()),
        Parameter(name: 'y', presence: Presence.optionalWithDefaultValue(10)),
      ];

      loopbackParser.set(digit().map((d) => Value(int.parse(d))));

      final parser = ArgumentsParser(
        parserContext: parseContext,
        parameters: parameters,
        loopbackParser: loopbackParser,
      );

      final parseResult = parser.parse('x=5, y=7)');
      parseResult.value.should.be({
        'x': Value(5),
        'y': Value(7),
      });
    });

    test('parses mixed arguments, skipping optional', () async {
      final parameters = [
        Parameter(name: 'a', presence: Presence.mandatory()),
        Parameter(name: 'b', presence: Presence.optionalWithDefaultValue(0)),
        Parameter(name: 'c', presence: Presence.optionalWithDefaultValue(1)),
      ];

      loopbackParser.set(digit().map((d) => Value(int.parse(d))));

      final parser = ArgumentsParser(
        parserContext: parseContext,
        parameters: parameters,
        loopbackParser: loopbackParser,
      );

      final parseResult = parser.parse('1, c=3)');
      parseResult.should.beOfType<Success<Map<String, Expression<Object>>>>();
      var map = parseResult.value;
      Should.satisfyAllConditions([
        () => map.entries.length.should.be(3),
        () => map.should.containKeyWithValue('a', Value(1)),
        () => map.should.containKeyWithValue('b', Value(0)),
        () => map.should.containKeyWithValue('c', Value(3)),
      ]);
    });

    test('parses mixed arguments, random order', () async {
      final parameters = [
        Parameter(name: 'a', presence: Presence.mandatory()),
        Parameter(name: 'b', presence: Presence.optionalWithDefaultValue(0)),
        Parameter(name: 'c', presence: Presence.optionalWithDefaultValue(1)),
      ];

      loopbackParser.set(digit().map((d) => Value(int.parse(d))));

      final parser = ArgumentsParser(
        parserContext: parseContext,
        parameters: parameters,
        loopbackParser: loopbackParser,
      );

      final parseResult = parser.parse('1, c=3, b=9)');
      parseResult.should.beOfType<Success<Map<String, Expression<Object>>>>();
      parseResult.value.should.be({
        'a': Value(1),
        'b': Value(9),
        'c': Value(3),
      });
    });

    test('fills in default values for optional parameters', () async {
      final parameters = [
        Parameter(name: 'a', presence: Presence.mandatory()),
        Parameter(name: 'b', presence: Presence.optionalWithDefaultValue(99)),
      ];

      loopbackParser.set(digit().map((d) => Value(int.parse(d))));

      final parser = ArgumentsParser(
        parserContext: parseContext,
        parameters: parameters,
        loopbackParser: loopbackParser,
      );

      final result = parser.parse('1)');
      result.should.beOfType<Success<Map<String, Expression<Object>>>>();
      result.value.should.be({
        'a': Value(1),
        'b': Value(99),
      });
    });
    test('fails on invalid argument syntax', () async {
      final parameters = [
        Parameter(name: 'a', presence: Presence.mandatory()),
        Parameter(name: 'b', presence: Presence.optionalWithDefaultValue(0)),
        Parameter(name: 'c', presence: Presence.optionalWithDefaultValue(1)),
      ];

      loopbackParser.set(digit().map((d) => Value(int.parse(d))));

      final parser = ArgumentsParser(
        parserContext: parseContext,
        parameters: parameters,
        loopbackParser: loopbackParser,
      );

      final parseResult = parser.parse('1, c=3, b=9, invalid)');
      parseResult.should.beOfType<Failure>();
      parseResult
          .toString()
          .should
          .be('Failure[1:14]: invalid syntax in function argument');
    });

    test('fails on named arguments before positional arguments', () async {
      final parameters = [
        Parameter(name: 'a', presence: Presence.mandatory()),
        Parameter(name: 'b', presence: Presence.optionalWithDefaultValue(0)),
        Parameter(name: 'c', presence: Presence.optionalWithDefaultValue(1)),
      ];

      loopbackParser.set(digit().map((d) => Value(int.parse(d))));

      final parser = ArgumentsParser(
        parserContext: parseContext,
        parameters: parameters,
        loopbackParser: loopbackParser,
      );

      final parseResult = parser.parse('c=3, 1, b=9)');
      parseResult.should.beOfType<Failure>();
      parseResult.toString().should.be(
          'Failure[1:6]: positional arguments must come before named arguments');
    });

    test('fails on duplicate parameter', () {
      final parameters = [
        Parameter(name: 'a', presence: Presence.mandatory()),
      ];

      loopbackParser.set(digit().map((d) => Value(int.parse(d))));

      final parser = ArgumentsParser(
        parserContext: parseContext,
        parameters: parameters,
        loopbackParser: loopbackParser,
      );

      final result = parser.parse('a=1, a=2)');
      result.should.beOfType<Failure>();
      result.message.should.be('parameter "a" was specified more than once');
    });

    test('fails when mandatory parameter is missing', () {
      final parameters = [
        Parameter(name: 'a', presence: Presence.mandatory()),
        Parameter(name: 'b', presence: Presence.optionalWithDefaultValue(5)),
      ];

      loopbackParser.set(digit().map((d) => Value(int.parse(d))));

      final parser = ArgumentsParser(
        parserContext: parseContext,
        parameters: parameters,
        loopbackParser: loopbackParser,
      );

      final result = parser.parse('b=2)');
      result.should.beOfType<Failure>();
      result.message.should.be('missing argument for parameter: a');
    });
  });

  group('positionalArgumentParser function', () {
    late ArgumentEntryParser parser;
    setUp(() {
      var parserContext = ParserContext(TemplateEngine(), TextTemplate(''));
      var loopBackParser = SettableParser(expressionParser(parserContext));
      var parameter = Parameter(name: 'parameter');
      parser = positionalArgumentParser(
              parserContext: parserContext,
              positionalParameter: parameter,
              parameters: [parameter],
              loopbackParser: loopBackParser)
          .end();
    });

    test('calling parse("-123e-1") should return a correct value', () {
      var result = parser.parse('-123e-1');
      Should.satisfyAllConditions([
        () => result.should
            .beOfType<Success<MapEntry<String, Expression<Object>>>>(),
        () => result.value
            .toString()
            .should
            .be('MapEntry(parameter: PrefixExpression{-})'),
      ]);
    });

    test('calling parser.parse(" true") should return a correct value', () {
      var parseResult = parser.parse(' true');
      Should.satisfyAllConditions([
        () => parseResult.should
            .beOfType<Success<MapEntry<String, Expression<Object>>>>(),
        () => parseResult.value
            .toString()
            .should
            .be(MapEntry('parameter', Value(true)).toString()),
      ]);
    });

    test('calling parser.parse(" FALse") should return a correct value', () {
      var parseResult = parser.parse(' FALse');
      Should.satisfyAllConditions([
        () => parseResult.should
            .beOfType<Success<MapEntry<String, Expression<Object>>>>(),
        () => parseResult.value
            .toString()
            .should
            .be(MapEntry('parameter', Value(false)).toString()),
      ]);
    });

    test('calling parser.parse(\'"Hello"\') should return a correct value', () {
      var parseResult = parser.parse('\'Hello\'');
      Should.satisfyAllConditions([
        () => parseResult.should
            .beOfType<Success<MapEntry<String, Expression<Object>>>>(),
        () => parseResult.value
            .toString()
            .should
            .be(MapEntry('parameter', Value('Hello')).toString()),
      ]);
    });

    test('calling parser.parse("   \'Hello\'") should return a correct value',
        () {
      var parseResult = parser.parse('   \'Hello\'');
      Should.satisfyAllConditions([
        () => parseResult.should
            .beOfType<Success<MapEntry<String, Expression<Object>>>>(),
        () => parseResult.value
            .toString()
            .should
            .be(MapEntry('parameter', Value('Hello')).toString()),
      ]);
    });

    test(
        'calling parser.parse("   \'Hello\'   ") should return a correct value',
        () {
      var parseResult = parser.parse('   \'Hello\'   ');
      Should.satisfyAllConditions([
        () => parseResult.should
            .beOfType<Success<MapEntry<String, Expression<Object>>>>(),
        () => parseResult.value
            .toString()
            .should
            .be(MapEntry('parameter', Value('Hello')).toString()),
      ]);
    });
  });

  group('namedArgumentParser function', () {
    late ArgumentEntryParser parser;

    setUp(() {
      var parserContext = ParserContext(TemplateEngine(), TextTemplate(''));
      var loopBackParser = SettableParser(expressionParser(parserContext));
      parser = namedArgumentParser(
        parserContext: parserContext,
        parameter: Parameter(name: 'parameter'),
        loopbackParser: loopBackParser,
      ).end();
    });

    test('parses "parameter=-123e-1" as PrefixExpression{-}', () {
      var result = parser.parse('parameter=-123e-1');
      result.value
          .toString()
          .should
          .be('MapEntry(parameter: PrefixExpression{-})');
    });

    test('parses " parameter =  -123e-1" as PrefixExpression{-}', () {
      var result = parser.parse(' parameter =  -123e-1');
      Should.satisfyAllConditions([
        () => result.should
            .beOfType<Success<MapEntry<String, Expression<Object>>>>(),
        () => result.value
            .toString()
            .should
            .be('MapEntry(parameter: PrefixExpression{-})'),
      ]);
    });

    test('parses "  parameter=true" as Value(true)', () {
      var result = parser.parse('  parameter=true');
      Should.satisfyAllConditions([
        () => result.should
            .beOfType<Success<MapEntry<String, Expression<Object>>>>(),
        () => result.value
            .toString()
            .should
            .be(MapEntry('parameter', Value(true)).toString()),
      ]);
    });

    test('parses " parameter  =FALse" as Value(false)', () {
      var result = parser.parse(' parameter  =FALse');
      Should.satisfyAllConditions([
        () => result.should
            .beOfType<Success<MapEntry<String, Expression<Object>>>>(),
        () => result.value
            .toString()
            .should
            .be(MapEntry('parameter', Value(false)).toString()),
      ]);
    });

    test('fails to parse " PARAmeter=   \\"Hello\\"" due to case mismatch', () {
      var result = parser.parse(' PARAmeter=   "Hello"');
      Should.satisfyAllConditions([
        () => result.should.beOfType<Failure>(),
        () => result.message.should.be('"parameter" expected'),
      ]);
    });

    test("parses \" parameter  =   'Hello'   \" as Value('Hello')", () {
      var result = parser.parse(" parameter  =   'Hello'   ");
      Should.satisfyAllConditions([
        () => result.should
            .beOfType<Success<MapEntry<String, Expression<Object>>>>(),
        () => result.value
            .toString()
            .should
            .be(MapEntry('parameter', Value('Hello')).toString()),
      ]);
    });

    test('fails to parse " bogus=bogus" due to unknown parameter', () {
      var result = parser.parse(" bogus=bogus");
      Should.satisfyAllConditions([
        () => result.should.beOfType<Failure>(),
        () => result.message.should.be('"parameter" expected'),
      ]);
    });

    test('fails to parse " parameter" due to missing "="', () {
      var result = parser.parse(" parameter");
      Should.satisfyAllConditions([
        () => result.should.beOfType<Failure>(),
        () => result.message.should.be('"=" expected'),
      ]);
    });
  });

  group('TemplateEngine with a Greeting function', () {
    late TemplateEngine engine;

    setUp(() {
      engine = TemplateEngine();
      engine.functionGroups
          .add(FunctionGroup('Greeting', [GreetingWithParameterFunction()]));
    });

    test('parses {{greeting()}}.', () async {
      final result = await engine.parseText('{{greeting()}}.');
      final template = result.children.first;

      Should.satisfyAllConditions([
        () => result.errorMessage.should.beNullOrEmpty(),
        () => template.children.length.should.be(2),
        () => template.children[0].toString().should.be('Function{greeting}'),
        () => template.children[1].should.be('.'),
      ]);

      final rendered = await engine.render(result);
      rendered.text.should.be('Hello world.');
    });

    test('parses {{greeting("Jane Doe")}}.', () async {
      final result = await engine.parseText('{{greeting("Jane Doe") }}.');
      final template = result.children.first;

      Should.satisfyAllConditions([
        () => result.errorMessage.should.beNullOrEmpty(),
        () => template.children.length.should.be(2),
        () => template.children[0].toString().should.be('Function{greeting}'),
        () => template.children[1].should.be('.'),
      ]);

      final rendered = await engine.render(result);
      rendered.text.should.be('Hello Jane Doe.');
    });

    test('fails to parse invalid parameter syntax', () async {
      final input = '{{greeting("Jane Doe", invalidParameter=invalidValue)}}.';
      final result = await engine.parseText(input);

      final validInput = '{{greeting("Jane Doe") }}.';
      final validResult = await engine.parseText(validInput);
      final template = validResult.children.first;
      Should.satisfyAllConditions([
        () => result.errorMessage.should.be(
            "Parse error in: '{{greeting(\"Jane Doe\", invalidParameter=...':\n"
            "  1:24: invalid syntax in function argument"),
        () => template.children[0].should.beOfType<FunctionExpression>(),
        () => template.children[1].should.be('.'),
      ]);
    });

    test('fails to parse invalid tag syntax', () async {
      final input =
          '{{greeting name= "Jane Doe" invalidParameter"invalidValue" }}.';
      final result = await engine.parseText(input);

      final expected =
          'Parse error in: \'{{greeting name= "Jane Doe" invalidParam...\':\n'
          '  1:12: invalid tag syntax';

      final validInput = '{{greeting("Jane Doe") }}.';
      final validResult = await engine.parseText(validInput);
      final template = validResult.children.first;
      Should.satisfyAllConditions([
        () => result.errorMessage.should.be(expected),
        () => template.children[0].should.beOfType<FunctionExpression>(),
        () => template.children[1].should.be('.'),
      ]);
    });
  });

  group('TemplateEngine with a ParameterTestFunction with one parameter', () {
    late TemplateEngine engine;
    late String parameterName;

    setUp(() {
      parameterName = 'testParameter';
      final parameterTestFunction =
          ParameterTestFunction([Parameter(name: parameterName)]);
      engine = TemplateEngine();
      engine.functionGroups.add(FunctionGroup('Test', [parameterTestFunction]));
    });

    test('fails to parse invalid tag syntax: {{123true}}', () async {
      final result = await engine.parseText('{{123true}}');

      result.errorMessage.should
          .be('Parse error in: \'{{123true}}\':\n  1:6: invalid tag syntax');
    });

    test('parses {{test(-123e-1)}} and renders correctly', () async {
      final result = await engine.parseText('{{test(-123e-1)}}');
      final renderResult = await engine.render(result);

      Should.satisfyAllConditions([
        () => result.errorMessage.should.beNullOrEmpty(),
        () => result.children.length.should.be(1),
        () => renderResult.text.should.be('{testParameter: -12.3}'),
      ]);
    });

    test('parses {{test(true)}} and renders correctly', () async {
      final result = await engine.parseText('{{test(true)}}');
      final renderResult = await engine.render(result);

      Should.satisfyAllConditions([
        () => result.errorMessage.should.beNullOrEmpty(),
        () => result.children.length.should.be(1),
        () => renderResult.text.should.be('{testParameter: true}'),
      ]);
    });

    test('parses {{test(FALse)}} and renders correctly', () async {
      final result = await engine.parseText('{{test(FALse)}}');
      final renderResult = await engine.render(result);

      Should.satisfyAllConditions([
        () => result.errorMessage.should.beNullOrEmpty(),
        () => result.children.length.should.be(1),
        () => renderResult.text.should.be('{testParameter: false}'),
      ]);
    });

    test('parses {{test("Hello")}} and renders correctly', () async {
      final result = await engine.parseText('{{test("Hello")}}');
      final renderResult = await engine.render(result);

      Should.satisfyAllConditions([
        () => result.errorMessage.should.beNullOrEmpty(),
        () => result.children.length.should.be(1),
        () => renderResult.text.should.be('{testParameter: Hello}'),
      ]);
    });
  });

  group('TemplateEngine with a ParameterTestFunction with 3 parameters', () {
    late TemplateEngine engine;
    late String parameterName1, parameterName2, parameterName3;

    setUp(() {
      parameterName1 = 'parameter1';
      parameterName2 = 'parameter2';
      parameterName3 = 'parameter3';

      final testFunction = ParameterTestFunction([
        Parameter(name: parameterName1),
        Parameter(name: parameterName2),
        Parameter(name: parameterName3),
      ]);

      engine = TemplateEngine();
      engine.functionGroups.add(FunctionGroup('Test', [testFunction]));
    });

    test('fails to parse missing comma between parameters', () async {
      final result =
          await engine.parseText('{{test(parameter1=trueparameter2="Test")}}');
      result.errorMessage.should.be(
          'Parse error in: \'{{test(parameter1=trueparameter2="Test")...\':\n'
          '  1:23: comma expected');
    });

    test('fails to parse missing mandatory parameter2', () async {
      final result = await engine
          .parseText('{{test (parameter1=true, parameter3="Test")}}');

      result.errorMessage.should.be(
          'Parse error in: \'{{test (parameter1=true, parameter3="Tes...\':\n'
          '  1:43: missing argument for parameter: parameter2');
    });

    test('fails to parse missing parameter1 and parameter2', () async {
      final result = await engine.parseText('{{test ( parameter3="Test" )}}');

      result.errorMessage.should.be(
          'Parse error in: \'{{test ( parameter3="Test" )}}\':\n'
          '  1:28: missing arguments for parameters: parameter1, parameter2');
    });

    test('fails to parse missing parameter3', () async {
      final result = await engine
          .parseText('{{test(parameter2="Test" ,parameter1=false)}}');

      result.errorMessage.should.be(
          'Parse error in: \'{{test(parameter2="Test" ,parameter1=fal...\':\n'
          '  1:43: missing argument for parameter: parameter3');
    });

    test('fails to parse missing parameter2 with reordered parameters',
        () async {
      final result = await engine
          .parseText('{{test  (parameter3=-123e-1, parameter1=false )  }}');

      result.errorMessage.should.be(
          'Parse error in: \'{{test  (parameter3=-123e-1, parameter1=...\':\n'
          '  1:47: missing argument for parameter: parameter2');
    });

    test('parses all parameters correctly and renders expected output',
        () async {
      final result = await engine.parseText(
          '{{test(parameter3=-123e-1,parameter2="Test",parameter1=false)}}');
      final renderResult = await engine.render(result);

      Should.satisfyAllConditions([
        () => result.errorMessage.should.beNullOrEmpty(),
        () => result.children.length.should.be(1),
        () => renderResult.text.should.be({
              'parameter3': -12.3,
              'parameter2': 'Test',
              'parameter1': false,
            }.toString()),
      ]);
    });
  });

  group('TemplateEngine with a ParameterTestFunction with 4 parameters', () {
    late TemplateEngine engine;

    setUp(() {
      var testFunction = ParameterTestFunction([
        Parameter(
            name: 'parameter1',
            presence: Presence.optionalWithDefaultValue(false)),
        Parameter(name: 'parameter2', presence: Presence.optional()),
        Parameter(name: 'parameter3'),
        Parameter(name: 'parameter4'),
      ]);

      engine = TemplateEngine();
      engine.functionGroups.add(FunctionGroup('Test', [testFunction]));
    });

    test('should return error for invalid tag syntax', () async {
      var result = await engine.parseText(
          '{{${ParameterTestFunction.id} parameter1=trueparameter2="Test"}}');
      result.errorMessage.should.be(
          'Parse error in: \'{{test parameter1=trueparameter2="Test"}...\':\n'
          '  1:8: invalid tag syntax');
    });

    test('should return error for missing parameter4', () async {
      var result = await engine.parseText(
          '{{${ParameterTestFunction.id}( parameter1=true, parameter3="Test")}}');
      result.errorMessage.should.be(
          'Parse error in: \'{{test( parameter1=true, parameter3="Tes...\':\n'
          '  1:43: missing argument for parameter: parameter4');
    });

    test('should return error for missing parameter3 and parameter4', () async {
      var result = await engine.parseText(
          '{{${ParameterTestFunction.id}(parameter2="Test",parameter1=false)}}');
      result.errorMessage.should.be(
          'Parse error in: \'{{test(parameter2="Test",parameter1=fals...\':\n'
          '  1:42: missing arguments for parameters: parameter3, parameter4');
    });

    test('should return error for missing parameter4 with scientific notation',
        () async {
      var result = await engine.parseText(
          '{{${ParameterTestFunction.id} ( parameter3=-123e-1 ,parameter1=false )}}');
      result.errorMessage.should.be(
          'Parse error in: \'{{test ( parameter3=-123e-1 ,parameter1=...\':\n'
          '  1:47: missing argument for parameter: parameter4');
    });

    test('should parse and render correctly with all required parameters',
        () async {
      var parseResult = await engine.parseText(
          '{{${ParameterTestFunction.id}(parameter3=-123e-1,parameter1=true,parameter4="Test")}}');
      var renderResult = await engine.render(parseResult);
      Should.satisfyAllConditions([
        () => parseResult.errorMessage.should.beNullOrEmpty(),
        () => parseResult.children.length.should.be(1),
        () => renderResult.text.should.be({
              'parameter3': -12.3,
              'parameter1': true,
              'parameter4': 'Test',
            }.toString())
      ]);
    });

    test('should parse and render correctly with default parameter1', () async {
      var parseResult = await engine.parseText(
          '{{${ParameterTestFunction.id}(parameter3=-123e-1 ,parameter2=true,parameter4="Test" ) }}');
      var renderResult = await engine.render(parseResult);

      Should.satisfyAllConditions([
        () => parseResult.errorMessage.should.beNullOrEmpty(),
        () => parseResult.children.length.should.be(1),
        () => renderResult.text.should.be({
              'parameter3': -12.3,
              'parameter2': true,
              'parameter4': 'Test',
              'parameter1': false,
            }.toString())
      ]);
    });
  });
  group('TemplateEngine function parsing and rendering', () {
    test('should render function with operators in parameter', () async {
      var engine = TemplateEngine();
      var parseResult =
          await engine.parseText('{{length("Hello" + " " & "world.") + 3}}');
      var renderResult = await engine.render(parseResult);

      renderResult.text.should.be((('Hello world.'.length) + 3).toString());
    });

    test('should render nested function call: sin(asin(0.5))', () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText('{{sin(asin(0.5))}}');
      var renderResult = await engine.render(parseResult);

      renderResult.text.should.be('0.5');
    });

    test('should return error for missing parameter in sin()', () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText('{{sin()}}');
      var renderResult = await engine.render(parseResult);
      Should.satisfyAllConditions([
        () => parseResult.errorMessage.should
            .be('Parse error in: \'{{sin()}}\':\n'
                '  1:7: missing argument for parameter: radians'),
        () => renderResult.text.should.be('{{sin()}}'),
      ]);
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
  static const id = 'test';

  ParameterTestFunction(List<Parameter> parameters)
      : super(
            name: id,
            description: 'A tag for testing',
            exampleExpression: 'dummy',
            exampleResult: 'dummy',
            parameters: parameters,
            function: (position, renderContext, parameters) =>
                Future.value(parameters));
}
