import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:shouldly/shouldly.dart';
import 'package:template_engine/src/error.dart';
import 'package:template_engine/src/tag/tag_function.dart';
import 'package:template_engine/src/template.dart';
import 'package:template_engine/src/template_engine.dart';

void main() {
  given('a custom TagDefinition', () {
    var greetingTag = GreetingTag();
    var engine = TemplateEngine(tags: [greetingTag]);
    var template = TextTemplate('{{greeting}}');

    when('calling engine.parse()', () {
      var result = engine.parse(template);
      then('return 1 child"', () {
        result.nodes.length.should.be(1);
      });
      then('return 1 child of type String "${GreetingTag.text}"', () {
        result.nodes.first.should
            .beOfType<String>()
            .should
            .be(GreetingTag.text);
      });
    });
  });

  given('AttributeValue parser', () {
    var parser = attributeValueParser();
    var input = '-123e-1';
    when('calling parser.parse("$input")', () {
      var result = parser.parse(input);
      var expected = -12.3;

      then('result should have no failures',
          () => result.isFailure.should.beFalse());
      then('result.value should be: $expected',
          () => result.value.should.be(expected));
    });

    input = 'true';
    when('calling parser.parse("$input")', () {
      var result = parser.parse(input);
      var expected = true;

      then('result should have no failures',
          () => result.isFailure.should.beFalse());
      then('result.value should be: $expected',
          () => result.value.should.be(expected));
    });

    input = 'FALse';
    when('calling parser.parse("$input")', () {
      var result = parser.parse(input);
      var expected = false;

      then('result should have no failures',
          () => result.isFailure.should.beFalse());
      then('result.value should be: $expected',
          () => result.value.should.be(expected));
    });

    input = '"Hello"';
    when('calling parser.parse("$input")', () {
      var result = parser.parse(input);
      var expected = 'Hello';

      then('result should have no failures',
          () => result.isFailure.should.beFalse());
      then('result.value should be: $expected',
          () => result.value.should.be(expected));
    });

    input = "'Hello'";
    when('calling parser.parse("$input")', () {
      var result = parser.parse(input);
      var expected = 'Hello';

      then('result should have no failures',
          () => result.isFailure.should.beFalse());
      then('result.value should be: $expected',
          () => result.value.should.be(expected));
    });

    input = "bogus";
    when('calling parser.parse("$input")', () {
      var result = parser.parse(input);
      var expected = '"\\"" expected';

      then('result should have failures',
          () => result.isFailure.should.beTrue());
      then('result.message should be: $expected',
          () => result.message.should.be(expected));
    });
  });
}

class GreetingTag extends TagFunction<String> {
  static const String text = 'Hello world.';
  GreetingTag()
      : super(
          name: 'greeting',
          description: 'A that that shows a greeting',
        );

  @override
  String createParserResult(TemplateSource source, String attributes) => text;
}
