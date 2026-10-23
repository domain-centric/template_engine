import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  group('isTruthy function', () {
    test('determines truthiness correctly', () {
      isTruthy(null).should.be(false);
      isTruthy(0).should.be(false);
      isTruthy('').should.be(false);
      isTruthy([]).should.be(false);
      isTruthy({'a': 1}).should.be(true);
      isTruthy(1).should.be(true);
      isTruthy('x').should.be(true);
    });
  });
}
