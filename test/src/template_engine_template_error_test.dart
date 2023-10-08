import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  given('TemplateEngine', () {
    var engine = TemplateEngine();

    // with single parse error
    when("engine.parseTemplate(TextTemplate('Hello {{name}.'))", () {
      var parseResult = engine.parseTemplate(TextTemplate('Hello {{name}.'));
      var renderResult = engine.render(parseResult, {'name': 'world'});

      var expectedError = 'Parse error in: \'Hello {{name}.\':\n'
          '  1:7: Found tag start: {{, but it was not followed with a tag end: }}';
      then('renderResult.errorMessage should be "$expectedError"', () {
        renderResult.errorMessage.should.be(expectedError);
      });
      var expectedText = 'Hello {{';
      then('renderResult.text should be "$expectedText"', () {
        renderResult.text.should.be(expectedText);
      });
    });

    // with multiple parse errors
    when("engine.parseTemplate(TextTemplate('Hello }}name{{.'))", () {
      var parseResult = engine.parseTemplate(TextTemplate('Hello }}name{{.'));
      var renderResult = engine.render(parseResult, {'name': 'world'});

      var expectedError = 'Parse errors in: \'Hello }}name{{.\':\n'
          '  1:7: Found tag end: }}, but it was not preceded with a tag start: {{\n'
          '  1:13: Found tag start: {{, but it was not followed with a tag end: }}';
      then('renderResult.errorMessage should be "$expectedError"', () {
        renderResult.errorMessage.should.be(expectedError);
      });
      var expectedText = 'Hello }}name{{';
      then('renderResult.text should be "$expectedText"', () {
        renderResult.text.should.be(expectedText);
      });
    });

    // with single render error
    when("calling: engine.parseTemplate(TextTemplate('Hello {{name}}.'))", () {
      var parseResult = engine.parseTemplate(TextTemplate('Hello {{name}}.'));
      var renderResult = engine.render(parseResult, {'age': '13'});

      var expectedError = 'Render error in: \'Hello {{name}}.\':\n'
          '  1:9: Variable does not exist: name';
      then('renderResult.errorMessage should be "$expectedError"', () {
        renderResult.errorMessage.should.be(expectedError);
      });
      var expectedText = 'Hello {{ERROR}}.';
      then('renderResult.text should be "$expectedText"', () {
        renderResult.text.should.be(expectedText);
      });
    });

    // with multiple render errors
    when(
        "engine.parseTemplate(TextTemplate("
        "'Hello {{name}}. Welcome in {{location}}.'))", () {
      var parseResult = engine.parseTemplate(
          TextTemplate('Hello {{name}}. Welcome in {{location}}.'));
      var renderResult = engine.render(parseResult, {'age': '13'});

      var expectedError =
          'Render errors in: \'Hello {{name}}. Welcome in {{location}}.\':\n'
          '  1:9: Variable does not exist: name\n'
          '  1:30: Variable does not exist: location';
      then('renderResult.errorMessage should be "$expectedError"', () {
        renderResult.errorMessage.should.be(expectedError);
      });
      var expectedText = 'Hello {{ERROR}}. Welcome in {{ERROR}}.';
      then('renderResult.text should be "$expectedText"', () {
        renderResult.text.should.be(expectedText);
      });
    });
  });
}
