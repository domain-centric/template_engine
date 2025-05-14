import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';
import 'package:shouldly/shouldly.dart';

void main() {
  group('Parameter class', () {
    test(
        'calling constructor: Parameter(name: "inv@lid")) should throw a ParameterException with a valid error message',
        () {
      Should.throwException<ParameterException>(
              () => Parameter(name: 'inv@lid'))!
          .message
          .should
          .be('Invalid parameter name: "inv@lid", '
              'letter OR digit expected at position 3');
    });
  });
}
