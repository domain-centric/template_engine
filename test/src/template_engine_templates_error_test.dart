import 'package:test/test.dart';
import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  group('TemplateEngine', () {
    final engine = TemplateEngine();

    test('should handle single parse error with parseTemplates', () async {
      final parseResult = await engine.parseTemplates([
        TextTemplate('Hello '),
        TextTemplate('{{name}.'),
      ]);
      final renderResult = await engine.render(parseResult, {'name': 'world'});

      Should.satisfyAllConditions([
        () => renderResult.errorMessage.should.be(
          'Parse error in: \'{{name}.\':\n'
          '  1:1: Found tag start: {{, but it was not followed with a tag end: }}',
        ),
        () => renderResult.text.should.be('Hello {{'),
      ]);
    });

    test('should handle multiple parse errors with parseTemplates', () async {
      final parseResult = await engine.parseTemplates([
        TextTemplate('Hello '),
        TextTemplate('}}name{{.'),
      ]);
      final renderResult = await engine.render(parseResult, {'name': 'world'});

      Should.satisfyAllConditions([
        () => renderResult.errorMessage.should.be(
          'Parse errors in: \'}}name{{.\':\n'
          '  1:1: Found tag end: }}, but it was not preceded with a tag start: {{\n'
          '  1:7: Found tag start: {{, but it was not followed with a tag end: }}',
        ),
        () => renderResult.text.should.be('Hello }}name{{'),
      ]);
    });

    test('should handle single render error with parseTemplates', () async {
      final parseResult = await engine.parseTemplates([
        TextTemplate('Hello '),
        TextTemplate('{{name}}.'),
      ]);
      final renderResult = await engine.render(parseResult, {'age': '13'});

      Should.satisfyAllConditions([
        () => renderResult.errorMessage.should.be(
          'Render error in: \'{{name}}.\':\n'
          '  1:3: Variable does not exist: name',
        ),
        () => renderResult.text.should.be('Hello {{ERROR}}.'),
      ]);
    });

    test('should handle multiple render errors with parseTemplates', () async {
      final parseResult = await engine.parseTemplates([
        TextTemplate('Hello {{name}}. '),
        TextTemplate('Welcome in {{location}}.'),
      ]);
      final renderResult = await engine.render(parseResult, {'age': '13'});

      Should.satisfyAllConditions([
        () => renderResult.errorMessage.should.be(
          'Render error in: \'Hello {{name}}.\':\n'
          '  1:9: Variable does not exist: name\n'
          'Render error in: \'Welcome in {{location}}.\':\n'
          '  1:14: Variable does not exist: location',
        ),
        () => renderResult.text.should.be(
          'Hello {{ERROR}}. Welcome in {{ERROR}}.',
        ),
      ]);
    });

    test(
      'should handle multiple errors (parse and render) with parseTemplates',
      () async {
        final parseResult = await engine.parseTemplates([
          TextTemplate('}}Hello {{name}}. '),
          TextTemplate('Welcome in {{location}}.'),
        ]);
        final renderResult = await engine.render(parseResult, {'age': '13'});

        Should.satisfyAllConditions([
          () => renderResult.errorMessage.should.be(
            'Errors in: \'}}Hello {{name}}.\':\n'
            '  Parse error:\n'
            '    1:1: Found tag end: }}, but it was not preceded with a tag start: {{\n'
            '  Render error:\n'
            '    1:11: Variable does not exist: name\n'
            'Render error in: \'Welcome in {{location}}.\':\n'
            '  1:14: Variable does not exist: location',
          ),
          () => renderResult.text.should.be(
            '}}Hello {{ERROR}}. Welcome in {{ERROR}}.',
          ),
        ]);
      },
    );
  });
}
