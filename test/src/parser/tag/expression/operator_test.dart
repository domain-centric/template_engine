import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  given('expressionParser(ParserContext())', () {
    var parser = expressionParser(ParserContext());

    when('calling: parser.parse("false & 3").value.eval({})', () {
      var expected = 'right of the & operator must be a boolean, or '
          'left and right of the & operator must be a String';
      then(
          'should throw an OperatorException with message: $expected',
          () => Should.throwException<OperatorException>(
                  () => parser.parse("false & 3").value.eval({}))!
              .message
              .should
              .be(expected));
    });

    when('calling: parser.parse("2 & true").value.eval({})', () {
      var expected = 'left of the & operator must be a boolean, or '
          'left and right of the & operator must be a String';
      then(
          'should throw an OperatorException with message: $expected',
          () => Should.throwException<OperatorException>(
                  () => parser.parse("2 & true").value.eval({}))!
              .message
              .should
              .be(expected));
    });

    when('calling: parser.parse("2 & 3").value.eval({})', () {
      var expected = 'left and right of the & operator must be a boolean, or '
          'left and right of the & operator must be a String';
      then(
          'should throw an OperatorException with message: $expected',
          () => Should.throwException<OperatorException>(
                  () => parser.parse("2 & 3").value.eval({}))!
              .message
              .should
              .be(expected));
    });

    when('calling: parser.parse("4 + true").value.eval({})', () {
      var expected = 'right of the + operator must be a number, or '
          'left and right of the + operator must be a String';
      then(
          'should throw an OperatorException with message: $expected',
          () => Should.throwException<OperatorException>(
                  () => parser.parse("4 + true").value.eval({}))!
              .message
              .should
              .be(expected));
    });

    when('calling: parser.parse("false - 4").value.eval({})', () {
      var expected = 'left of the - operator must be a number';
      then(
          'should throw an OperatorException with message: $expected',
          () => Should.throwException<OperatorException>(
                  () => parser.parse("false - 4").value.eval({}))!
              .message
              .should
              .be(expected));
    });

    when('calling: parser.parse("true - \'String\'").value.eval({})', () {
      var expected = 'left and right of the - operator must be a number';
      then(
          'should throw an OperatorException with message: $expected',
          () => Should.throwException<OperatorException>(
                  () => parser.parse("true - 'String'").value.eval({}))!
              .message
              .should
              .be(expected));
    });
  });
}
