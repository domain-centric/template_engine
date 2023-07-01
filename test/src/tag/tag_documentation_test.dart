// TODO
// import 'package:shouldly/shouldly.dart';
// import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
// import 'package:template_engine/src/tag/tag_documentation.dart';
// import 'package:template_engine/template_engine.dart';

// import '../parser/tag/tag_function_test.dart';

void main() {
//   given('TagDocumentation', () {
//     var tagDocumentation = TagDocumentation();
//     var expectedRenderOfTagDocumentation = '# tag.documentation\n'
//         'Example: {{tag.documentation}}\n'
//         'Creates Markdown documentation for all the configured Tags.\n\n';

//     given('TagDocumentation parser', () {
//       var textTemplate = TextTemplate('{{${tagDocumentation.name}}}');
//       var context =
//           ParserContext(template: textTemplate, tags: [tagDocumentation]);
//       var parser = tagDocumentation.createTagParser(context);

//       when('calling parser.parse(textTemplate.text)', () {
//         var parseResult = parser.parse(textTemplate.text);
//         then('parseResult.isSuccess', () {
//           parseResult.isSuccess;
//         });

//         then('parseResult.value == "$expectedRenderOfTagDocumentation"', () {
//           parseResult.value.should.be(expectedRenderOfTagDocumentation);
//         });
//       });
//     });

//     given('TemplateEngine with TagDocumentation', () {
//       var templateEngine = TemplateEngine(tags: [tagDocumentation]);

//       var input = '{{tag.documentation}}';
//       when('calling templateEngine.parse("$input")', () {
//         var parseResult = templateEngine.parse(TextTemplate(input));
//         then('parse result should have no errors', () {
//           parseResult.errors.should.beEmpty();
//         });
//         then('parse result should contain 1 node', () {
//           parseResult.nodes.length.should.be(1);
//         });
//         then('parse result should contain a String', () {
//           parseResult.nodes.first.should.beOfType<String>();
//         });

//         when('calling templateEngine.render(parseResult)', () {
//           var renderResult = templateEngine.render(parseResult);
//           then('renderResult should have no errors', () {
//             renderResult.errors.should.beEmpty();
//           });

//           then(
//               'renderResult.text should be "$expectedRenderOfTagDocumentation"',
//               () {
//             renderResult.text.should.be(expectedRenderOfTagDocumentation);
//           });
//         });
//       });
//     });

//     given('TemplateEngine with TagDocumentation and test tag', () {
//       var attributeName1 = 'attribute1';
//       var attributeName2 = 'attribute2';
//       var attributeName3 = 'attribute3';
//       var attributeName4 = 'attribute4';
//       var testTag = AttributeTestTag([
//         Attribute(
//             name: attributeName1,
//             description: 'Description',
//             optional: true,
//             defaultValue: false),
//         Attribute(name: attributeName2, optional: true, defaultValue: false),
//         Attribute(name: attributeName3, optional: true),
//         Attribute(name: attributeName4),
//       ]);
//       var expectedRenderOfTestTag = '# test\n'
//           'Example: {{test}}\n'
//           'A tag for testing\n'
//           'Attributes:\n'
//           '* attribute1\n'
//           '  Description: Description\n'
//           '  Usage: optional\n'
//           '  Default value: false\n'
//           '* attribute2\n'
//           '  Usage: optional\n'
//           '  Default value: false\n'
//           '* attribute3\n'
//           '  Usage: optional\n'
//           '* attribute4\n'
//           '  Usage: mandatory\n\n';
//       var expected = expectedRenderOfTagDocumentation + expectedRenderOfTestTag;
//       var templateEngine = TemplateEngine(tags: [tagDocumentation, testTag]);

//       var input = '{{tag.documentation}}';
//       when('calling templateEngine.parse("$input")', () {
//         var parseResult = templateEngine.parse(TextTemplate(input));
//         then('parse result should have no errors', () {
//           parseResult.errors.should.beEmpty();
//         });
//         then('parse result should contain 1 node', () {
//           parseResult.nodes.length.should.be(1);
//         });
//         then('parse result should be: "$expected"', () {
//           parseResult.nodes.first.should.be(expected);
//         });

//         when('calling templateEngine.render(parseResult)', () {
//           var renderResult = templateEngine.render(parseResult);
//           then('renderResult should have no errors', () {
//             renderResult.errors.should.beEmpty();
//           });

//           then('renderResult.text should be "$expected"', () {
//             renderResult.text.should.be(expected);
//           });
//         });
//       });
//     });
//   });
}
