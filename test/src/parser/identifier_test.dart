import 'package:shouldly/shouldly.dart';
import 'package:template_engine/src/parser/identifier.dart';
import 'package:test/test.dart';

void main() {
  group('Identifier utilities', () {
    test('accepts valid identifiers', () {
      validateIdentifier(
        nameType: 'constant name',
        nameToValidate: 'valid_name1',
      );
    });

    test('rejects empty identifiers', () {
      Should.throwException<InvalidIdentifierName>(
        () => validateIdentifier(nameType: 'function name', nameToValidate: ''),
      )?.message.should.be('function name cannot be empty');
    });

    test('rejects invalid identifier characters', () {
      Should.throwException<InvalidIdentifierName>(
        () => validateIdentifier(
          nameType: 'function argument name',
          nameToValidate: '1bad',
        ),
      )?.message.should.be(
        'invalid function argument name: "1bad", letter OR underscore expected at position 0',
      );
    });
  });
}
