import 'package:test/test.dart';
import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  group('TemplateEngine', () {
    final engine = TemplateEngine();

    test('should handle single parse error with parseTemplates', () async {
      final parseResults = await engine.parseTemplates([
        TextTemplate('Hello '),
        TextTemplate('{{name}.'),
      ]);
      final renderResults = await engine.renderAll(
        parseResults,
        variables: {'name': 'world'},
      );

      Should.satisfyAllConditions([
        () => renderResults.aggregatedErrorMessage.should.be(
          "Error in: {{name}.\n"
          "  Parse error:\n"
          "    1:1 - Unexpected code block start delimiter `{{` without succeeding end delimiter `}}`",
        ),
        () => renderResults.map((r) => r.text).join().should.be('Hello {{'),
      ]);
    });

    test('should handle multiple parse errors with parseTemplates', () async {
      final parseResults = await engine.parseTemplates([
        TextTemplate('Hello '),
        TextTemplate('}}name{{.'),
      ]);
      final renderResults = await engine.renderAll(
        parseResults,
        variables: {'name': 'world'},
      );

      Should.satisfyAllConditions([
        () => renderResults.aggregatedErrorMessage.should.be(
          "Errors in: }}name{{.\n"
          "  Parse errors:\n"
          "    1:1 - Unexpected code block end delimiter `}}` without preceding start delimiter `{{`\n"
          "    1:7 - Unexpected code block start delimiter `{{` without succeeding end delimiter `}}`",
        ),
        () =>
            renderResults.map((r) => r.text).join().should.be('Hello }}name{{'),
      ]);
    });

    test('should handle single render error with parseTemplates', () async {
      final parseResults = await engine.parseTemplates([
        TextTemplate('Hello '),
        TextTemplate('{{name}}.'),
      ]);
      final renderResults = await engine.renderAll(
        parseResults,
        variables: {'age': '13'},
      );

      Should.satisfyAllConditions([
        () => renderResults.aggregatedErrorMessage.should.be(
          "Error in: {{name}}.\n"
          "  Render error:\n"
          "    1:3 - Variable `name` does not exist",
        ),
        () => renderResults
            .map((r) => r.text)
            .join()
            .should
            .be('Hello {{ERROR}}.'),
      ]);
    });

    test('should handle multiple render errors with parseTemplates', () async {
      final parseResults = await engine.parseTemplates([
        TextTemplate('Hello {{name}}. '),
        TextTemplate('Welcome in {{location}}.'),
      ]);
      final renderResults = await engine.renderAll(
        parseResults,
        variables: {'age': '13'},
      );

      Should.satisfyAllConditions([
        () => renderResults.aggregatedErrorMessage.should.be(
          "Error in: Hello {{name}}. \n"
          "  Render error:\n"
          "    1:9 - Variable `name` does not exist\n"
          "Error in: Welcome in {{location}}.\n"
          "  Render error:\n"
          "    1:14 - Variable `location` does not exist",
        ),
        () => renderResults
            .map((r) => r.text)
            .join()
            .should
            .be('Hello {{ERROR}}. Welcome in {{ERROR}}.'),
      ]);
    });

    test(
      'should handle multiple errors (parse and render) with parseTemplates',
      () async {
        final parseResults = await engine.parseTemplates([
          TextTemplate('}}Hello {{name}}. '),
          TextTemplate('Welcome in {{location}}.'),
        ]);
        final renderResults = await engine.renderAll(
          parseResults,
          variables: {'age': '13'},
        );

        Should.satisfyAllConditions([
          () => renderResults.aggregatedErrorMessage.should.be(
            "Errors in: }}Hello {{name}}. \n"
            "  Parse error:\n"
            "    1:1 - Unexpected code block end delimiter `}}` without preceding start delimiter `{{`\n"
            "  Render error:\n"
            "    1:11 - Variable `name` does not exist\n"
            "Error in: Welcome in {{location}}.\n"
            "  Render error:\n"
            "    1:14 - Variable `location` does not exist",
          ),
          () => renderResults
              .map((r) => r.text)
              .join()
              .should
              .be('}}Hello {{ERROR}}. Welcome in {{ERROR}}.'),
        ]);
      },
    );
  });
}
