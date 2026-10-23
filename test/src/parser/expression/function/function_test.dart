import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';
import 'package:shouldly/shouldly.dart';

void main() {
  group('TemplateEngine with a Greeting function', () {
    late TemplateEngine engine;

    setUp(() {
      var grammar = Grammar.standard().withAdditionalFunctionGroups([
        FunctionGroup('Greeting', [_greetingWithParameterFunction]),
      ]);
      engine = TemplateEngine(grammar);
    });

    test('parses {{greeting()}}.', () async {
      final result = await engine.parseText('{{greeting()}}.');
      Should.satisfyAllConditions([
        () => result.errors.should.beEmpty(),
        () async =>
            (await engine.render(result)).text.should.be('Hello world.'),
      ]);
    });

    test('parses {{greeting("Jane Doe")}}.', () async {
      final result = await engine.parseText('{{greeting("Jane Doe") }}.');
      Should.satisfyAllConditions([
        () => result.errors.should.beEmpty(),
        () async =>
            (await engine.render(result)).text.should.be('Hello Jane Doe.'),
      ]);
    });

    test('fails to parse invalid parameter syntax'
        '{{greeting("Jane Doe", invalidParameter=invalidValue)}}', () async {
      final input = '{{greeting("Jane Doe", invalidParameter=invalidValue)}}.';
      final result = await engine.parseText(input);
      Should.satisfyAllConditions([
        () => result.errors.should.haveCount(1),
        () => result.errors[0].message.should.be(
          'Unknown parameter name: invalidParameter',
        ),
        () => result.errors[0].location.should.be(TemplateLocation(1, 24)),
        () async =>
            (await engine.render(result)).text.should.be('Hello Jane Doe.'),
      ]);
    });

    test(
      'fails to parse invalid parameter syntax: '
      '{{greeting name= "Jane Doe" invalidParameter"invalidValue" }}',
      () async {
        final input =
            '{{greeting name= "Jane Doe" invalidParameter"invalidValue" }}.';
        final result = await engine.parseText(input);
        Should.satisfyAllConditions([
          () => result.errors.should.haveCount(1),
          () => result.errors[0].message.should.be('Unexpected `name`'),
          () => result.errors[0].location.should.be(TemplateLocation(1, 12)),
          () async =>
              (await engine.render(result)).text.should.be('{{ERROR}}.'),
        ]);
      },
    );
  });

  group('TemplateEngine with a ParameterTestFunction with one parameter', () {
    test('fails to parse invalid syntax: {{123true}}', () async {
      final engine = TemplateEngine();
      final result = await engine.parseText('{{123true}}');
      Should.satisfyAllConditions([
        () => result.errors.should.haveCount(1),
        () => result.errors[0].message.should.be('Unexpected `true`'),
        () => result.errors[0].location.should.be(TemplateLocation(1, 6)),
      ]);
    });

    test('parses {{test(-123e-1)}} and renders correctly', () async {
      final engine = _engineWithTestFunction([
        Parameter(name: 'parameter', presence: PresenceMandatory()),
      ]);
      final parseResult = await engine.parseText('{{test(-123e-1)}}');
      final renderResult = await engine.render(parseResult);

      Should.satisfyAllConditions([
        () => parseResult.errors.should.beEmpty(),
        () => parseResult.document.nodes.should.haveCount(1),
        () => renderResult.text.should.be('{parameter: -12.3}'),
      ]);
    });

    test('parses {{test(true)}} and renders correctly', () async {
      final engine = _engineWithTestFunction([
        Parameter(name: 'parameter', presence: PresenceMandatory()),
      ]);
      final parseResult = await engine.parseText('{{test(true)}}');
      final renderResult = await engine.render(parseResult);

      Should.satisfyAllConditions([
        () => parseResult.errors.should.beEmpty(),
        () => parseResult.document.nodes.should.haveCount(1),
        () => renderResult.text.should.be('{parameter: true}'),
      ]);
    });

    test('parses {{test(FALse)}} and renders correctly', () async {
      final engine = _engineWithTestFunction([
        Parameter(name: 'parameter', presence: PresenceMandatory()),
      ]);
      final parseResult = await engine.parseText('{{test(FALse)}}');
      final renderResult = await engine.render(parseResult);

      Should.satisfyAllConditions([
        () => parseResult.errors.should.beEmpty(),
        () => parseResult.document.nodes.should.haveCount(1),
        () => renderResult.text.should.be('{parameter: false}'),
      ]);
    });

    test('parses {{test("Hello")}} and renders correctly', () async {
      final engine = _engineWithTestFunction([
        Parameter(name: 'parameter', presence: PresenceMandatory()),
      ]);
      final result = await engine.parseText('{{test("Hello")}}');
      final renderResult = await engine.render(result);

      Should.satisfyAllConditions([
        () => result.errors.should.beEmpty(),
        () => result.document.nodes.should.haveCount(1),
        () => renderResult.text.should.be('{parameter: Hello}'),
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

      final parameters = [
        Parameter(name: parameterName1, presence: PresenceMandatory()),
        Parameter(name: parameterName2, presence: PresenceMandatory()),
        Parameter(name: parameterName3, presence: PresenceMandatory()),
      ];
      engine = _engineWithTestFunction(parameters);
    });

    test('fails to parse missing comma between parameters', () async {
      final result = await engine.parseText(
        '{{test(parameter1=trueparameter2="Test")}}',
      );
      Should.satisfyAllConditions([
        () => result.errors.should.haveCount(2),
        () => result.errors[0].message.should.be("Invalid argument syntax"),
        () => result.errors[0].location.should.be(TemplateLocation(1, 33)),
        () => result.errors[1].message.should.be(
          "Missing arguments for parameters: parameter2, parameter3",
        ),
        () => result.errors[1].location.should.be(TemplateLocation(1, 33)),
      ]);
    });

    test('fails to parse missing mandatory parameter2', () async {
      final result = await engine.parseText(
        '{{test (parameter1=true, parameter3="Test")}}',
      );
      Should.satisfyAllConditions([
        () => result.errors.should.haveCount(1),
        () => result.errors[0].message.should.be(
          'Missing argument for parameter: parameter2',
        ),
        () => result.errors[0].location.should.be(TemplateLocation(1, 43)),
      ]);
    });

    test('fails to parse missing parameter1 and parameter2', () async {
      final result = await engine.parseText('{{test ( parameter3="Test" )}}');
      Should.satisfyAllConditions([
        () => result.errors.should.haveCount(1),
        () => result.errors[0].message.should.be(
          "Missing arguments for parameters: parameter1, parameter2",
        ),
        () => result.errors[0].location.should.be(TemplateLocation(1, 28)),
      ]);
    });

    test('fails to parse missing parameter3', () async {
      final result = await engine.parseText(
        '{{test(parameter2="Test" ,parameter1=false)}}',
      );
      Should.satisfyAllConditions([
        () => result.errors.should.haveCount(1),
        () => result.errors[0].message.should.be(
          "Missing argument for parameter: parameter3",
        ),
        () => result.errors[0].location.should.be(TemplateLocation(1, 43)),
      ]);
    });

    test(
      'fails to parse missing parameter2 with reordered parameters',
      () async {
        final result = await engine.parseText(
          '{{test  (parameter3=-123e-1, parameter1=false )  }}',
        );
        Should.satisfyAllConditions([
          () => result.errors.should.haveCount(1),
          () => result.errors[0].message.should.be(
            "Missing argument for parameter: parameter2",
          ),
          () => result.errors[0].location.should.be(TemplateLocation(1, 47)),
        ]);
      },
    );

    test(
      'parses all parameters correctly and renders expected output',
      () async {
        final result = await engine.parseText(
          '{{test(parameter3=-123e-1,parameter2="Test",parameter1=false)}}',
        );
        final renderResult = await engine.render(result);

        Should.satisfyAllConditions([
          () => result.errors.should.beEmpty(),
          () => result.document.nodes.should.haveCount(1),
          () => renderResult.text.should.be(
            {
              'parameter3': -12.3,
              'parameter2': 'Test',
              'parameter1': false,
            }.toString(),
          ),
        ]);
      },
    );
  });

  group('TemplateEngine with a ParameterTestFunction with 4 parameters', () {
    late TemplateEngine engine;

    setUp(() {
      var parameters = [
        Parameter(
          name: 'parameter1',
          presence: PresenceOptionalWithDefaultValue(false),
        ),
        Parameter(name: 'parameter2', presence: PresenceOptional()),
        Parameter(name: 'parameter3', presence: PresenceMandatory()),
        Parameter(name: 'parameter4', presence: PresenceMandatory()),
      ];
      engine = _engineWithTestFunction(parameters);
    });

    test('should return error for invalid syntax', () async {
      var result = await engine.parseText(
        '{{test parameter1=trueparameter2="Test"}}',
      );
      Should.satisfyAllConditions([
        () => result.errors.should.haveCount(1),
        () => result.errors[0].message.should.be('Unexpected `parameter1`'),
        () => result.errors[0].location.should.be(TemplateLocation(1, 8)),
      ]);
    });

    test('should return error for missing parameter4', () async {
      var result = await engine.parseText(
        '{{test( parameter1=true, parameter3="Test")}}',
      );
      Should.satisfyAllConditions([
        () => result.errors.should.haveCount(1),
        () => result.errors[0].message.should.be(
          "Missing argument for parameter: parameter4",
        ),
        () => result.errors[0].location.should.be(TemplateLocation(1, 43)),
      ]);
    });

    test('should return error for missing parameter3 and parameter4', () async {
      var result = await engine.parseText(
        '{{test(parameter2="Test",parameter1=false)}}',
      );
      Should.satisfyAllConditions([
        () => result.errors.should.haveCount(1),
        () => result.errors[0].message.should.be(
          "Missing arguments for parameters: parameter3, parameter4",
        ),
        () => result.errors[0].location.should.be(TemplateLocation(1, 42)),
      ]);
    });

    test(
      'should return error for missing parameter4 with scientific notation',
      () async {
        var result = await engine.parseText(
          '{{test ( parameter3=-123e-1 ,parameter1=false )}}',
        );
        Should.satisfyAllConditions([
          () => result.errors.should.haveCount(1),
          () => result.errors[0].message.should.be(
            "Missing argument for parameter: parameter4",
          ),
          () => result.errors[0].location.should.be(TemplateLocation(1, 47)),
        ]);
      },
    );

    test(
      'should parse and render correctly with all required parameters',
      () async {
        var parseResult = await engine.parseText(
          '{{test(parameter3=-123e-1,parameter1=true,parameter4="Test")}}',
        );
        var renderResult = await engine.render(parseResult);
        Should.satisfyAllConditions([
          () => parseResult.errors.should.beEmpty(),
          () => parseResult.document.nodes.should.haveCount(1),
          () => renderResult.text.should.be(
            {
              'parameter3': -12.3,
              'parameter1': true,
              'parameter4': 'Test',
            }.toString(),
          ),
        ]);
      },
    );

    test('should parse and render correctly with default parameter1', () async {
      var parseResult = await engine.parseText(
        '{{test(parameter3=-123e-1 ,parameter2=true,parameter4="Test" ) }}',
      );
      var renderResult = await engine.render(parseResult);

      Should.satisfyAllConditions([
        () => parseResult.errors.should.beEmpty(),
        () => parseResult.document.nodes.should.haveCount(1),
        () => renderResult.text.should.be(
          {
            'parameter3': -12.3,
            'parameter2': true,
            'parameter4': 'Test',
            'parameter1': false,
          }.toString(),
        ),
      ]);
    });
  });
  group('TemplateEngine function parsing and rendering', () {
    test('should render nested function call: sin(asin(0.5))', () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText('{{sin(asin(0.5))}}');
      var renderResult = await engine.render(parseResult);

      renderResult.text.should.be('0.5');
    });

    test('should return error for missing parameter in sin()', () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText('{{sin()}}');
      Should.satisfyAllConditions([
        () => parseResult.errors.should.haveCount(1),
        () => parseResult.errors[0].message.should.be(
          'Missing argument for parameter: radians',
        ),
        () => parseResult.errors[0].location.should.be(TemplateLocation(1, 7)),
        () async =>
            (await engine.render(parseResult)).text.should.be('{{ERROR}}'),
      ]);
    });
  });
}

