import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  given('TemplateEngine', () {
    var engine = TemplateEngine();

    var helloNameWithInvalidEndBrace = 'Hello {{name}.';
    // with single parse error
    when("calling: await engine.parseText('$helloNameWithInvalidEndBrace')",
        () {
      var expectedError = 'Parse error in: \'Hello {{name}.\':\n'
          '  1:7: Found tag start: {{, but it was not followed with a tag end: }}';
      then('renderResult.errorMessage should be "$expectedError"', () async {
        var parseResult = await engine.parseText(helloNameWithInvalidEndBrace);
        var renderResult = await engine.render(parseResult, {'name': 'world'});
        renderResult.errorMessage.should.be(expectedError);
      });
      var expectedText = 'Hello {{';
      then('renderResult.text should be "$expectedText"', () async {
        var parseResult = await engine.parseText(helloNameWithInvalidEndBrace);
        var renderResult = await engine.render(parseResult, {'name': 'world'});
        renderResult.text.should.be(expectedText);
      });
    });

    var halloNameWithInvalidBraces = 'Hello }}name{{.';
    // with multiple parse errors
    when("calling: engine.parseText('$halloNameWithInvalidBraces')", () {
      var expectedError = 'Parse errors in: \'Hello }}name{{.\':\n'
          '  1:7: Found tag end: }}, but it was not preceded with a tag start: {{\n'
          '  1:13: Found tag start: {{, but it was not followed with a tag end: }}';
      then('renderResult.errorMessage should be "$expectedError"', () async {
        var parseResult = await engine.parseText(halloNameWithInvalidBraces);
        var renderResult = await engine.render(parseResult, {'name': 'world'});
        renderResult.errorMessage.should.be(expectedError);
      });
      var expectedText = 'Hello }}name{{';
      then('renderResult.text should be "$expectedText"', () async {
        var parseResult = await engine.parseText(halloNameWithInvalidBraces);
        var renderResult = await engine.render(parseResult, {'name': 'world'});
        renderResult.text.should.be(expectedText);
      });
    });

    var helloName = 'Hello {{name}}.';
    // with single render error
    when("calling: await engine.parseText('$helloName')", () {
      var expectedError = 'Render error in: \'Hello {{name}}.\':\n'
          '  1:9: Variable does not exist: name';
      then('renderResult.errorMessage should be "$expectedError"', () async {
        var parseResult = await engine.parseText(helloName);
        var renderResult = await engine.render(parseResult, {'age': '13'});
        renderResult.errorMessage.should.be(expectedError);
      });
      var expectedText = 'Hello {{ERROR}}.';
      then('renderResult.text should be "$expectedText"', () async {
        var parseResult = await engine.parseText(helloName);
        var renderResult = await engine.render(parseResult, {'age': '13'});
        renderResult.text.should.be(expectedText);
      });
    });

    var inputWithTwoVariables = 'Hello {{name}}. Welcome in {{location}}.';
    // with multiple render errors
    when("await engine.parseText('$inputWithTwoVariables')", () {
      var expectedError =
          'Render errors in: \'Hello {{name}}. Welcome in {{location}}.\':\n'
          '  1:9: Variable does not exist: name\n'
          '  1:30: Variable does not exist: location';
      then('renderResult.errorMessage should be "$expectedError"', () async {
        var parseResult = await engine.parseText(inputWithTwoVariables);
        var renderResult = await engine.render(parseResult, {'age': '13'});
        renderResult.errorMessage.should.be(expectedError);
      });
      var expectedText = 'Hello {{ERROR}}. Welcome in {{ERROR}}.';
      then('renderResult.text should be "$expectedText"', () async {
        var parseResult = await engine.parseText(inputWithTwoVariables);
        var renderResult = await engine.render(parseResult, {'age': '13'});
        renderResult.text.should.be(expectedText);
      });
    });
  });
}
