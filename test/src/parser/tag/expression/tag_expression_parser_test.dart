import 'package:template_engine/src/parser/tag/expression/tag_expression_parser.dart';
import 'package:template_engine/src/template.dart';
import 'package:template_engine/src/template_engine.dart';
import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';

void main() {
  given('a TemplateEngine and ExpressionTag().example(engine)', () {
    var engine = TemplateEngine();
    var examples = ExpressionTag().examples(engine);

    when('calling: engine.parse(TextTemplate("${examples.first}"))', () {
      var parseResult = engine.parse(TextTemplate(examples.first));

      then('parseResult.errorMessage should be Null Or Empty', () {
        parseResult.errorMessage.should.beNullOrEmpty();
      });
      when("calling: engine.render(parseResult)", () {
        var renderResult = engine.render(parseResult);

        var expected = 'The cos of 2 pi = 1.0.';
        then('renderResult.text should be: $expected', () {
          renderResult.text.should.be(expected);
        });
      });
    });

    when('calling: engine.parse(TextTemplate("${examples.last}"))', () {
      var parseResult = engine.parse(TextTemplate(examples.last));

      then('parseResult.errorMessage should be Null Or Empty', () {
        parseResult.errorMessage.should.beNullOrEmpty();
      });
      when("calling: engine.render(parseResult,{'radius': 10})", () {
        var renderResult = engine.render(parseResult, {'radius': 10});

        var expected = 'The volume of a sphere = 2356.194490192345.';
        then('renderResult.text should be: $expected', () {
          renderResult.text.should.be(expected);
        });
      });
    });
  });
}
