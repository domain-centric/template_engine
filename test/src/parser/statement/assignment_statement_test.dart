import 'package:template_engine/template_engine.dart';
import 'package:shouldly/shouldly.dart';
import 'package:test/test.dart';

void main() {
  group('AssignmentStatement', () {
    test('assigns simple string value', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText(
        '{{ name = "World" }}Hello {{ name }}',
      );

      final render = await engine.render(parseResult);

      render.text.should.be('Hello World');
      parseResult.errors.should.beEmpty();
    });

    test('assigns number value', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText('{{ x = 42 }}{{ x }}');

      final render = await engine.render(parseResult);

      render.text.should.be('42');
      parseResult.errors.should.beEmpty();
    });

    test('supports assignments and expression precedence', () async {
      final engine = TemplateEngine();
      final template = '{{ value = (3 + 5) * 2 }}Result: {{ value }}';
      final parseResult = await engine.parseText(template);
      final renderResult = await engine.render(parseResult);

      renderResult.text.should.be('Result: 16');
      parseResult.errors.should.beEmpty();
    });

    test('assignment does not produce output itself', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText('{{ name = "Test" }}');

      final render = await engine.render(parseResult);

      render.text.should.be('');
      parseResult.errors.should.beEmpty();
    });

    test('assignment supports expressions', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText('{{ x = 1 + 2 }}{{ x }}');

      final render = await engine.render(parseResult);

      render.text.should.be('3');
      parseResult.errors.should.beEmpty();
    });

    test('assignment with extra spaces', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText(
        '{{   name   =   "World"   }}Hello {{ name }}',
      );

      final render = await engine.render(parseResult);

      render.text.should.be('Hello World');
      parseResult.errors.should.beEmpty();
    });

    test('multiple assignments in sequence', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText(
        '{{ a = "A" }}{{ b = "B" }}{{ a }}{{ b }}',
      );

      final render = await engine.render(parseResult);

      render.text.should.be('AB');
      parseResult.errors.should.beEmpty();
    });

    test('assignment overwrites existing value', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText(
        '{{ name = "First" }}{{ name = "Second" }}{{ name }}',
      );

      final render = await engine.render(parseResult);

      render.text.should.be('Second');
      parseResult.errors.should.beEmpty();
    });

    test('assignment can use existing variables', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText(
        '{{ greeting = "Hello" }}{{ message = greeting }}{{ message }}',
      );

      final render = await engine.render(parseResult);

      render.text.should.be('Hello');
      parseResult.errors.should.beEmpty();
    });

    test('missing expression produces error', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText('{{ name = }}');
      Should.satisfyAllConditions([
        () => parseResult.errors.should.haveCount(1),
        () => parseResult.errors.first.message.should.be(
          'Unable to parse statement block: Unexpected end of expression',
        ),
      ]);
    });

    test('missing equals does not match assignment', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText('{{ name "World" }}');
      parseResult.errors.length.should.be(1);
      parseResult.errors.first.message.should.be('Unexpected `World`');
      parseResult.errors.first.location.should.be(TemplateLocation(1, 9));
    });

    test('invalid left-hand side produces error', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText('{{ 123 = "value" }}');
      parseResult.errors.length.should.be(1);
      parseResult.errors.first.message.should.be('Unexpected `=`');
      parseResult.errors.first.location.should.be(TemplateLocation(1, 8));
    });

    test('assignment inside other statements', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText(
        '{{ if true }}{{ name = "Inner" }}{{ endif }}{{ name }}',
      );
      var variables = <String, dynamic>{};
      final render = await engine.render(parseResult, variables: variables);

      render.text.should.be('Inner');
      parseResult.errors.should.beEmpty();
    });
  });
}
