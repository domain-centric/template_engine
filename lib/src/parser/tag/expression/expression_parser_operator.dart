import 'dart:math';

import 'package:petitparser/petitparser.dart';
import 'package:template_engine/template_engine.dart';

/// An [Operator] behaves generally like functions,
/// but differs syntactically or semantically.
abstract class Operator<T extends Object> implements Expression<T> {
  // for documentation only
}

/// An [Operator] that uses one [value]
/// e.g. making a number negative
class UnaryOperator<T extends Object> extends Operator<T> {
  UnaryOperator(this.name, this.value, this.function);

  final String name;
  final Expression<T> value;
  final T Function(T value) function;

  @override
  T eval(Map<String, Object> variables) => function(value.eval(variables));

  @override
  String toString() => 'UnaryOperator{$name}';
}

/// An [Operator] that uses the two values [left] and [right]
/// An example of an operation: a + b
class BinaryOperator<T extends Object> extends Operator<T> {
  BinaryOperator(this.name, this.left, this.right, this.function);

  final String name;
  final Expression<T> left;
  final Expression<T> right;
  final T Function(T left, T right) function;

  @override
  T eval(Map<String, Object> variables) =>
      function(left.eval(variables), right.eval(variables));

  @override
  String toString() => 'BinaryOperatorExpression{$name}';
}

/// An [Operator] that uses the two values [left] and [right]
/// An example of an operation: a + b
class BinaryOperator2<T extends Object> extends Operator {
  BinaryOperator2(this.callback, this.left, this.right);

  final BinaryOperator2CallBack callback;
  final Expression<T> left;
  final Expression<T> right;

  @override
  Object eval(Map<String, Object> variables) =>
      callback.eval(left.eval(variables), right.eval(variables));

  @override
  String toString() => 'BinaryOperatorExpression{$callback}';
}

abstract class BinaryOperator2CallBack {
  Object eval(Object left, Object right);
}

/// An [Operator] behaves generally like functions,
/// but differs syntactically or semantically.
abstract class Operator2 {
  final String operator;

  /// a description and an example for each type.
  /// e.g. example [descriptions] for an + operator:
  /// * Adds two numbers, e.g.: 2+3=5
  /// * Concatenates two strings, e.g.: 'Hel'+'lo'="Hello"
  final List<String> descriptions;

  Operator2({
    required this.operator,
    required this.descriptions,
  });

  addParser(ExpressionGroup<Expression> group);

  @override
  String toString() => 'Operator{$operator}';
}

class OperatorException implements Exception {
  late String message;

  OperatorException(this.message);
}

class OperatorExceptionFactory {
  static OperatorException bothNeedToBeOfType<T>(
      String operator, Object left, Object right) {
    bool leftHasWrongType = left is! T;
    bool rightHasWrongType = right is! T;
    if (leftHasWrongType & rightHasWrongType) {
      return OperatorException(
          'left and right of the $operator operator must be a ${T.toString()}');
    }
    if (leftHasWrongType) {
      return OperatorException(
          'left of the $operator operator must be a ${T.toString()}');
    }
    return OperatorException(
        'right of the $operator operator must be a ${T.toString()}');
  }
}

class ParenthesesOperator extends Operator2 {
  ParenthesesOperator() : super(operator: '()', descriptions: ['']);

  @override
  addParser(ExpressionGroup<Expression<Object>> group) {
    group.wrapper(
        char('(').trim(), char(')').trim(), (left, value, right) => value);
  }
}

class PowerOperator extends Operator2 implements BinaryOperator2CallBack {
  PowerOperator()
      : super(
          operator: '^',
          descriptions: [
            'Calculates a number to the power of the exponent number, e.g.: 2^3=8'
          ],
        );

  @override
  void addParser(ExpressionGroup<Expression> group) {
    group.right(char('^').trim(),
        (left, op, right) => BinaryOperator2(this, left, right));
  }

  @override
  Object eval(Object left, Object right) {
    if (left is num && right is num) {
      return pow(left, right);
    }
    throw OperatorExceptionFactory.bothNeedToBeOfType<num>(
        operator, left, right);
  }
}
