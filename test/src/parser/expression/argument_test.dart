import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  group('Parsing arguments', () {
    late List<ParseError> errors;
    setUp(() {
      errors = [];
    });
    test('parses positional arguments', () async {
      final parameters = [
        Parameter(name: 'a', presence: PresenceMandatory()),
        Parameter(name: 'b', presence: PresenceOptionalWithDefaultValue(42)),
      ];
      var arguments = await _parseAndEvaluateArguments(
        parameters,
        errors,
        '(1, 2)',
      );
      Should.satisfyAllConditions([
        () => errors.should.beEmpty(),
        () => arguments.should.be({'a': 1, 'b': 2}),
      ]);
    });

    test('parses named arguments', () async {
      final parameters = [
        Parameter(name: 'x', presence: PresenceMandatory()),
        Parameter(name: 'y', presence: PresenceOptionalWithDefaultValue(10)),
      ];
      var arguments = await _parseAndEvaluateArguments(
        parameters,
        errors,
        '(x=5, y=7)',
      );
      Should.satisfyAllConditions([
        () => errors.should.beEmpty(),
        () => arguments.should.be({'x': 5, 'y': 7}),
      ]);
    });

    test('parses mixed arguments, skipping optional', () async {
      final parameters = [
        Parameter(name: 'a', presence: PresenceMandatory()),
        Parameter(name: 'b', presence: PresenceOptionalWithDefaultValue(0)),
        Parameter(name: 'c', presence: PresenceOptionalWithDefaultValue(1)),
      ];
      var arguments = await _parseAndEvaluateArguments(
        parameters,
        errors,
        '(1, c=3)',
      );
      Should.satisfyAllConditions([
        () => errors.should.beEmpty,
        () => arguments.length.should.be(3),
        () => arguments.should.containKeyWithValue('a', 1),
        () => arguments.should.containKeyWithValue('b', 0),
        () => arguments.should.containKeyWithValue('c', 3),
      ]);
    });

    test('parses mixed arguments, random order', () async {
      final parameters = [
        Parameter(name: 'a', presence: PresenceMandatory()),
        Parameter(name: 'b', presence: PresenceOptionalWithDefaultValue(0)),
        Parameter(name: 'c', presence: PresenceOptionalWithDefaultValue(1)),
      ];
      var arguments = await _parseAndEvaluateArguments(
        parameters,
        errors,
        '(1, c=3, b=9)',
      );
      Should.satisfyAllConditions([
        () => errors.should.beEmpty,
        () => arguments.length.should.be(3),
        () => arguments.should.containKeyWithValue('a', 1),
        () => arguments.should.containKeyWithValue('b', 9),
        () => arguments.should.containKeyWithValue('c', 3),
      ]);
    });

    test('fills in default values for optional parameters', () async {
      final parameters = [
        Parameter(name: 'a', presence: PresenceMandatory()),
        Parameter(name: 'b', presence: PresenceOptionalWithDefaultValue(99)),
      ];

      var arguments = await _parseAndEvaluateArguments(
        parameters,
        errors,
        '(1)',
      );
      Should.satisfyAllConditions([
        () => errors.should.beEmpty(),
        () => arguments.length.should.be(2),
        () => arguments.should.containKeyWithValue('a', 1),
        () => arguments.should.containKeyWithValue('b', 99),
      ]);
    });
    test('fails on invalid argument syntax', () async {
      final parameters = [
        Parameter(name: 'a', presence: PresenceMandatory()),
        Parameter(name: 'b', presence: PresenceOptionalWithDefaultValue(0)),
        Parameter(name: 'c', presence: PresenceOptionalWithDefaultValue(1)),
      ];
      var arguments = await _parseAndEvaluateArguments(
        parameters,
        errors,
        '(1, c=3, b=99, 12)',
      );
      Should.satisfyAllConditions([
        () => arguments.length.should.be(3),
        () => arguments.should.containKeyWithValue('a', 1),
        () => arguments.should.containKeyWithValue('b', 99),
        () => arguments.should.containKeyWithValue('c', 3),
        () => errors.should.haveCount(1),
        () => errors[0].message.should.be(
          'Positional arguments must precede named arguments',
        ),
        () => errors[0].location.should.be(TemplateLocation(1, 16)),
      ]);
    });

    test('fails on named arguments before positional arguments', () async {
      final parameters = [
        Parameter(name: 'a', presence: PresenceMandatory()),
        Parameter(name: 'b', presence: PresenceOptionalWithDefaultValue(0)),
        Parameter(name: 'c', presence: PresenceOptionalWithDefaultValue(1)),
      ];
      _parseAndEvaluateArguments(parameters, errors, '(c=3, 1, a=9)');
      Should.satisfyAllConditions([
        () => errors.should.haveCount(1),
        () => errors[0].message.should.be(
          'Positional arguments must precede named arguments',
        ),
        () => errors[0].location.should.be(TemplateLocation(1, 7)),
      ]);
    });

    test('fails on missing arguments for parameter b', () async {
      final parameters = [
        Parameter(name: 'a', presence: PresenceMandatory()),
        Parameter(name: 'b', presence: PresenceMandatory()),
        Parameter(name: 'c', presence: PresenceOptionalWithDefaultValue(1)),
      ];
      _parseArguments(parameters, errors, '(c=3, a=9)');
      Should.satisfyAllConditions([
        () => errors.should.haveCount(1),
        () => errors[0].message.should.be('Missing argument for parameter: b'),
        () => errors[0].location.should.be(TemplateLocation(1, 10)),
      ]);
    });

    test('fails on missing arguments for parameter b and d', () async {
      final parameters = [
        Parameter(name: 'a', presence: PresenceMandatory()),
        Parameter(name: 'b', presence: PresenceMandatory()),
        Parameter(name: 'c', presence: PresenceOptionalWithDefaultValue(1)),
        Parameter(name: 'd', presence: PresenceMandatory()),
      ];
      _parseArguments(parameters, errors, '(c=3, a=9)');
      Should.satisfyAllConditions([
        () => errors.should.haveCount(1),
        () => errors.first.message.should.be(
          'Missing arguments for parameters: b, d',
        ),
        () => errors.first.location.should.be(TemplateLocation(1, 10)),
      ]);
    });

    test('fails on too many arguments', () async {
      final parameters = [
        Parameter(name: 'a', presence: PresenceMandatory()),
        Parameter(name: 'b', presence: PresenceMandatory()),
      ];
      _parseAndEvaluateArguments(parameters, errors, '(1, 2, 3)');
      Should.satisfyAllConditions([
        () => errors.should.haveCount(1),
        () => errors[0].message.should.be(
          'More arguments than there are parameters',
        ),
        () => errors[0].location.should.be(TemplateLocation(1, 8)),
      ]);
    });

    test('fails on duplicate parameter', () async {
      final parameters = [Parameter(name: 'a', presence: PresenceMandatory())];
      await _parseAndEvaluateArguments(parameters, errors, '(a=1, a=2)');
      Should.satisfyAllConditions([
        () => errors.should.haveCount(1),
        () => errors[0].message.should.be(
          'Parameter a was specified more than once',
        ),
        () => errors[0].location.should.be(TemplateLocation(1, 7)),
      ]);
    });

    test('fails when mandatory parameter is missing', () {
      final parameters = [
        Parameter(name: 'a', presence: PresenceMandatory()),
        Parameter(name: 'b', presence: PresenceOptionalWithDefaultValue(5)),
      ];
      _parseArguments(parameters, errors, '(b=2)');
      Should.satisfyAllConditions([
        () => errors.should.haveCount(1),
        () => errors[0].message.should.be('Missing argument for parameter: a'),
        () => errors[0].location.should.be(TemplateLocation(1, 5)),
      ]);
    });
  });

  group('Parsing function positional arguments', () {
    late List<Parameter> parameters;
    late List<ParseError> errors;
    setUp(() {
      parameters = <Parameter>[
        Parameter(name: 'parameter', presence: PresenceMandatory()),
      ];
      errors = [];
    });

    test('calling parse("-123e-1") should return a correct value', () async {
      var arguments = await _parseAndEvaluateArguments(
        parameters,
        errors,
        '(-123e-1)',
      );
      Should.satisfyAllConditions([
        () => errors.should.beEmpty(),
        () => arguments.should.containKey('parameter'),
        () => (arguments['parameter'] as double).should.be(-12.3),
      ]);
    });

    test('calling parse("-123e-1+2") should return a correct value', () async {
      var arguments = await _parseAndEvaluateArguments(
        parameters,
        errors,
        '(-123e-1+2)',
      );
      Should.satisfyAllConditions([
        () => errors.should.beEmpty(),
        () => arguments.should.containKey('parameter'),
        () => (arguments['parameter'] as double).should.be(-10.3),
      ]);
    });

    test(
      'calling parser.parse(" true") should return a correct value',
      () async {
        var arguments = await _parseAndEvaluateArguments(
          parameters,
          errors,
          '(true)',
        );
        Should.satisfyAllConditions([
          () => errors.should.beEmpty(),
          () => arguments.should.containKey('parameter'),
          () => (arguments['parameter'] as bool).should.beTrue(),
        ]);
      },
    );

    test(
      'calling parser.parse(" FALse") should return a correct value',
      () async {
        var arguments = await _parseAndEvaluateArguments(
          parameters,
          errors,
          '( FALse)',
        );
        Should.satisfyAllConditions([
          () => errors.should.beEmpty(),
          () => arguments.should.containKey('parameter'),
          () => (arguments['parameter'] as bool).should.beFalse(),
        ]);
      },
    );

    test(
      'calling parser.parse(\'"Hello"\') should return a correct value',
      () async {
        var arguments = await _parseAndEvaluateArguments(
          parameters,
          errors,
          '("Hello")',
        );
        Should.satisfyAllConditions([
          () => errors.should.beEmpty(),
          () => arguments.should.containKey('parameter'),
          () => (arguments['parameter'] as String).should.be('Hello'),
        ]);
      },
    );

    test(
      'calling parser.parse("   \'Hello\'") should return a correct value',
      () async {
        var arguments = await _parseAndEvaluateArguments(
          parameters,
          errors,
          "(   'Hello')",
        );
        Should.satisfyAllConditions([
          () => errors.should.beEmpty(),
          () => arguments.should.containKey('parameter'),
          () => (arguments['parameter'] as String).should.be('Hello'),
        ]);
      },
    );

    test(
      'calling parser.parse("   \'Hello\'   ") should return a correct value',
      () async {
        var arguments = await _parseAndEvaluateArguments(
          parameters,
          errors,
          "(   'Hello'     )",
        );
        Should.satisfyAllConditions([
          () => errors.should.beEmpty(),
          () => arguments.should.containKey('parameter'),
          () => (arguments['parameter'] as String).should.be('Hello'),
        ]);
      },
    );
  });

  group('Parsing function named arguments', () {
    late List<Parameter> parameters;
    late List<ParseError> errors;
    setUp(() {
      parameters = <Parameter>[
        Parameter(name: 'parameter', presence: PresenceMandatory()),
      ];
      errors = [];
    });

    test('parses "parameter=-123e-1" as PrefixExpression{-}', () async {
      var arguments = await _parseAndEvaluateArguments(
        parameters,
        errors,
        "(parameter=-123e-1)",
      );
      Should.satisfyAllConditions([
        () => errors.should.beEmpty(),
        () => arguments.should.containKey('parameter'),
        () => (arguments['parameter'] as double).should.be(-12.3),
      ]);
    });

    test(
      'calling parse(" parameter =  -123e-1+2 ") should return a correct value',
      () async {
        var arguments = await _parseAndEvaluateArguments(
          parameters,
          errors,
          '( parameter =  -123e-1+2 )',
        );
        Should.satisfyAllConditions([
          () => errors.should.beEmpty(),
          () => arguments.should.containKey('parameter'),
          () => (arguments['parameter'] as double).should.be(-10.3),
        ]);
      },
    );

    test('parses "  parameter=true" as true)', () async {
      var arguments = await _parseAndEvaluateArguments(
        parameters,
        errors,
        "(  parameter=true)",
      );
      Should.satisfyAllConditions([
        () => errors.should.beEmpty(),
        () => arguments.should.containKey('parameter'),
        () => (arguments['parameter'] as bool).should.beTrue(),
      ]);
    });

    test('parses " parameter  =FALse" as false)', () async {
      var arguments = await _parseAndEvaluateArguments(
        parameters,
        errors,
        "( parameter  =FALse)",
      );
      Should.satisfyAllConditions([
        () => errors.should.beEmpty(),
        () => arguments.should.containKey('parameter'),
        () => (arguments['parameter'] as bool).should.beFalse(),
      ]);
    });

    test(
      'parser " PARAmeter=   \\"Hello\\"" should be successful (case unsensitive)',
      () async {
        var arguments = await _parseAndEvaluateArguments(
          parameters,
          errors,
          '( PARAmeter=   "Hello")',
        );
        Should.satisfyAllConditions([
          () => errors.should.beEmpty(),
          () => arguments.should.containKey('parameter'),
          () => (arguments['parameter'] as String).should.be('Hello'),
        ]);
      },
    );

    test("parses \" parameter  =   'Hello'   \" as 'Hello')", () async {
      var arguments = await _parseAndEvaluateArguments(
        parameters,
        errors,
        "( parameter  =   'Hello'   )",
      );
      Should.satisfyAllConditions([
        () => errors.should.beEmpty(),
        () => arguments.should.containKey('parameter'),
        () => (arguments['parameter'] as String).should.be('Hello'),
      ]);
    });

    test('fails to parse " bogus=bogus" due to unknown parameter', () {
      _parseArguments(parameters, errors, "( bogus=bogus)");
      Should.satisfyAllConditions([
        () => errors.should.haveCount(2),
        () => errors[0].message.should.be('Unknown parameter name: bogus'),
        () => errors[0].location.should.be(TemplateLocation(1, 3)),
        () => errors[1].message.should.be(
          'Missing argument for parameter: parameter',
        ),
        () => errors[1].location.should.be(TemplateLocation(1, 14)),
      ]);
    });

    test('fails to parse when a parameter was specified more than once', () {
      _parseAndEvaluateArguments(
        parameters,
        errors,
        "('positional', parameter='named')",
      );
      Should.satisfyAllConditions([
        () => errors.should.haveCount(1),
        () => errors[0].message.should.be(
          'Parameter parameter was specified more than once',
        ),
        () => errors[0].location.should.be(TemplateLocation(1, 16)),
      ]);
    });
  });
}

