import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  given('Attribute', () {
    when('Calling constructor', () {
      then('Should throw a AttributeException with a valid error message', () {
        Should.throwException<AttributeException>(
                () => Attribute(name: 'inv@lid'))!
            .message
            .should
            .be('Attribute name: "inv@lid" is invalid: end of input expected at position: 3');
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

  given('AttributeNameAndValueParser with attribute: attribute', () {
    var parser = AttributeNameAndValueParser(Attribute(name: 'attribute'));

    var input = 'attribute=-123e-1';
    when('calling parser.parse("$input")', () {
      var result = parser.parse(input);
      var expected = 'whitespace expected';

      then(
          'result should be a failure', () => result.isFailure.should.beTrue());
      then('result.value should be: $expected',
          () => result.message.should.be(expected));
    });

    input = ' attribute =  -123e-1';
    when('calling parser.parse("$input")', () {
      var result = parser.parse(input);
      var expected = -12.3;

      then('result should have no failures',
          () => result.isFailure.should.beFalse());
      then('result.value should be: $expected',
          () => result.value.should.be(expected));
    });

    input = '  attribute=true';
    when('calling parser.parse("$input")', () {
      var result = parser.parse(input);
      var expected = true;

      then('result should have no failures',
          () => result.isFailure.should.beFalse());
      then('result.value should be: $expected',
          () => result.value.should.be(expected));
    });

    input = ' attribute  =FALse';
    when('calling parser.parse("$input")', () {
      var result = parser.parse(input);
      var expected = false;

      then('result should have no failures',
          () => result.isFailure.should.beFalse());
      then('result.value should be: $expected',
          () => result.value.should.be(expected));
    });

    input = ' ATTRibute=   "Hello"';
    when('calling parser.parse("$input")', () {
      var result = parser.parse(input);
      var expected = 'Hello';

      then('result should have no failures',
          () => result.isFailure.should.beFalse());
      then('result.value should be: $expected',
          () => result.value.should.be(expected));
    });

    input = " attribute  =   'Hello'   ";
    when('calling parser.parse("$input")', () {
      var result = parser.parse(input);
      var expected = 'Hello';

      then('result should have no failures',
          () => result.isFailure.should.beFalse());
      then('result.value should be: $expected',
          () => result.value.should.be(expected));
    });

    input = " bogus=bogus";
    when('calling parser.parse("$input")', () {
      var result = parser.parse(input);
      var expected = '"attribute" (case-insensitive) expected';

      then('result should have failures',
          () => result.isFailure.should.beTrue());
      then('result.message should be: $expected',
          () => result.message.should.be(expected));
    });

    input = " attribute";
    when('calling parser.parse("$input")', () {
      var result = parser.parse(input);
      var expected = '"=" expected';

      then('result should have failures',
          () => result.isFailure.should.beTrue());
      then('result.message should be: $expected',
          () => result.message.should.be(expected));
    });
  });

  given('AttributesParser()', () {
    var parser = AttributesParser([Attribute(name: 'attribute')]);
    var input = "attribute='Hello'";
    when('calling parser.parse("$input")', () {
      var result = parser.parse(input);
      String expected = 'Mandatory attribute: attribute is missing';

      then('result should have a failure',
          () => result.isFailure.should.beTrue());
      then('result.value should be: $expected',
          () => result.message.should.be(expected));
    });

    input = " attribute1='Hello'";
    when('calling parser.parse("$input")', () {
      var result = parser.parse(input);
      var expected = 'Mandatory attribute: attribute is missing';

      then(
          'result should be a failure', () => result.isFailure.should.beTrue());
      then('result.message should be: "$expected"',
          () => result.message.should.be(expected));
    });
  });

  given('an TemplateEngine with a GreetingTag', () {
    var engine = TemplateEngine(tags: [GreetingTagWithAttribute()]);

    var input = '{{greeting}}.';
    when('calling: engine.parse(TextTemplate("$input"))', () {
      var result = engine.parse(TextTemplate(input));

      then('result.errors should be empty',
          () => result.errors.should.beEmpty());
      then('result should contain 2 nodes',
          () => result.nodes.length.should.be(2));

      then('result 1st node : "Hello world"',
          () => result.nodes[0].should.be('Hello world'));

      then('result 2nd node : "."', () => result.nodes[1].should.be('.'));
    });

    input = '{{greeting name= "Jane Doe" }}.';
    when('calling: engine.parse(TextTemplate("$input"))', () {
      var result = engine.parse(TextTemplate(input));

      then('result.errors should be empty',
          () => result.errors.should.beEmpty());
      then('result should contain 2 node',
          () => result.nodes.length.should.be(2));

      then('result 1st node : "Hello Jane Doe"',
          () => result.nodes[0].should.be('Hello Jane Doe'));
      then('result 2nd node : "."', () => result.nodes[1].should.be('.'));
    });
  });

  given('a TemplateEngine with an AttributeTestTag', () {
    var engine = TemplateEngine(tags: [AttributeTestTag()]);

    var input =
        '{{${AttributeTestTag.tagName}${AttributeTestTag.attributeName}=true}}';
    when('calling engine.parse(TextTemplate("$input"))', () {
      var result = engine.parse(TextTemplate(input));
      var expected =
          'Parse Error: Unknown tag or variable. position: 1:1 source: Text';

      then('result should have 1 error',
          () => result.errors.length.should.be(1));
      then('result.errorMessage should be: "$expected"',
          () => result.errorMessage.should.be(expected));
    });

    input =
        '{{${AttributeTestTag.tagName} ${AttributeTestTag.attributeName}=-123e-1}}';
    when('calling engine.parse(TextTemplate("$input"))', () {
      var result = engine.parse(TextTemplate(input));
      var expected = -12.3;

      then(
          'result should have no errors', () => result.errors.should.beEmpty());
      then('result should have 1 node', () => result.nodes.length.should.be(1));
      then('result first node should be: "$expected"',
          () => result.nodes.first.should.be(expected.toString()));
    });

    input =
        '{{${AttributeTestTag.tagName}   ${AttributeTestTag.attributeName}=true}}';
    when('calling engine.parse(TextTemplate("$input"))', () {
      var result = engine.parse(TextTemplate(input));
      var expected = 'true';

      then(
          'result should have no errors', () => result.errors.should.beEmpty());
      then('result should have 1 node', () => result.nodes.length.should.be(1));
      then('result first node should be: "$expected"',
          () => result.nodes.first.should.be(expected));
    });

    input =
        '{{${AttributeTestTag.tagName} ${AttributeTestTag.attributeName}  =FALse}}';
    when('calling engine.parse(TextTemplate("$input"))', () {
      var result = engine.parse(TextTemplate(input));
      var expected = 'false';

      then(
          'result should have no errors', () => result.errors.should.beEmpty());
      then('result should have 1 node', () => result.nodes.length.should.be(1));
      then('result first node should be: "$expected"',
          () => result.nodes.first.should.be(expected));
    });

    input =
        '{{${AttributeTestTag.tagName} ${AttributeTestTag.attributeName}=   "Hello"}}';
    when('calling engine.parse(TextTemplate("$input"))', () {
      var result = engine.parse(TextTemplate(input));
      var expected = 'Hello';

      then(
          'result should have no errors', () => result.errors.should.beEmpty());
      then('result should have 1 node', () => result.nodes.length.should.be(1));
      then('result first node should be: "$expected"',
          () => result.nodes.first.should.be(expected));
    });

    input =
        '{{${AttributeTestTag.tagName} ${AttributeTestTag.attributeName}="Hello"}}     ';
    when('calling engine.parse(TextTemplate("$input"))', () {
      var result = engine.parse(TextTemplate(input));

      then(
          'result should have no errors', () => result.errors.should.beEmpty());
      then(
          'result should have 2 nodes', () => result.nodes.length.should.be(2));

      then('result 1st node should be: "Hello"',
          () => result.nodes[0].should.be('Hello'));

      then('result 2nd node should be: "     "',
          () => result.nodes[1].should.be('     '));
    });

    input =
        '{{${AttributeTestTag.tagName}   ${AttributeTestTag.attributeName} =  "Hello"        }}';
    when('calling engine.parse(TextTemplate("$input"))', () {
      var result = engine.parse(TextTemplate(input));
      var expected = 'Hello';

      then(
          'result should have no errors', () => result.errors.should.beEmpty());
      then('result should have 2 node', () => result.nodes.length.should.be(1));
      then('result first node should be: "$expected"',
          () => result.nodes.first.should.be(expected));
    });
  });
}

class GreetingTagWithAttribute extends TagFunction<String> {
  GreetingTagWithAttribute()
      : super(
            name: 'greeting',
            description: 'A tag that shows a greeting',
            attributeDefinitions: [
              Attribute(
                name: 'name',
                optional: true,
                defaultValue: 'world',
              )
            ]);

  @override
  String createParserResult(
          TemplateSource source, Map<String, Object> attributes) =>
      'Hello ${attributes['name']}';
}

class AttributeTestTag extends TagFunction<String> {
  static const tagName = 'test';
  static const attributeName = 'testAttribute';

  AttributeTestTag()
      : super(
            name: tagName,
            description: 'A tag for testing',
            attributeDefinitions: [Attribute(name: attributeName)]);

  @override
  String createParserResult(
      TemplateSource source, Map<String, Object> attributes) {
    return attributes[attributeName].toString();
  }
}
