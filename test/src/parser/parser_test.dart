import 'package:shouldly/shouldly.dart';
import 'package:test/test.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  group('CodeTokenStream', () {
    test('tokenizes identifiers and numbers correctly', () {
      final grammar = Grammar.standard();
      final stream = CodeTokenStream(
        grammar,
        'foo 123',
        TemplateLocation(1, 1),
      );
      stream.peek().value.should.be('foo');
      stream.consume().value.should.be('foo');
      stream.peek().value.should.be('123');
    });
  });

  group('TemplateParser', () {
    test('parses text and expression nodes', () async {
      final grammar = Grammar.standard();
      final template = TextTemplate('Hello {{ name }}!');
      final parser = TemplateParser(
        grammar: grammar,
        source: template,
        text: await template.text,
      );
      final result = parser.parse();
      result.errors.should.beEmpty();
      result.document.nodes.should.haveCount(3);
      var context = RenderContext(
        grammar: grammar,
        parseResult: result,
        variables: {'name': 'world'},
      );
      (await renderFromContext(context)).text.should.be('Hello world!');
    });

    test('omits standalone whitespace around void function calls', () async {
      final grammar = Grammar.standard().withAdditionalFunctionGroups([
        FunctionGroup('Actions', [
          FunctionDefinition<void>(
            name: 'perform',
            parameters: const [],
            function: (context) {
              context.renderContext.variables['performed'] = true;
              return Future<void>.value();
            },
            documentation: FunctionDefinitionDocumentation(
              description: 'Performs an action.',
              examples: const [],
            ),
          ),
        ]),
      ]);
      final engine = TemplateEngine(grammar);
      final parseResult = await engine.parseText(
        'Before\r\n\t{{ perform() }}\r\nAfter',
      );

      final render = await engine.render(
        parseResult,
        variables: {'performed': false},
      );

      Should.satisfyAllConditions([
        () => render.text.should.be('Before\r\nAfter'),
        () => expect(render.variables['performed'], isTrue),
        () => parseResult.errors.should.beEmpty(),
      ]);
    });

    test('omits standalone whitespace around void method calls', () async {
      final grammar = Grammar.standard().withAdditionalMethods([
        MethodDefinition<List, void>(
          name: 'clearItems',
          parameters: const [],
          method: (context) {
            context.owner.clear();
            return Future<void>.value();
          },
          description: 'Clears the list.',
          examples: const [],
        ),
      ]);
      final engine = TemplateEngine(grammar);
      final items = [1, 2, 3];
      final parseResult = await engine.parseText(
        'Before\n  {{ items.clearItems() }}\nAfter',
      );

      final render = await engine.render(
        parseResult,
        variables: {'items': items},
      );

      Should.satisfyAllConditions([
        () => render.text.should.be('Before\nAfter'),
        () => items.should.beEmpty(),
        () => parseResult.errors.should.beEmpty(),
      ]);
    });

    test('preserves whitespace around inline void function calls', () async {
      final grammar = Grammar.standard().withAdditionalFunctionGroups([
        FunctionGroup('Actions', [
          FunctionDefinition<void>(
            name: 'perform',
            parameters: const [],
            function: (_) => Future<void>.value(),
            documentation: FunctionDefinitionDocumentation(
              description: 'Performs an action.',
              examples: const [],
            ),
          ),
        ]),
      ]);
      final engine = TemplateEngine(grammar);
      final parseResult = await engine.parseText(
        'Before {{ perform() }} after',
      );

      final render = await engine.render(parseResult);

      render.text.should.be('Before  after');
      parseResult.errors.should.beEmpty();
    });

    test(
      'preserves standalone whitespace for nullable function results',
      () async {
        final grammar = Grammar.standard().withAdditionalFunctionGroups([
          FunctionGroup('Queries', [
            FunctionDefinition<String?>(
              name: 'missingValue',
              parameters: const [],
              function: (_) => Future<String?>.value(),
              documentation: FunctionDefinitionDocumentation(
                description: 'Returns no value.',
                examples: const [],
              ),
            ),
          ]),
        ]);
        final engine = TemplateEngine(grammar);
        final parseResult = await engine.parseText(
          'Before\n\t{{ missingValue() }}\nAfter',
        );

        final render = await engine.render(parseResult);

        render.text.should.be('Before\n\t\nAfter');
        parseResult.errors.should.beEmpty();
      },
    );

    test('parses nested if/else/endif blocks', () async {
      final grammar = Grammar.standard();
      final template = TextTemplate(
        '{{ if active }}Yes{{ else }}No{{ endif }}',
      );
      final parser = TemplateParser(
        grammar: grammar,
        source: template,
        text: await template.text,
      );
      final result = parser.parse();
      result.errors.should.beEmpty();
      result.document.nodes.should.haveCount(1);
      var contextActiveTrue = RenderContext(
        grammar: grammar,
        parseResult: result,
        variables: {'active': true},
      );
      (await renderFromContext(contextActiveTrue)).text.should.be('Yes');
      var contextActiveFalse = RenderContext(
        grammar: grammar,
        parseResult: result,
        variables: {'active': false},
      );
      (await renderFromContext(contextActiveFalse)).text.should.be('No');
    });

    test('records an error when endif is missing', () async {
      final grammar = Grammar.standard();
      final template = TextTemplate('{{ if active }}Missing end');
      final parser = TemplateParser(
        grammar: grammar,
        source: template,
        text: await template.text,
      );
      final result = parser.parse();
      result.errors.should.haveCount(1);
      result.errors.first.message.should.be(
        'Expected `elseif` or `else` or `endif` before end of template',
      );
      result.errors.first.location.should.be(TemplateLocation(1, 16));
    });

    test('if statement definitions match code blocks correctly', () {
      final grammar = Grammar.standard();
      ifStatement
          .matches(
            CodeTokenStream(grammar, 'if active', TemplateLocation(1, 1)),
          )
          .should
          .be(true);
    });

    test('assignment statement definitions match code blocks correctly', () {
      final grammar = Grammar.standard();
      assignStatement
          .matches(
            CodeTokenStream(grammar, 'value = 1', TemplateLocation(1, 1)),
          )
          .should
          .be(true);
    });

    test('assignment statement consumes all tokens when parsing fails', () {
      final grammar = Grammar.standard();
      final parser = TemplateParser(
        grammar: grammar,
        source: TextTemplate(''),
        text: '',
      );
      final tokens = CodeTokenStream(
        grammar,
        'value = 1 +',
        TemplateLocation(1, 1),
      );

      expect(
        () => assignStatement.parse(parser, tokens),
        throwsA(isA<ParseError>()),
      );
      tokens.isAtEnd.should.be(true);
    });

    test('reports error when expression is a reserved keyword', () async {
      final grammar = Grammar.standard();
      final template = TextTemplate('{{ endif }}');
      final parser = TemplateParser(
        grammar: grammar,
        source: template,
        text: await template.text,
      );
      final result = parser.parse();
      result.errors.should.haveCount(1);
      result.errors.first.message.should.be(
        "Unable to parse expression block: Unexpected reserved keyword `endif`",
      );
      result.errors.first.location.should.be(TemplateLocation(1, 4));
      result.document.nodes.should.haveCount(1);
    });

    test('reports unexpected end delimiter at its position', () async {
      final grammar = Grammar.standard();
      final template = TextTemplate('Text {{ name }} more text }}');
      final parser = TemplateParser(
        grammar: grammar,
        source: template,
        text: await template.text,
      );

      final result = parser.parse();

      result.errors.should.haveCount(1);
      result.errors.first.location.should.be(TemplateLocation(1, 27));
    });
  });
}
