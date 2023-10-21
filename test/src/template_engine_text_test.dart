import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  given('TemplateEngine', () {
    var engine = TemplateEngine();
    when("calling: renderResult=engine.parseText('Hello {{name}}.')", () {
      var parseResult = engine.parseText('Hello {{name}}.');
      var renderResult = engine.render(parseResult, {'name': 'world'});

      then('renderResult.errorMessage should be empty', () {
        renderResult.errorMessage.should.beNullOrEmpty();
      });
      var expected = 'Hello world.';
      then('renderResult.text should be "$expected"', () {
        renderResult.text.should.be(expected);
      });
    });
  });
}