import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';
import 'package:shouldly/shouldly.dart';

void main() {
  test('valid function name should not throw an exception', () {
    Should.notThrowException(() => FunctionName.validate('goodFunctionName'));
  });
  test('valid function name with numbers should not throw an exception', () {
    Should.notThrowException(
        () => FunctionName.validate('good1Function2Name3'));
  });

  test(
      'invalid function name starting with a capital letter '
      'should throw exception', () async {
    Should.throwException<FunctionException>(
            () => FunctionName.validate('Wrong'))!
        .message
        .should
        .be("Invalid function name: 'Wrong', "
            "lowercase letter expected at position 0");
  });

  test('invalid function name starting with a number should throw exception',
      () async {
    Should.throwException<FunctionException>(
            () => FunctionName.validate('1Wrong'))!
        .message
        .should
        .be("Invalid function name: '1Wrong', "
            "lowercase letter expected at position 0");
  });

  test('invalid function name starting with a symbol should throw exception',
      () async {
    Should.throwException<FunctionException>(
            () => FunctionName.validate('!Wrong'))!
        .message
        .should
        .be("Invalid function name: '!Wrong', "
            "lowercase letter expected at position 0");
  });

  test('invalid function with a symbol in the middle should throw exception',
      () {
    Should.throwException<FunctionException>(
            () => FunctionName.validate('wro!ng'))!
        .message
        .should
        .be("Invalid function name: 'wro!ng', "
            "letter OR digit expected at position 3");
  });

  test(
      'invalid function with a symbol in the end '
      'should throw exception', () {
    Should.throwException<FunctionException>(
            () => FunctionName.validate('wrong!'))!
        .message
        .should
        .be("Invalid function name: 'wrong!', "
            "letter OR digit expected at position 5");
  });
}
