import 'dart:math';

import 'package:petitparser/petitparser.dart';
import 'package:template_engine/template_engine.dart';

class NegativeNumberExpression extends Expression {
  final Expression valueExpression;

  NegativeNumberExpression(this.valueExpression);

  @override
  Object eval(Map<String, Object> variables) {
    var value = valueExpression.eval(variables);
    if (value is num) {
      return -value;
    }
    throw OperatorException('A number expected after the - operator');
  }
}

class NotExpression extends Expression {
  final Expression valueExpression;

  NotExpression(this.valueExpression);

  @override
  Object eval(Map<String, Object> variables) {
    var value = valueExpression.eval(variables);
    if (value is bool) {
      return !value;
    }
    throw OperatorException('A boolean expected after the ! operator');
  }
}

class TwoValueOperatorVariant<PARAMETER_TYPE extends Object> {
  final String description;
  final Object Function(PARAMETER_TYPE left, PARAMETER_TYPE right) function;

  List<String> validate(String operator, Object leftValue, Object rightValue) {
    bool leftTypeOk = leftValue is PARAMETER_TYPE;
    bool rightTypeOk = rightValue is PARAMETER_TYPE;
    if (leftTypeOk && rightTypeOk) {
      return [];
    } else if (!leftTypeOk && !rightTypeOk) {
      return [
        'left and right of the $operator operator must be a $typeDescription'
      ];
    }
    if (!leftTypeOk) {
      return ['left of the $operator operator must be a $typeDescription'];
    }
    return ['right of the $operator operator must be a $typeDescription'];
  }

  String get typeDescription {
    switch (PARAMETER_TYPE) {
      case num:
        return 'number';
      case bool:
        return 'boolean';

      default:
        return PARAMETER_TYPE.toString();
    }
  }

  Object eval(Object leftValue, Object rightValue) =>
      function(leftValue as PARAMETER_TYPE, rightValue as PARAMETER_TYPE);

  TwoValueOperatorVariant(this.description, this.function);
}

/// delegates the work to one of the [variants] that can process
/// the correct types of the evaluated [left] and [right] values.
class OperatorVariantExpression extends Expression {
  final List<TwoValueOperatorVariant> variants;
  final String operator;
  final Expression left;
  final Expression right;

  OperatorVariantExpression(
      {required this.operator,
      required this.variants,
      required this.left,
      required this.right});

  @override
  Object eval(Map<String, Object> variables) {
    var leftValue = left.eval(variables);
    var rightValue = right.eval(variables);

    var errors = <String>[];
    for (var operatorVariant in variants) {
      var variantErrors =
          operatorVariant.validate(operator, leftValue, rightValue);
      if (variantErrors.isEmpty) {
        return operatorVariant.eval(leftValue, rightValue);
      } else {
        errors.addAll(variantErrors);
      }
    }
    throw OperatorException(errors.join(', or '));
  }
}

/// A value that needs to be calculated (evaluated)
/// from 2 expressions that return a object of type [T]
class TwoValueOperatorExpression<T extends Object> extends Expression {
  final String operator;
  final Expression left;
  final Expression right;
  final T Function(T left, T right) function;

  TwoValueOperatorExpression(
      {required this.operator,
      required this.left,
      required this.right,
      required this.function});

  String get leftAndRightTypeDescription {
    if (T is num) {
      return 'number';
    } else if (T is bool) {
      return 'boolean';
    } else {
      return T.toString();
    }
  }

  @override
  Object eval(Map<String, Object> variables) {
    var leftValue = left.eval(variables);
    bool leftTypeOk = leftValue is T;
    var rightValue = right.eval(variables);
    bool rightTypeOk = rightValue is T;
    if (leftTypeOk && rightTypeOk) {
      return function(leftValue, rightValue);
    }

    if (!leftTypeOk && !rightTypeOk) {
      throw OperatorException(
          'left and right of the $operator operator must be a $leftAndRightTypeDescription');
    }
    if (!leftTypeOk) {
      throw OperatorException(
          'left of the $operator operator must be a $leftAndRightTypeDescription');
    }
    throw OperatorException(
        'right of the $operator operator must be a $leftAndRightTypeDescription');
  }

  @override
  String toString() => 'TwoValueOperatorExpression{$operator}';
}

/// An [Operator] behaves generally like functions,
/// but differs syntactically or semantically.
abstract class Operator {
  final String operator;

  /// a description and an example for each type.
  /// e.g. example [descriptions] for an + operator:
  /// * Adds two numbers, e.g.: 2+3=5
  /// * Concatenates two strings, e.g.: 'Hel'+'lo'="Hello"
  final List<String> descriptions;

  Operator(
    this.operator,
    this.descriptions,
  );

  addParser(ExpressionGroup<Expression> group);

  @override
  String toString() => 'Operator{$operator}';
}

abstract class OperatorWith2Values extends Operator {
  final List<TwoValueOperatorVariant> variants;

  OperatorWith2Values(
    String operator,
    this.variants,
  ) : super(operator, variants.map((v) => v.description).toList());

  Expression createExpression(Expression left, Expression right) =>
      OperatorVariantExpression(
          operator: operator, variants: variants, left: left, right: right);
  @override
  String toString() => 'Operator{$operator}';
}

