import 'package:test/test.dart';
import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  group('TemplateEngine', () {
    final engine = TemplateEngine();

    test('should handle single parse error', () async {
      final parseResult = await engine.parseText('Hello {{name}.');
      final renderResult = await engine.render(
        parseResult,
        variables: {'name': 'world'},
      );

      Should.satisfyAllConditions([
        () => renderResult.aggregatedErrorMessage.should.be(
          "Error in: Hello {{name}.\n"
          "  Parse error:\n"
          "    1:7 - Unexpected code block start delimiter `{{` without succeeding end delimiter `}}`",
        ),
        () => renderResult.text.should.be('Hello {{'),
      ]);
    });

    test('should handle multiple parse errors', () async {
      final parseResult = await engine.parseText('Hello }}name{{.');
      final renderResult = await engine.render(
        parseResult,
        variables: {'name': 'world'},
      );

      Should.satisfyAllConditions([
        () => parseResult.document.nodes[0].should
            .beOfType<TextNode>()!
            .text
            .should
            .be('Hello '),
        () => parseResult.document.nodes[1].should
            .beOfType<ErrorNode>()!
            .originalCode
            .should
            .be('}}'),
        () => parseResult.document.nodes[2].should
            .beOfType<TextNode>()!
            .text
            .should
            .be('name'),
        () => parseResult.document.nodes[3].should
            .beOfType<ErrorNode>()!
            .originalCode
            .should
            .be('{{'),
        () => parseResult.document.nodes[4].should
            .beOfType<TextNode>()!
            .text
            .should
            .be('.'),
        () => renderResult.aggregatedErrorMessage.should.be(
          "Errors in: Hello }}name{{.\n"
          "  Parse errors:\n"
          "    1:7 - Unexpected code block end delimiter `}}` without preceding start delimiter `{{`\n"
          "    1:13 - Unexpected code block start delimiter `{{` without succeeding end delimiter `}}`",
        ),
        () => renderResult.text.should.be('Hello }}name{{'),
      ]);
    });

    test('should handle single render error', () async {
      final parseResult = await engine.parseText('Hello {{name}}.');
      final renderResult = await engine.render(
        parseResult,
        variables: {'age': '13'},
      );

      Should.satisfyAllConditions([
        () => renderResult.aggregatedErrorMessage.should.be(
          "Error in: Hello {{name}}.\n"
          "  Render error:\n"
          "    1:9 - Variable `name` does not exist",
        ),
        () => renderResult.text.should.be('Hello {{ERROR}}.'),
      ]);
    });

    test('should handle multiple render errors', () async {
      final parseResult = await engine.parseText(
        'Hello {{name}}. Welcome in {{location}}.',
      );
      final renderResult = await engine.render(
        parseResult,
        variables: {'age': '13'},
      );

      Should.satisfyAllConditions([
        () => renderResult.aggregatedErrorMessage.should.be(
          "Errors in: Hello {{name}}. Welcome in {{location}}.\n"
          "  Render errors:\n"
          "    1:9 - Variable `name` does not exist\n"
          "    1:30 - Variable `location` does not exist",
        ),
        () => renderResult.text.should.be(
          'Hello {{ERROR}}. Welcome in {{ERROR}}.',
        ),
      ]);
    });
  });
}
