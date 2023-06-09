// import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
// import 'package:shouldly/shouldly.dart';
// import 'package:template_engine/template_engine.dart';
// TODO
void main() {
//   given('Attribute', () {
//     when('Calling constructor', () {
//       then('Should throw a AttributeException with a valid error message', () {
//         Should.throwException<AttributeException>(
//                 () => Attribute(name: 'inv@lid'))!
//             .message
//             .should
//             .be('Attribute name: "inv@lid" is invalid: end of input expected at position: 3');
//       });
//     });
//   });

//   given('AttributeValue parser', () {
//     var parser = attributeValueParser();
//     var input = '-123e-1';
//     when('calling parser.parse("$input")', () {
//       var result = parser.parse(input);
//       var expected = -12.3;

//       then('result should have no failures',
//           () => result.isFailure.should.beFalse());
//       then('result.value should be: $expected',
//           () => result.value.should.be(expected));
//     });

//     input = 'true';
//     when('calling parser.parse("$input")', () {
//       var result = parser.parse(input);
//       var expected = true;

//       then('result should have no failures',
//           () => result.isFailure.should.beFalse());
//       then('result.value should be: $expected',
//           () => result.value.should.be(expected));
//     });

//     input = 'FALse';
//     when('calling parser.parse("$input")', () {
//       var result = parser.parse(input);
//       var expected = false;

//       then('result should have no failures',
//           () => result.isFailure.should.beFalse());
//       then('result.value should be: $expected',
//           () => result.value.should.be(expected));
//     });

//     input = '"Hello"';
//     when('calling parser.parse("$input")', () {
//       var result = parser.parse(input);
//       var expected = 'Hello';

//       then('result should have no failures',
//           () => result.isFailure.should.beFalse());
//       then('result.value should be: $expected',
//           () => result.value.should.be(expected));
//     });

//     input = "'Hello'";
//     when('calling parser.parse("$input")', () {
//       var result = parser.parse(input);
//       var expected = 'Hello';

//       then('result should have no failures',
//           () => result.isFailure.should.beFalse());
//       then('result.value should be: $expected',
//           () => result.value.should.be(expected));
//     });

//     input = "bogus";
//     when('calling parser.parse("$input")', () {
//       var result = parser.parse(input);
//       var expected = '"\\"" expected';

//       then('result should have failures',
//           () => result.isFailure.should.beTrue());
//       then('result.message should be: $expected',
//           () => result.message.should.be(expected));
//     });
//   });

//   given('AttributeNameAndValueParser with attribute: attribute', () {
//     var parser = AttributeNameAndValueParser(Attribute(name: 'attribute'));

//     var input = 'attribute=-123e-1';
//     when('calling parser.parse("$input")', () {
//       var result = parser.parse(input);
//       var expected = 'whitespace expected';

//       then(
//           'result should be a failure', () => result.isFailure.should.beTrue());
//       then('result.value should be: $expected',
//           () => result.message.should.be(expected));
//     });

//     input = ' attribute =  -123e-1';
//     when('calling parser.parse("$input")', () {
//       var result = parser.parse(input);
//       var expected = -12.3;

//       then('result should have no failures',
//           () => result.isFailure.should.beFalse());
//       then('result.value should be: $expected',
//           () => result.value.should.be(expected));
//     });

//     input = '  attribute=true';
//     when('calling parser.parse("$input")', () {
//       var result = parser.parse(input);
//       var expected = true;

//       then('result should have no failures',
//           () => result.isFailure.should.beFalse());
//       then('result.value should be: $expected',
//           () => result.value.should.be(expected));
//     });

//     input = ' attribute  =FALse';
//     when('calling parser.parse("$input")', () {
//       var result = parser.parse(input);
//       var expected = false;

//       then('result should have no failures',
//           () => result.isFailure.should.beFalse());
//       then('result.value should be: $expected',
//           () => result.value.should.be(expected));
//     });

//     input = ' ATTRibute=   "Hello"';
//     when('calling parser.parse("$input")', () {
//       var result = parser.parse(input);
//       var expected = 'Hello';

//       then('result should have no failures',
//           () => result.isFailure.should.beFalse());
//       then('result.value should be: $expected',
//           () => result.value.should.be(expected));
//     });

//     input = " attribute  =   'Hello'   ";
//     when('calling parser.parse("$input")', () {
//       var result = parser.parse(input);
//       var expected = 'Hello';

//       then('result should have no failures',
//           () => result.isFailure.should.beFalse());
//       then('result.value should be: $expected',
//           () => result.value.should.be(expected));
//     });

//     input = " bogus=bogus";
//     when('calling parser.parse("$input")', () {
//       var result = parser.parse(input);
//       var expected = '"attribute" (case-insensitive) expected';

//       then('result should have failures',
//           () => result.isFailure.should.beTrue());
//       then('result.message should be: $expected',
//           () => result.message.should.be(expected));
//     });

//     input = " attribute";
//     when('calling parser.parse("$input")', () {
//       var result = parser.parse(input);
//       var expected = '"=" expected';

//       then('result should have failures',
//           () => result.isFailure.should.beTrue());
//       then('result.message should be: $expected',
//           () => result.message.should.be(expected));
//     });
//   });

//   given('AttributesParser()', () {
//     ParserContext context =
//         ParserContext(template: TextTemplate('dummy'), tags: []);
//     var parser = AttributesParser(
//         parserContext: context,
//         failsOnError: true,
//         attributes: [Attribute(name: 'attribute')]);
//     var input = "attribute='Hello'";
//     when('calling parser.parse("$input")', () {
//       var result = parser.parse(input);
//       String expected =
//           'Parse Error: Mandatory attribute: attribute is missing position: 1:1 source: Text';

//       then('result should have a failure',
//           () => result.isFailure.should.beTrue());
//       then('result.value should be: $expected',
//           () => result.message.should.be(expected));
//     });

//     input = " attribute1='Hello'";
//     when('calling parser.parse("$input")', () {
//       var result = parser.parse(input);

//       var expected =
//           'Parse Error: Mandatory attribute: attribute is missing position: 1:1 source: Text';
//       then(
//           'result should be a failure', () => result.isFailure.should.beTrue());
//       then('result.message should be: "$expected"',
//           () => result.message.should.be(expected));
//     });
//   });

//   given('an TemplateEngine with a GreetingTag', () {
//     var engine = TemplateEngine(tags: [GreetingTagWithAttribute()]);

//     var input = '{{greeting}}.';
//     when('calling: engine.parse(TextTemplate("$input"))', () {
//       var result = engine.parse(TextTemplate(input));

//       then('result.errors should be empty',
//           () => result.errors.should.beEmpty());
//       then('result should contain 2 nodes',
//           () => result.nodes.length.should.be(2));

//       then('result 1st node : "Hello world"',
//           () => result.nodes[0].should.be('Hello world'));

//       then('result 2nd node : "."', () => result.nodes[1].should.be('.'));
//     });

//     input = '{{greeting name= "Jane Doe" }}.';
//     when('calling: engine.parse(TextTemplate("$input"))', () {
//       var result = engine.parse(TextTemplate(input));

//       then('result.errors should be empty',
//           () => result.errors.should.beEmpty());
//       then('result should contain 2 node',
//           () => result.nodes.length.should.be(2));

//       then('result 1st node : "Hello Jane Doe"',
//           () => result.nodes[0].should.be('Hello Jane Doe'));
//       then('result 2nd node : "."', () => result.nodes[1].should.be('.'));
//     });

//     var inputTag1 =
//         '{{greeting name= "Jane Doe" invalidAttribute=invalidValue}}';
//     var input1 = '$inputTag1.';
//     when('calling: engine.parse(TextTemplate("$input1"))', () {
//       var parseResult = engine.parse(TextTemplate(input1));

//       then('result.errors should contain 1 error',
//           () => parseResult.errors.length.should.be(1));
//       String expected = 'Parse Error: Invalid attribute definition: '
//           'invalidAttribute=invalidValue position: 1:28 source: Text';
//       then('result.errorMessage should be "$expected"',
//           () => parseResult.errorMessage.should.be(expected));

//       then('result 1st node : "$inputTag1"',
//           () => parseResult.nodes[0].should.be(inputTag1));
//       then('result 2nd node : "."', () => parseResult.nodes[1].should.be('.'));
//     });

//     var inputTag2 =
//         '{{greeting name= "Jane Doe" invalidAttribute"invalidValue" }}';
//     var input2 = '$inputTag2.';
//     when('calling: engine.parse(TextTemplate("$input2"))', () {
//       var parseResult = engine.parse(TextTemplate(input2));

//       then('result.errors should contain 1 error',
//           () => parseResult.errors.length.should.be(1));

//       String expected = 'Parse Error: Invalid attribute definition: '
//           'invalidAttribute"invalidValue" position: 1:28 source: Text';
//       then('result.errorMessage should be "$expected"',
//           () => parseResult.errorMessage.should.be(expected));

//       then('result 1st node : "$inputTag2"',
//           () => parseResult.nodes[0].should.be(inputTag2));
//       then('result 2nd node : "."', () => parseResult.nodes[1].should.be('.'));
//     });
//   });

//   given('a TemplateEngine with an AttributeTestTag and one attribute', () {
//     var attributeName = 'testAttribute';
//     var engine = TemplateEngine(tags: [
//       AttributeTestTag([Attribute(name: attributeName)])
//     ]);

//     var input = '{{${AttributeTestTag.tagName}$attributeName=true}}';
//     when('calling engine.parse(TextTemplate("$input"))', () {
//       var result = engine.parse(TextTemplate(input));
//       then('result should have 1 error',
//           () => result.errors.length.should.be(1));

//       var expected = 'Parse Error: Invalid tag. position: 1:1 source: Text';
//       then('result.errorMessage should be: "$expected"',
//           () => result.errorMessage.should.be(expected));
//     });

//     input = '{{${AttributeTestTag.tagName} $attributeName=-123e-1}}';
//     when('calling engine.parse(TextTemplate("$input"))', () {
//       var result = engine.parse(TextTemplate(input));
//       var expected = {attributeName: -12.3};

//       then(
//           'result should have no errors', () => result.errors.should.beEmpty());
//       then('result should have 1 node', () => result.nodes.length.should.be(1));
//       then('result first node should be: "$expected"',
//           () => result.nodes.first.toString().should.be(expected.toString()));
//     });

//     input = '{{${AttributeTestTag.tagName}   $attributeName=true}}';
//     when('calling engine.parse(TextTemplate("$input"))', () {
//       var result = engine.parse(TextTemplate(input));
//       var expected = {attributeName: true};

//       then(
//           'result should have no errors', () => result.errors.should.beEmpty());
//       then('result should have 1 node', () => result.nodes.length.should.be(1));
//       then('result first node should be: "$expected"',
//           () => result.nodes.first.toString().should.be(expected.toString()));
//     });

//     input = '{{${AttributeTestTag.tagName} $attributeName  =FALse}}';
//     when('calling engine.parse(TextTemplate("$input"))', () {
//       var result = engine.parse(TextTemplate(input));
//       var expected = {attributeName: false};

//       then(
//           'result should have no errors', () => result.errors.should.beEmpty());
//       then('result should have 1 node', () => result.nodes.length.should.be(1));
//       then('result first node should be: "$expected"',
//           () => result.nodes.first.toString().should.be(expected.toString()));
//     });

//     input = '{{${AttributeTestTag.tagName} $attributeName=   "Hello"}}';
//     when('calling engine.parse(TextTemplate("$input"))', () {
//       var result = engine.parse(TextTemplate(input));
//       var expected = {attributeName: 'Hello'};

//       then(
//           'result should have no errors', () => result.errors.should.beEmpty());
//       then('result should have 1 node', () => result.nodes.length.should.be(1));
//       then('result first node should be: "$expected"',
//           () => result.nodes.first.toString().should.be(expected.toString()));
//     });

//     input = '{{${AttributeTestTag.tagName} $attributeName="Hello"}}     ';
//     when('calling engine.parse(TextTemplate("$input"))', () {
//       var result = engine.parse(TextTemplate(input));

//       then(
//           'result should have no errors', () => result.errors.should.beEmpty());
//       then(
//           'result should have 2 nodes', () => result.nodes.length.should.be(2));

//       var expected = {attributeName: 'Hello'};
//       then('result 1st node should be: "$expected"',
//           () => result.nodes[0].toString().should.be(expected.toString()));

//       then('result 2nd node should be: "     "',
//           () => result.nodes[1].should.be('     '));
//     });

//     input =
//         '{{${AttributeTestTag.tagName}   $attributeName =  "Hello"        }}';
//     when('calling engine.parse(TextTemplate("$input"))', () {
//       var result = engine.parse(TextTemplate(input));
//       var expected = {attributeName: 'Hello'};

//       then(
//           'result should have no errors', () => result.errors.should.beEmpty());
//       then('result should have 2 node', () => result.nodes.length.should.be(1));
//       then('result first node should be: "$expected"',
//           () => result.nodes.first.toString().should.be(expected.toString()));
//     });
//   });

//   given('a TemplateEngine with an AttributeTestTag and multiple attributes',
//       () {
//     var attributeName1 = 'attribute1';
//     var attributeName2 = 'attribute2';
//     var attributeName3 = 'attribute3';
//     var test = "Test";
//     var engine = TemplateEngine(tags: [
//       AttributeTestTag([
//         Attribute(name: attributeName1),
//         Attribute(name: attributeName2),
//         Attribute(name: attributeName3),
//       ])
//     ]);

//     var input =
//         '{{${AttributeTestTag.tagName} $attributeName1=true$attributeName2="$test"}}';
//     when('calling engine.parse(TextTemplate("$input"))', () {
//       var result = engine.parse(TextTemplate(input));
//       then('result should have 1 error',
//           () => result.errors.length.should.be(1));

//       var expected = 'Parse Error: Invalid tag. position: 1:1 source: Text';
//       then('result.errorMessage should be: "$expected"',
//           () => result.errorMessage.should.be(expected));
//     });

//     input =
//         '{{${AttributeTestTag.tagName} $attributeName1=true $attributeName3="$test"}}';
//     when('calling engine.parse(TextTemplate("$input"))', () {
//       var result = engine.parse(TextTemplate(input));
//       then('result should have 1 error',
//           () => result.errors.length.should.be(1));

//       var expected =
//           'Parse Error: Mandatory attribute: attribute2 is missing position: 1:41 source: Text';
//       then('result.errorMessage should be: "$expected"',
//           () => result.errorMessage.should.be(expected));
//     });

//     input = '{{${AttributeTestTag.tagName}  $attributeName3="$test"}}';
//     when('calling engine.parse(TextTemplate("$input"))', () {
//       var result = engine.parse(TextTemplate(input));
//       then('result should have 1 error',
//           () => result.errors.length.should.be(1));

//       var expected = 'Parse Error: Mandatory attributes: '
//           'attribute1, attribute2 are missing position: 1:26 source: Text';
//       then('result.errorMessage should be: "$expected"',
//           () => result.errorMessage.should.be(expected));
//     });
//     input =
//         '{{${AttributeTestTag.tagName} $attributeName2="$test" $attributeName1=false}}';
//     when('calling engine.parse(TextTemplate("$input"))', () {
//       var result = engine.parse(TextTemplate(input));
//       then('result should have 1 error',
//           () => result.errors.length.should.be(1));

//       var expected =
//           'Parse Error: Mandatory attribute: attribute3 is missing position: 1:42 source: Text';
//       then('result.errorMessage should be: "$expected"',
//           () => result.errorMessage.should.be(expected));
//     });

//     input =
//         '{{${AttributeTestTag.tagName}  $attributeName3=-123e-1 $attributeName1=false   }}';
//     when('calling engine.parse(TextTemplate("$input"))', () {
//       var result = engine.parse(TextTemplate(input));
//       then('result should have 1 error',
//           () => result.errors.length.should.be(1));

//       var expected =
//           'Parse Error: Mandatory attribute: attribute2 is missing position: 1:44 source: Text';
//       then('result.errorMessage should be: "$expected"',
//           () => result.errorMessage.should.be(expected));
//     });

//     input =
//         '{{${AttributeTestTag.tagName} $attributeName3=-123e-1 $attributeName2="$test"   $attributeName1=false      }}';
//     when('calling engine.parse(TextTemplate("$input"))', () {
//       var result = engine.parse(TextTemplate(input));
//       var expected = {
//         attributeName3: -12.3,
//         attributeName2: test,
//         attributeName1: false,
//       };

//       then(
//           'result should have no errors', () => result.errors.should.beEmpty());
//       then('result should have 1 node', () => result.nodes.length.should.be(1));
//       then('result first node should be: "$expected"',
//           () => result.nodes.first.toString().should.be(expected.toString()));
//     });
//   });

//   given('a TemplateEngine with an AttributeTestTag and multiple attributes',
//       () {
//     var attributeName1 = 'attribute1';
//     var attributeName2 = 'attribute2';
//     var attributeName3 = 'attribute3';
//     var attributeName4 = 'attribute4';
//     var test = "Test";
//     var engine = TemplateEngine(tags: [
//       AttributeTestTag([
//         Attribute(name: attributeName1, optional: true, defaultValue: false),
//         Attribute(name: attributeName2, optional: true),
//         Attribute(name: attributeName3),
//         Attribute(name: attributeName4),
//       ])
//     ]);

//     var input =
//         '{{${AttributeTestTag.tagName} $attributeName1=true$attributeName2="$test"}}';
//     when('calling engine.parse(TextTemplate("$input"))', () {
//       var result = engine.parse(TextTemplate(input));
//       then('result should have 1 error',
//           () => result.errors.length.should.be(1));

//       var expected = 'Parse Error: Invalid tag. position: 1:1 source: Text';
//       then('result.errorMessage should be: "$expected"',
//           () => result.errorMessage.should.be(expected));
//     });

//     input =
//         '{{${AttributeTestTag.tagName} $attributeName1=true $attributeName3="$test"}}';
//     when('calling engine.parse(TextTemplate("$input"))', () {
//       var result = engine.parse(TextTemplate(input));
//       then('result should have 1 error',
//           () => result.errors.length.should.be(1));

//       var expected = 'Parse Error: Mandatory attribute: attribute4 is '
//           'missing position: 1:41 source: Text';
//       then('result.errorMessage should be: "$expected"',
//           () => result.errorMessage.should.be(expected));
//     });

//     input =
//         '{{${AttributeTestTag.tagName} $attributeName2="$test" $attributeName1=false}}';
//     when('calling engine.parse(TextTemplate("$input"))', () {
//       var result = engine.parse(TextTemplate(input));
//       then('result should have 1 error',
//           () => result.errors.length.should.be(1));

//       var expected = 'Parse Error: Mandatory attributes: attribute3, '
//           'attribute4 are missing position: 1:42 source: Text';
//       then('result.errorMessage should be: "$expected"',
//           () => result.errorMessage.should.be(expected));
//     });

//     input =
//         '{{${AttributeTestTag.tagName}  $attributeName3=-123e-1 $attributeName1=false   }}';
//     when('calling engine.parse(TextTemplate("$input"))', () {
//       var result = engine.parse(TextTemplate(input));
//       then('result should have 1 error',
//           () => result.errors.length.should.be(1));

//       var expected =
//           'Parse Error: Mandatory attribute: attribute4 is missing position: 1:44 source: Text';
//       then('result.errorMessage should be: "$expected"',
//           () => result.errorMessage.should.be(expected));
//     });

//     input =
//         '{{${AttributeTestTag.tagName} $attributeName3=-123e-1    $attributeName1=true    $attributeName4="$test"  }}';
//     when('calling engine.parse(TextTemplate("$input"))', () {
//       var result = engine.parse(TextTemplate(input));
//       var expected = {
//         attributeName3: -12.3,
//         attributeName1: true,
//         attributeName4: test,
//       };

//       then(
//           'result should have no errors', () => result.errors.should.beEmpty());
//       then('result should have 1 node', () => result.nodes.length.should.be(1));
//       then('result first node should be: "$expected"',
//           () => result.nodes.first.toString().should.be(expected.toString()));
//     });

//     input =
//         '{{${AttributeTestTag.tagName} $attributeName3=-123e-1    $attributeName2=true    $attributeName4="$test"  }}';
//     when('calling engine.parse(TextTemplate("$input"))', () {
//       var result = engine.parse(TextTemplate(input));
//       var expected = {
//         attributeName3: -12.3,
//         attributeName2: true,
//         attributeName4: test,
//         attributeName1: false,
//       };

//       then(
//           'result should have no errors', () => result.errors.should.beEmpty());
//       then('result should have 1 node', () => result.nodes.length.should.be(1));
//       then('result first node should be: "$expected"',
//           () => result.nodes.first.toString().should.be(expected.toString()));
//     });
//   });
// }

// class GreetingTagWithAttribute extends TagFunction<String> {
//   GreetingTagWithAttribute()
//       : super(
//             name: 'greeting',
//             description: 'A tag that shows a greeting',
//             attributeDefinitions: [
//               Attribute(
//                 name: 'name',
//                 optional: true,
//                 defaultValue: 'world',
//               )
//             ]);

//   @override
//   String createParserResult(
//           {required ParserContext context,
//           required TemplateSource source,
//           required Map<String, Object> attributes}) =>
//       'Hello ${attributes['name']}';
// }

// class AttributeTestTag extends TagFunction<Map<String, Object>> {
//   static const tagName = 'test';

//   AttributeTestTag(List<Attribute> attributes)
//       : super(
//             name: tagName,
//             description: 'A tag for testing',
//             attributeDefinitions: attributes);

//   @override
//   Map<String, Object> createParserResult(
//           {required ParserContext context,
//           required TemplateSource source,
//           required Map<String, Object> attributes}) =>
//       attributes;
}
