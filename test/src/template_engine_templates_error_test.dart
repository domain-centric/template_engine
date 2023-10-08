import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  given('TemplateEngine', () {
    var engine = TemplateEngine();

    // with single parse error
    when(
        "engine.parseTemplates([TextTemplate('Hello '), "
        "TextTemplate('{{name}.')])", () {
      var parseResult = engine
          .parseTemplates([TextTemplate('Hello '), TextTemplate('{{name}.')]);
      var renderResult = engine.render(parseResult, {'name': 'world'});

      var expectedError = 'Parse error in: \'{{name}.\':\n'
          '  1:1: Found tag start: {{, but it was not followed with a tag end: }}';
      then('renderResult.errorMessage should be "$expectedError"', () {
        renderResult.errorMessage.should.be(expectedError);
      });
      var expectedText = 'Hello {{';
      then('renderResult.text should be "$expectedText"', () {
        renderResult.text.should.be(expectedText);
      });
    });

    // with multiple parse errors
    when(
        "engine.parseTemplates([TextTemplate('Hello '), "
        "TextTemplate('}}name{{.')])", () {
      var parseResult = engine
          .parseTemplates([TextTemplate('Hello '), TextTemplate('}}name{{.')]);
      var renderResult = engine.render(parseResult, {'name': 'world'});

      var expectedError = 'Parse errors in: \'}}name{{.\':\n'
          '  1:1: Found tag end: }}, but it was not preceded with a tag start: {{\n'
          '  1:7: Found tag start: {{, but it was not followed with a tag end: }}';
      then('renderResult.errorMessage should be "$expectedError"', () {
        renderResult.errorMessage.should.be(expectedError);
      });
      var expectedText = 'Hello }}name{{';
      then('renderResult.text should be "$expectedText"', () {
        renderResult.text.should.be(expectedText);
      });
    });

// with single render error
    when(
        "engine.parseTemplates([TextTemplate('Hello '), "
        "TextTemplate('{{name}}.')])", () {
      var parseResult = engine
          .parseTemplates([TextTemplate('Hello '), TextTemplate('{{name}}.')]);
      var renderResult = engine.render(parseResult, {'age': '13'});

      var expectedError = 'Render error in: \'{{name}}.\':\n'
          '  1:3: Variable does not exist: name';
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
        "engine.parseTemplates(["
        "TextTemplate('Hello {{name}}. '),"
        "TextTemplate('Welcome in {{location}}.')"
        "])", () {
      var parseResult = engine.parseTemplates([
        TextTemplate('Hello {{name}}. '),
        TextTemplate('Welcome in {{location}}.')
      ]);
      var renderResult = engine.render(parseResult, {'age': '13'});

      var expectedError = 'Render error in: \'Hello {{name}}. \':\n'
          '  1:9: Variable does not exist: name\n'
          'Render error in: \'Welcome in {{location}}.\':\n'
          '  1:14: Variable does not exist: location';
      then('renderResult.errorMessage should be "$expectedError"', () {
        renderResult.errorMessage.should.be(expectedError);
      });
      var expectedText = 'Hello {{ERROR}}. Welcome in {{ERROR}}.';
      then('renderResult.text should be "$expectedText"', () {
        renderResult.text.should.be(expectedText);
      });
    });

    // with multiple errors
    when(
        "engine.parseTemplates(["
        "TextTemplate('}}Hello {{name}}. '),"
        "TextTemplate('Welcome in {{location}}.')"
        "])", () {
      var parseResult = engine.parseTemplates([
        TextTemplate('}}Hello {{name}}. '),
        TextTemplate('Welcome in {{location}}.')
      ]);
      var renderResult = engine.render(parseResult, {'age': '13'});

      var expectedError = 'Errors in: \'}}Hello {{name}}. \':\n'
          '  Parse error:\n'
          '    1:1: Found tag end: }}, but it was not '
          'preceded with a tag start: {{\n'
          '  Render error:\n'
          '    1:11: Variable does not exist: name\n'
          'Render error in: \'Welcome in {{location}}.\':\n'
          '  1:14: Variable does not exist: location';
      then('renderResult.errorMessage should be "$expectedError"', () {
        renderResult.errorMessage.should.be(expectedError);
      });
      var expectedText = '}}Hello {{ERROR}}. Welcome in {{ERROR}}.';
      then('renderResult.text should be "$expectedText"', () {
        renderResult.text.should.be(expectedText);
      });
    });
  });
}