class OperatorException implements Exception {
  late String message;
  OperatorException(this.message);
}

class ParenthesesOperator extends Operator {
  ParenthesesOperator()
      : super('()', [
          'Groups expressions together so that the are calculated first, e.g.: (2+1)*3=9 while 2+1*3=5'
        ]);

  @override
  addParser(ExpressionGroup<Expression<Object>> group) {
    group.wrapper(
        char('(').trim(), char(')').trim(), (left, value, right) => value);
  }
}

class PositiveOperator extends Operator {
  PositiveOperator()
      : super('+', ['Optional prefix for positive numbers, e.g.: +3 =3']);

  @override
  addParser(ExpressionGroup<Expression<Object>> group) {
    group.prefix(char(operator).trim(), (op, a) => a);
  }
}

class NegativeOperator extends Operator {
  NegativeOperator()
      : super('-', ['Prefix for a negative number, e.g.: -2 =-2']);

  @override
  addParser(ExpressionGroup<Expression<Object>> group) {
    group.prefix(char(operator).trim(), (op, a) => NegativeNumberExpression(a));
  }
}

class NotOperator extends Operator {
  NotOperator()
      : super('!', ['Prefix to invert a boolean, e.g.: !true =false']);

  @override
  addParser(ExpressionGroup<Expression<Object>> group) {
    group.prefix(char(operator).trim(), (op, a) => NotExpression(a));
  }
}

class CaretOperator extends OperatorWith2Values {
  CaretOperator()
      : super('^', [
          TwoValueOperatorVariant<num>(
              'Calculates a number to the power of the exponent number, e.g.: 2^3=8',
              pow),
          TwoValueOperatorVariant<bool>(
              'Logical XOR with two booleans, e.g.: true^false=true',
              (left, right) => left ^ right)
        ]);

  @override
  void addParser(ExpressionGroup<Expression> group) {
    group.right(char(operator).trim(),
        (left, op, right) => createExpression(left, right));
  }
}

class MultiplyOperator extends OperatorWith2Values {
  MultiplyOperator()
      : super('*', [
          TwoValueOperatorVariant<num>('Multiplies 2 numbers, e.g.: 2*3=6',
              (left, right) => left * right)
        ]);

  @override
  void addParser(ExpressionGroup<Expression> group) {
    group.left(char(operator).trim(),
        (left, op, right) => createExpression(left, right));
  }
}

class DivideOperator extends OperatorWith2Values {
  DivideOperator()
      : super(
          '/',
          [
            TwoValueOperatorVariant<num>('Divides 2 numbers, e.g.: 6*4=1.5',
                (left, right) => left / right)
          ],
        );

  @override
  void addParser(ExpressionGroup<Expression> group) {
    group.left(char(operator).trim(),
        (left, op, right) => createExpression(left, right));
  }
}

class ModuloOperator extends OperatorWith2Values {
  ModuloOperator()
      : super(
          '%',
          [
            TwoValueOperatorVariant<num>(
                'Calculates the modulo (rest value of a division), e.g.: 8%3=2',
                (left, right) => left % right)
          ],
        );

  @override
  void addParser(ExpressionGroup<Expression> group) {
    group.left(char(operator).trim(),
        (left, op, right) => createExpression(left, right));
  }
}

class AndOperator extends OperatorWith2Values {
  AndOperator()
      : super(
          '&',
          [
            TwoValueOperatorVariant<bool>(
                'Logical AND operation on two booleans, e.g.: true&true=true',
                (left, right) => left & right),
            TwoValueOperatorVariant<String>(
                'Concatenates two strings, e.g.: "Hel"&"lo"="Hello"',
                (left, right) => '$left$right')
          ],
        );

  @override
  void addParser(ExpressionGroup<Expression> group) {
    group.left(char(operator).trim(),
        (left, op, right) => createExpression(left, right));
  }
}

class AddOperator extends OperatorWith2Values {
  AddOperator()
      : super('+', [
          TwoValueOperatorVariant<num>(
              'Adds two numbers, e.g.: 2+3=5', (left, right) => left + right),
          TwoValueOperatorVariant<String>(
              'Concatenates two strings, e.g.: "Hel"+"lo"="Hello"',
              (left, right) => '$left$right')
        ]);

  @override
  void addParser(ExpressionGroup<Expression> group) {
    group.left(char(operator).trim(),
        (left, op, right) => createExpression(left, right));
  }
}

class SubtractOperator extends OperatorWith2Values {
  SubtractOperator()
      : super(
          '-',
          [
            TwoValueOperatorVariant<num>('Subtracts two numbers, e.g.: 5-3=2',
                (left, right) => left - right)
          ],
        );

  @override
  void addParser(ExpressionGroup<Expression> group) {
    group.left(char(operator).trim(),
        (left, op, right) => createExpression(left, right));
  }
}

class OrOperator extends OperatorWith2Values {
  OrOperator()
      : super(
          '|',
          [
            TwoValueOperatorVariant<bool>(
                'Logical OR operation on two booleans, e.g.: false|true=true',
                (left, right) => left | right)
          ],
        );

  @override
  void addParser(ExpressionGroup<Expression> group) {
    group.left(char(operator).trim(),
        (left, op, right) => createExpression(left, right));
  }
}
