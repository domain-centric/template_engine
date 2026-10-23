import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  group('Parameter class', () {
    test(
      'calling constructor: Parameter(name: "inv@lid")) should throw a ParameterException with a valid error message',
      () {
        Should.throwException<InvalidIdentifierName>(
          () => Parameter(name: 'inv@lid', presence: PresenceMandatory()),
        )?.message.should.be(
          'invalid parameter name: "inv@lid", '
          'letter OR digit expected at position 3',
        );
      },
    );
  });
}
