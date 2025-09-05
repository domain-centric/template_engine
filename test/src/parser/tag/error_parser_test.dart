import 'package:test/test.dart';
import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  group('unknownTagOrVariableParser', () {
    test('should return error for undefined tag', () async {
      final template = TextTemplate('Hello {{notDefined attribute="1"}}.');
      final engine = TemplateEngine();

      final result = await engine.parseTemplate(template);

      result.errorMessage.should.be(
        'Parse error in: \'Hello {{notDefined attribute="1"}}.\':\n'
        '  1:20: invalid tag syntax',
      );
    });

    test('should return errors for two undefined tags', () async {
      final template = TextTemplate(
        'Hello {{notDefined1 attribute="1"}} {{notDefined2 attribute="1"}}.',
      );
      final engine = TemplateEngine();

      final result = await engine.parseTemplate(template);

      result.errorMessage.should.be(
        'Parse errors in: \'Hello {{notDefined1 attribute="1"}} {{no...\':\n'
        '  1:21: invalid tag syntax\n'
        '  1:51: invalid tag syntax',
      );
    });
  });

  group('missingTagStartParser', () {
    test(
      'should return error for missing tag end in "Hello {{ world."',
      () async {
        final template = TextTemplate('Hello {{ world.');
        final engine = TemplateEngine();

        final result = await engine.parseTemplate(template);

        result.errorMessage.should.be(
          'Parse error in: \'Hello {{ world.\':\n'
          '  1:7: Found tag start: {{, but it was not followed with a tag end: }}',
        );
      },
    );

    test('should return error for escaped and unclosed tag', () async {
      final template = TextTemplate('Hello \\{{ {{ world.');
      final engine = TemplateEngine();

      final result = await engine.parseTemplate(template);

      result.errorMessage.should.be(
        'Parse error in: \'Hello \\{{ {{ world.\':\n'
        '  1:11: Found tag start: {{, but it was not followed with a tag end: }}',
      );
    });

    test('should return error for unclosed tag after valid one', () async {
      final template = TextTemplate('Hello {{name}} {{.');
      final engine = TemplateEngine();

      final result = await engine.parseTemplate(template);

      result.errorMessage.should.be(
        'Parse error in: \'Hello {{name}} {{.\':\n'
        '  1:16: Found tag start: {{, but it was not followed with a tag end: }}',
      );
    });
  });

  group('missingTagEndParser', () {
    test('should return error for unmatched tag end', () async {
      final template = TextTemplate('Hello }} world.');
      final engine = TemplateEngine();

      final result = await engine.parseTemplate(template);

      result.errorMessage.should.be(
        'Parse error in: \'Hello }} world.\':\n'
        '  1:7: Found tag end: }}, but it was not preceded with a tag start: {{',
      );
    });

    test('should return error for escaped and unmatched tag end', () async {
      final template = TextTemplate('Hello \\}} }} world.');
      final engine = TemplateEngine();

      final result = await engine.parseTemplate(template);

      result.errorMessage.should.be(
        'Parse error in: \'Hello \\}} }} world.\':\n'
        '  1:11: Found tag end: }}, but it was not preceded with a tag start: {{',
      );
    });

    test('should return error for unmatched tag end after valid tag', () async {
      final template = TextTemplate('Hello {{name}} }}.');
      final engine = TemplateEngine();

      final result = await engine.parseTemplate(template);

      result.errorMessage.should.be(
        'Parse error in: \'Hello {{name}} }}.\':\n'
        '  1:16: Found tag end: }}, but it was not preceded with a tag start: {{',
      );
    });
  });
}
