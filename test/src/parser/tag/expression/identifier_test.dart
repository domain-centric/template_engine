import 'package:shouldly/shouldly.dart';
import 'package:template_engine/src/parser/tag/expression/identifier.dart';
import 'package:test/test.dart';

void main() {
  group('IdentifierName class', () {
    test('valid function name should not throw an exception', () {
      Should.notThrowException(
        () => IdentifierName.validate('goodFunctionName'),
      );
    });
    test('valid function name with numbers should not throw an exception', () {
      Should.notThrowException(
        () => IdentifierName.validate('good1Function2Name3'),
      );
    });

    test('Invalid identifier name starting with a capital letter '
        'should throw exception', () async {
      Should.throwException<IdentifierException>(
        () => IdentifierName.validate('Wrong'),
      )!.message.should.be(
        "Invalid identifier name: 'Wrong', "
        "lowercase letter expected at position 0",
      );
    });

    test(
      'Invalid identifier name starting with a number should throw exception',
      () async {
        Should.throwException<IdentifierException>(
          () => IdentifierName.validate('1Wrong'),
        )!.message.should.be(
          "Invalid identifier name: '1Wrong', "
          "lowercase letter expected at position 0",
        );
      },
    );

    test(
      'Invalid identifier name starting with a symbol should throw exception',
      () async {
        Should.throwException<IdentifierException>(
          () => IdentifierName.validate('!Wrong'),
        )!.message.should.be(
          "Invalid identifier name: '!Wrong', "
          "lowercase letter expected at position 0",
        );
      },
    );

    test(
      'Invalid identifier name with a symbol in the middle should throw exception',
      () {
        Should.throwException<IdentifierException>(
          () => IdentifierName.validate('wro!ng'),
        )!.message.should.be(
          "Invalid identifier name: 'wro!ng', "
          "letter OR digit expected at position 3",
        );
      },
    );

    test('Invalid Identifier name with a symbol in the end '
        'should throw exception', () {
      Should.throwException<IdentifierException>(
        () => IdentifierName.validate('wrong!'),
      )!.message.should.be(
        "Invalid identifier name: 'wrong!', "
        "letter OR digit expected at position 5",
      );
    });
  });
}
