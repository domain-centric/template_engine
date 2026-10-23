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
