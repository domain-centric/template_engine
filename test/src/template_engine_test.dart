import 'package:petitparser/petitparser.dart';
import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  // See also other .._parser_test_files

  given('TemplateEngine with unique tag names', () {
    when('calling constructor', () {
      then('should not throw an exception', () {});
      Should.notThrowException(() => TemplateEngine(tags: [
            TestTag('name1'),
            TestTag('name2'),
          ]));
    });
  });

  given('TemplateEngine with 1 double tag name', () {
    when('calling constructor', () {
      then('should not throw an exception', () {});
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
  });

  given('TemplateEngine with 2 double same tag names', () {
    when('calling constructor', () {
      then('should not throw an exception', () {});
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
  });

  given('TemplateEngine with 2 double tag name', () {
    given('TemplateEngine with 1 double tag name', () {
      when('calling constructor', () {
        then('should not throw an exception', () {});
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
  });

  given('object: A RendererThatRegistersError and a TemplateEngine', () {
    var parseResult = ParserTreeThatRegistersError();
    var engine = TemplateEngine();

    when('call: render(parseResult)', () {
      var result = engine.render(parseResult);
      then('expect: 1 error', () {
        return result.errors.length.should.be(1);
      });

      var expected = 'Render Error: something went wrong, '
          'position: 1:4, source: Text';

      then('expect: an errorMessage: "$expected"', () {
        return result.errorMessage.should.be(expected);
      });
    });
  });
}

class TestTag extends Tag {
  TestTag(
    String name,
  ) : super(
            name: name,
            description: ['Tag to test unique tag names'],
            exampleExpression: 'dummy',
            exampleCode: ProjectFilePath('/dummy'));
  @override
  Parser<Object> createTagParser(ParserContext context) {
    throw UnimplementedError();
  }

  @override
  List<String> createMarkdownExamples(
          RenderContext renderContext, int titleLevel) =>
      [];
}

class ParserTreeThatRegistersError extends ParserTree {
  @override
  String render(RenderContext context) {
    var template = DummyTemplate();
    context.errors.add(Error.fromContext(
        stage: ErrorStage.render,
        context: Context(template.text, 3),
        message: 'something went wrong',
        template: template));
    return "";
  }
}

class DummyTemplate extends TextTemplate {
  DummyTemplate() : super('Hello {{name}}.');
}
