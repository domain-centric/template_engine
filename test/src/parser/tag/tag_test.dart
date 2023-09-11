import 'package:petitparser/src/core/parser.dart';
import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  given('TagName', () {
    when('calling validate("a")', () {
      then('should not throw an error', () {
        Should.notThrowError(() => TagName.validate('a'));
      });
    });

    when('calling validate("ab")', () {
      then('should not throw an error', () {
        Should.notThrowError(() => TagName.validate('ab'));
      });
    });
    when('calling validate("a1")', () {
      then('should not throw an error', () {
        Should.notThrowError(() => TagName.validate('a1'));
      });
    });
    when('calling validate("a11")', () {
      then('should not throw an error', () {
        Should.notThrowError(() => TagName.validate('a11'));
      });
    });

    when('calling validate("1")', () {
      then('should throw a correct error', () {
        Should.throwException<TagException>(() => TagName.validate('1'))!
            .message
            .should
            .be('Tag name: "1" is invalid: letter expected at position: 0');
      });
    });

    when('calling validate("@")', () {
      then('should throw a correct error', () {
        Should.throwException<TagException>(() => TagName.validate('@'))!
            .message
            .should
            .be('Tag name: "@" is invalid: letter expected at position: 0');
      });
    });

    when('calling validate("ab.1")', () {
      then('should throw a correct error', () {
        Should.throwException<TagException>(() => TagName.validate('1'))!
            .message
            .should
            .be('Tag name: "1" is invalid: letter expected at position: 0');
      });
    });

    when('calling validate("ab@")', () {
      then('should throw a correct error', () {
        Should.throwException<TagException>(() => TagName.validate('ab@'))!
            .message
            .should
            .be('Tag name: "ab@" is invalid: '
                'end of input expected at position: 2');
      });
    });

    when('calling validate("ab1.@")', () {
      then('should throw a correct error', () {
        Should.throwException<TagException>(() => TagName.validate('ab1.@'))!
            .message
            .should
            .be('Tag name: "ab1.@" is invalid: '
                'end of input expected at position: 3');
      });
    });
  });
  given('Tag', () {
    when('Calling constructor', () {
      then('Should throw an TagException with a valid message', () {
        Should.throwException<TagException>(() => TagWithInvalidName())!
            .message
            .should
            .be('Tag name: "inv@lid" is invalid: end of input expected at position: 3');
      });
    });
  });
}

class TagWithInvalidName extends Tag<String> {
  TagWithInvalidName()
      : super(
            name: 'inv@lid',
            description: ['A tag with an invalid name for testing'],
            exampleExpression: 'dummy',
            exampleCode: ProjectFilePath('dummy'));

  @override
  Parser<String> createTagParser(ParserContext context) {
    throw UnimplementedError();
  }

  @override
  List<String> createMarkdownExamples(
          RenderContext renderContext, int titleLevel) =>
      [];
}
