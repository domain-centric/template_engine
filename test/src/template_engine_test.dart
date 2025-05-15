import 'package:test/test.dart';
import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:petitparser/petitparser.dart';

void main() {
  group('TemplateEngine Tag Validation', () {
    test('should not throw when tag names are unique', () {
      Should.notThrowException(() => TemplateEngine(tags: [
            TestTag('name1'),
            TestTag('name2'),
          ]));
    });

    test('should throw when one tag name is duplicated', () {
      Should.throwException<TagException>(() => TemplateEngine(tags: [
                TestTag('name1'),
                TestTag('name2'),
                TestTag('name2'),
                TestTag('name3'),
              ]))!
          .message
          .should
          .be('Tag name: name2 is not unique');
    });

    test('should throw when two tag names are duplicated', () {
      Should.throwException<TagException>(() => TemplateEngine(tags: [
                TestTag('name1'),
                TestTag('name2'),
                TestTag('name2'),
                TestTag('name2'),
                TestTag('name3'),
              ]))!
          .message
          .should
          .be('Tag name: name2 is not unique');
    });

    test('should throw when multiple tag names are duplicated', () {
      Should.throwException<TagException>(() => TemplateEngine(tags: [
                TestTag('name1'),
                TestTag('name2'),
                TestTag('name2'),
                TestTag('name3'),
                TestTag('name4'),
                TestTag('name4'),
                TestTag('name4'),
                TestTag('name5'),
              ]))!
          .message
          .should
          .be('Tag names: name2, name4 are not unique');
    });
  });
}

class TestTag extends Tag {
  TestTag(String name)
      : super(
          name: name,
          description: ['Tag to test unique tag names'],
          exampleExpression: 'dummy',
          exampleCode: ProjectFilePath('dummy'),
        );

  @override
  Parser<Object> createTagParser(ParserContext context) {
    throw UnimplementedError();
  }

  @override
  List<String> createMarkdownExamples(
          RenderContext renderContext, int titleLevel) =>
      [];
}

class DummyTemplate extends TextTemplate {
  DummyTemplate() : super('Hello {{name}}.');
}
