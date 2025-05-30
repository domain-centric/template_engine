import 'package:test/test.dart';
import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:petitparser/src/core/parser.dart';

void main() {
  group('TagName.validate', () {
    test('should not throw for valid names', () {
      Should.satisfyAllConditions([
        () => Should.notThrowError(() => TagName.validate('a')),
        () => Should.notThrowError(() => TagName.validate('ab')),
        () => Should.notThrowError(() => TagName.validate('a1')),
        () => Should.notThrowError(() => TagName.validate('a11')),
      ]);
    });

    test('should throw for invalid name "1"', () {
      Should.throwException<TagException>(() => TagName.validate('1'))!
          .message
          .should
          .be('Tag name: "1" is invalid: letter expected at position: 0');
    });

    test('should throw for invalid name "@"', () {
      Should.throwException<TagException>(() => TagName.validate('@'))!
          .message
          .should
          .be('Tag name: "@" is invalid: letter expected at position: 0');
    });

    test('should throw for invalid name "ab.1"', () {
      Should.throwException<TagException>(() => TagName.validate('1'))!
          .message
          .should
          .be('Tag name: "1" is invalid: letter expected at position: 0');
    });

    test('should throw for invalid name "ab@"', () {
      Should.throwException<TagException>(
        () => TagName.validate('ab@'),
      )!.message.should.be(
        'Tag name: "ab@" is invalid: end of input expected at position: 2',
      );
    });

    test('should throw for invalid name "ab1.@"', () {
      Should.throwException<TagException>(
        () => TagName.validate('ab1.@'),
      )!.message.should.be(
        'Tag name: "ab1.@" is invalid: end of input expected at position: 3',
      );
    });
  });

  group('Tag constructor', () {
    test('should throw TagException for invalid tag name', () {
      Should.throwException<TagException>(
        () => TagWithInvalidName(),
      )!.message.should.be(
        'Tag name: "inv@lid" is invalid: end of input expected at position: 3',
      );
    });
  });
}

class TagWithInvalidName extends Tag<String> {
  TagWithInvalidName()
    : super(
        name: 'inv@lid',
        description: ['A tag with an invalid name for testing'],
        exampleExpression: 'dummy',
        exampleCode: ProjectFilePath('dummy'),
      );

  @override
  Parser<String> createTagParser(ParserContext context) {
    throw UnimplementedError();
  }

  @override
  List<String> createMarkdownExamples(
    RenderContext renderContext,
    int titleLevel,
  ) => [];
}