ArgumentExpressionMap _parseArguments(
  List<Parameter<dynamic>> parameters,
  List<ParseError> errors,
  String argumentText,
) {
  var grammar = Grammar.standard();
  var tokens = CodeTokenStream(grammar, argumentText, TemplateLocation(1, 1));
  var parser = ExpressionParser(grammar, tokens, errors);
  var argumentExpressionList = parser.parseArguments();
  var argumentExpressionMap = ArgumentExpressionMap(
    argumentExpressionList,
    parameters,
  );
  errors.addAll(argumentExpressionMap.errors);
  return argumentExpressionMap;
}

Future<Map<String, dynamic>> _evaluateArguments(
  ArgumentExpressionMap argumentExpressionMap,
  List<ParseError> errors,
) async {
  var context = RenderContext(
    grammar: Grammar.standard(),
    parseResult: ParseResult(
      document: TemplateDocument(template: TextTemplate(''), nodes: []),
      errors: errors,
    ),
  );
  return await argumentExpressionMap.evaluate(context);
}

Future<Map<String, dynamic>> _parseAndEvaluateArguments(
  List<Parameter<dynamic>> parameters,
  List<ParseError> errors,
  String argumentText,
) async {
  var argumentExpressionMap = _parseArguments(parameters, errors, argumentText);
  var argumentValueMap = await _evaluateArguments(
    argumentExpressionMap,
    errors,
  );
  return argumentValueMap;
}