// Future<String> _evaluateParameter(
//   Map<String, Expression> arguments,
//   List<ParseError> errors,
// ) async {
//   var expression = arguments['parameter']!;
//   return (await expression.evaluate(
//     RenderContext(
//       grammar: Grammar.standard(),
//       parseResult: ParseResult(
//         document: TemplateDocument(template: TextTemplate('fake'), nodes: []),
//         errors: errors,
//       ),
//     ),
//   )).toString();
// }

final _greetingWithParameterFunction = FunctionDefinition(
  name: 'greeting',
  documentation: FunctionDefinitionDocumentation(
    description: 'A function that shows a greeting',
    examples: [],
  ),
  parameters: [
    Parameter(
      name: 'name',
      presence: PresenceOptionalWithDefaultValue('world'),
    ),
  ],
  function: (context) {
    var name = context.argumentValues['name'];
    return Future.value('Hello $name');
  },
);

FunctionDefinition _parameterTestFunction(List<Parameter> parameters) =>
    FunctionDefinition(
      name: 'test',
      documentation: FunctionDefinitionDocumentation(
        description: 'A function that returns the arguments of this function',
        examples: [],
      ),
      parameters: parameters,
      function: (context) => Future.value(context.argumentValues),
    );

TemplateEngine _engineWithTestFunction(List<Parameter> parameters) {
  var grammar = Grammar.standard().withAdditionalFunctionGroups([
    FunctionGroup('test', [_parameterTestFunction(parameters)]),
  ]);
  var engine = TemplateEngine(grammar);
  return engine;
}

// extension on MapAssertions<String, Expression> {
//   void haveArgument<VALUE_TYPE>({required Object key, String? renderedValue}) {
//     if (!subject!.containsKey(key)) {
//       throw ShouldlyTestFailureError(
//         '\n$subjectLabel map should contain key\n'
//         '    "$key"\n'
//         '    but it does not',
//       );
//     }
//     var value = (subject![key] as LiteralExpression).value;
//     if (value is! VALUE_TYPE) {
//       throw ShouldlyTestFailureError(
//         '\n$subjectLabel map value with key "${key.toString()}"\n'
//         '    is "$value"\n'
//         '    but is not of type "$VALUE_TYPE"',
//       );
//     }
//     if (renderedValue != null && value.toString() != renderedValue) {
//       throw ShouldlyTestFailureError(
//         '\n$subjectLabel map value with key "${key.toString()}"\n'
//         '    is "$value"\n'
//         '    but expected value to be "$renderedValue"',
//       );
//     }
//   }
// }
