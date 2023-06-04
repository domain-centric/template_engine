import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/src/tag/tag.dart';

void main() {
  given('TagName', () {
    var tagName = TagName();
    when('calling validate("a")', () {
      then('should not throw an error', () {
        Should.notThrowError(() => tagName.validate('a'));
      });
    });

    when('calling validate("ab")', () {
      then('should not throw an error', () {
        Should.notThrowError(() => tagName.validate('ab'));
      });
    });
    when('calling validate("a1")', () {
      then('should not throw an error', () {
        Should.notThrowError(() => tagName.validate('a1'));
      });
    });
    when('calling validate("a11")', () {
      then('should not throw an error', () {
        Should.notThrowError(() => tagName.validate('a11'));
      });
    });

    when('calling validate("1")', () {
      then('should throw a correct error', () {
        Should.throwException<TagException>(() => tagName.validate('1'))!
            .message
            .should
            .be('Tag name: "1" is invalid: letter expected at position: 0');
      });
    });

    when('calling validate("@")', () {
      then('should throw a correct error', () {
        Should.throwException<TagException>(() => tagName.validate('@'))!
            .message
            .should
            .be('Tag name: "@" is invalid: letter expected at position: 0');
      });
    });

    when('calling validate("ab.1")', () {
      then('should throw a correct error', () {
        Should.throwException<TagException>(() => tagName.validate('1'))!
            .message
            .should
            .be('Tag name: "1" is invalid: letter expected at position: 0');
      });
    });

    when('calling validate("ab@")', () {
      then('should throw a correct error', () {
        Should.throwException<TagException>(() => tagName.validate('ab@'))!
            .message
            .should
            .be('Tag name: "ab@" is invalid: '
                'end of input expected at position: 2');
      });
    });

    when('calling validate("ab1.@")', () {
      then('should throw a correct error', () {
        Should.throwException<TagException>(() => tagName.validate('ab1.@'))!
            .message
            .should
            .be('Tag name: "ab1.@" is invalid: '
                'end of input expected at position: 3');
      });
    });
  });
}
