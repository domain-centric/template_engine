import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  group('TemplateEngine', () {
    final engine = TemplateEngine();

    test('should handle single parse error', () async {
      final parseResult = await engine.parseText('Hello {{name}.');
      final renderResult = await engine.render(parseResult, {'name': 'world'});

      Should.satisfyAllConditions([
        () => renderResult.errorMessage.should.be(
          'Parse error in: \'Hello {{name}.\':\n'
          '  1:7: Found tag start: {{, but it was not followed with a tag end: }}',
        ),
        () => renderResult.text.should.be('Hello {{'),
      ]);
    });

    test('should handle multiple parse errors', () async {
      final parseResult = await engine.parseText('Hello }}name{{.');
      final renderResult = await engine.render(parseResult, {'name': 'world'});

      Should.satisfyAllConditions([
        () => renderResult.errorMessage.should.be(
          'Parse errors in: \'Hello }}name{{.\':\n'
          '  1:7: Found tag end: }}, but it was not preceded with a tag start: {{\n'
          '  1:13: Found tag start: {{, but it was not followed with a tag end: }}',
        ),
        () => renderResult.text.should.be('Hello }}name{{'),
      ]);
    });

    test('should handle single render error', () async {
      final parseResult = await engine.parseText('Hello {{name}}.');
      final renderResult = await engine.render(parseResult, {'age': '13'});

      Should.satisfyAllConditions([
        () => renderResult.errorMessage.should.be(
          'Render error in: \'Hello {{name}}.\':\n'
          '  1:9: Variable does not exist: name',
        ),
        () => renderResult.text.should.be('Hello {{ERROR}}.'),
      ]);
    });

    test('should handle multiple render errors', () async {
      final parseResult = await engine.parseText(
        'Hello {{name}}. Welcome in {{location}}.',
      );
      final renderResult = await engine.render(parseResult, {'age': '13'});

      Should.satisfyAllConditions([
        () => renderResult.errorMessage.should.be(
          'Render errors in: \'Hello {{name}}. Welcome in {{location}}.\':\n'
          '  1:9: Variable does not exist: name\n'
          '  1:30: Variable does not exist: location',
        ),
        () => renderResult.text.should.be(
          'Hello {{ERROR}}. Welcome in {{ERROR}}.',
        ),
      ]);
    });
  });
}
