import 'package:shouldly/shouldly.dart';
import 'package:test/test.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  group('ExpressionGrammar', () {
    test(
      'withAdditionalConstants preserves existing constants and adds new ones',
      () {
        final grammar = Grammar.standard().withAdditionalConstants([
          ConstantDefinition<int>(
            name: 'foo',
            description: 'A custom constant',
            examples: const [],
            value: 42,
          ),
        ]);

        grammar.constants.map((c) => c.name).should.contain('foo');
      },
    );
  });

  group('ExpressionParser', () {
    test('parses numeric expressions and evaluates them', () async {
      final grammar = Grammar.standard();
      final tokens = CodeTokenStream(
        grammar,
        '3 + 4 * 2',
        TemplateLocation(1, 1),
      );
      final errors = <ParseError>[];
      final parser = ExpressionParser(grammar, tokens, errors);
      final expression = parser.parseExpression();
      final value = await expression.evaluate(FakeRenderContext());
      (value as int).should.be(11);
      errors.should.beEmpty();
    });

    test('parses variables using the render context', () async {
      final grammar = Grammar.standard();
      final tokens = CodeTokenStream(
        grammar,
        'user.name',
        TemplateLocation(1, 1),
      );
      final errors = <ParseError>[];
      final parser = ExpressionParser(grammar, tokens, errors);
      final expression = parser.parseExpression();
      final context = FakeRenderContext(
        variables: {
          'user': {'name': 'Alice'},
        },
      );
      var value = await expression.evaluate(context);
      (value as String).should.be('Alice');
      errors.should.beEmpty();
    });

    test('reports an error for reserved keywords used as identifiers', () {
      final grammar = Grammar.standard();
      final tokens = CodeTokenStream(grammar, 'endif', TemplateLocation(1, 1));
      final errors = <ParseError>[];
      final parser = ExpressionParser(grammar, tokens, errors);
      Should.throwException<ParseError>(() => parser.parseExpression())!
        ..message.should.contain('Unexpected reserved keyword `endif')
        ..location.should.be(TemplateLocation(1, 1));
    });

    test(
      'records an error for a function call missing closing parenthesis',
      () {
        final grammar = Grammar.standard();
        final tokens = CodeTokenStream(grammar, "sin(", TemplateLocation(1, 1));
        final errors = <ParseError>[];
        final parser = ExpressionParser(grammar, tokens, errors);
        parser.parseExpression();
        errors.should.haveCount(2);
        errors.first.message.should.contain('Missing closing parenthesis');
      },
    );

    test('records an error for a method call missing closing parenthesis', () {
      final grammar = Grammar.standard();
      final tokens = CodeTokenStream(
        grammar,
        "'hello'.toUpperCase(",
        TemplateLocation(1, 1),
      );
      final errors = <ParseError>[];
      final parser = ExpressionParser(grammar, tokens, errors);
      parser.parseExpression();
      errors.should.haveCount(1);
      errors.first.message.should.contain('Missing closing parenthesis');
    });

    test(
      'Does not consume all tokens when a method call has no method name',
      () async {
        final grammar = Grammar.standard();
        final tokens = CodeTokenStream(
          grammar,
          "'hello'.()",
          TemplateLocation(1, 1),
        );
        final errors = <ParseError>[];
        final parser = ExpressionParser(grammar, tokens, errors);

        var expression = parser.parseExpression();
        Should.satisfyAllConditions([
          () => expression.should.beOfType<LiteralExpression>(),
          () {
            var value = (expression as LiteralExpression).value;
            (value as String).should.be('hello');
          },
          () => tokens.peek().value.should.be('.'),
        ]);
      },
    );

    test('throws when a method is unknown', () {
      final grammar = Grammar.standard();
      final tokens = CodeTokenStream(
        grammar,
        "'hello'.missing()",
        TemplateLocation(1, 1),
      );
      final errors = <ParseError>[];
      final parser = ExpressionParser(grammar, tokens, errors);

      Should.throwException<ParseError>(() => parser.parseExpression())!
        ..message.should.be('Unknown method `missing`')
        ..location.should.be(TemplateLocation(1, 9));
    });

    test(
      'Does not consume all tokens when a property access has no property name',
      () async {
        final grammar = Grammar.standard();
        final tokens = CodeTokenStream(
          grammar,
          "'hello'.",
          TemplateLocation(1, 1),
        );
        final errors = <ParseError>[];
        final parser = ExpressionParser(grammar, tokens, errors);

        var expression = parser.parseExpression();
        Should.satisfyAllConditions([
          () => expression.should.beOfType<LiteralExpression>(),
          () {
            var value = (expression as LiteralExpression).value;
            (value as String).should.be('hello');
          },
          () => tokens.peek().value.should.be('.'),
        ]);
      },
    );
  });

  group('Parentheses', () {
    test('{{1 + 3 * 2}} should render: 7', () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText("{{1 + 3 * 2}}");
      var renderResult = await engine.render(parseResult);
      renderResult.text.should.be('7');
    });

    test('{{(1 + 3) * 2}} should render: 8', () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText("{{(1 + 3) * 2}}");
      var renderResult = await engine.render(parseResult);
      renderResult.text.should.be('8');
    });

    test('{{true & (false | true)}} should render: true', () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText("{{true & (false | true)}}");
      var renderResult = await engine.render(parseResult);
      renderResult.text.should.be('true');
    });

    test('{{("Hello " + "world").length()}} should render: 11', () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText(
        "{{('Hello ' + 'world').length()}}",
      );
      var renderResult = await engine.render(parseResult);
      renderResult.text.should.be('11');
    });
  });

  group('variable block', () {
    test('renders simple variable block', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText('Hello {{ name }}.');
      final renderResult = await engine.render(
        parseResult,
        variables: {'name': 'world'},
      );

      renderResult.text.should.be('Hello world.');
      parseResult.errors.should.beEmpty();
      renderResult.errors.should.beEmpty();
    });
  });
}

class FakeRenderContext extends RenderContext {
  FakeRenderContext({super.variables})
    : super(
        grammar: Grammar.standard(),
        parseResult: ParseResult(
          document: TemplateDocument(
            template: TextTemplate('Fake template'),
            nodes: [],
          ),
          errors: [],
        ),
      );
}
