import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  given('TemplateEngine', () {
    var engine = TemplateEngine();
    var input1 = 'Hello {{name}.';
    // with single parse error
    when("await engine.parseText('$input1')", () {
      var expectedError = 'Parse error in: \'Hello {{name}.\':\n'
          '  1:7: Found tag start: {{, but it was not followed with a tag end: }}';
      then('renderResult.errorMessage should be "$expectedError"', () async {
        var parseResult = await engine.parseText(input1);
        var renderResult = await engine.render(parseResult, {'name': 'world'});
        renderResult.errorMessage.should.be(expectedError);
      });
      var expectedText = 'Hello {{';
      then('renderResult.text should be "$expectedText"', () async {
        var parseResult = await engine.parseText(input1);
        var renderResult = await engine.render(parseResult, {'name': 'world'});
        renderResult.text.should.be(expectedText);
      });
    });

    var input2 = 'Hello }}name{{.';
    // with multiple parse errors
    when("await engine.parseText('$input2')", () {
      var expectedError = 'Parse errors in: \'Hello }}name{{.\':\n'
          '  1:7: Found tag end: }}, but it was not preceded with a tag start: {{\n'
          '  1:13: Found tag start: {{, but it was not followed with a tag end: }}';
      then('renderResult.errorMessage should be "$expectedError"', () async {
        var parseResult = await engine.parseText(input2);

        var renderResult = await engine.render(parseResult, {'name': 'world'});
        renderResult.errorMessage.should.be(expectedError);
      });
      var expectedText = 'Hello }}name{{';
      then('renderResult.text should be "$expectedText"', () async {
        var parseResult = await engine.parseText(input2);

        var renderResult = await engine.render(parseResult, {'name': 'world'});
        renderResult.text.should.be(expectedText);
      });
    });

    var input3 = 'Hello {{name}}.';
    // with single render error
    when("calling: await engine.parseText('$input3')", () {
      var expectedError = 'Render error in: \'Hello {{name}}.\':\n'
          '  1:9: Variable does not exist: name';
      then('renderResult.errorMessage should be "$expectedError"', () async {
        var parseResult = await engine.parseText(input3);
        var renderResult = await engine.render(parseResult, {'age': '13'});
        renderResult.errorMessage.should.be(expectedError);
      });
      var expectedText = 'Hello {{ERROR}}.';
      then('renderResult.text should be "$expectedText"', () async {
        var parseResult = await engine.parseText(input3);
        var renderResult = await engine.render(parseResult, {'age': '13'});
        renderResult.text.should.be(expectedText);
      });
    });

    var input4 = 'Hello {{name}}. Welcome in {{location}}.';
    // with multiple render errors
    when("await engine.parseText('$input4'))", () {
      var expectedError =
          'Render errors in: \'Hello {{name}}. Welcome in {{location}}.\':\n'
          '  1:9: Variable does not exist: name\n'
          '  1:30: Variable does not exist: location';
      then('renderResult.errorMessage should be "$expectedError"', () async {
        var parseResult = await engine.parseText(input4);
        var renderResult = await engine.render(parseResult, {'age': '13'});
        renderResult.errorMessage.should.be(expectedError);
      });
      var expectedText = 'Hello {{ERROR}}. Welcome in {{ERROR}}.';
      then('renderResult.text should be "$expectedText"', () async {
        var parseResult = await engine.parseText(input4);
        var renderResult = await engine.render(parseResult, {'age': '13'});
        renderResult.text.should.be(expectedText);
      });
    });
  });
}
