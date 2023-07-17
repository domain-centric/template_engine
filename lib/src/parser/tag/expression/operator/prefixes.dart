import 'package:petitparser/petitparser.dart';
import 'package:template_engine/template_engine.dart';

class Prefixes extends OperatorGroup {
  Prefixes()
      : super('Prefixes',
            [PositiveOperator(), NegativeOperator(), NotOperator()]);
}

class PositiveOperator extends Operator {
  PositiveOperator()
      : super('+', ['Optional prefix for positive numbers, e.g.: +3 =3']);

  @override
  addParser(Template template, ExpressionGroup2<Expression<Object>> group) {
    group.prefix(char(operator).trim(), (context, op, a) => a);
  }
}

class NegativeOperator extends Operator {
  NegativeOperator()
      : super('-', ['Prefix for a negative number, e.g.: -2 =-2']);

  @override
  addParser(Template template, ExpressionGroup2<Expression<Object>> group) {
    group.prefix(
        char(operator).trim(),
        (context, op, a) =>
            NegativeNumberExpression(Source.fromContext(template, context), a));
  }
}

class NotOperator extends Operator {
  NotOperator()
      : super('!', ['Prefix to invert a boolean, e.g.: !true =false']);

  @override
  addParser(Template template, ExpressionGroup2<Expression<Object>> group) {
    group.prefix(
        char(operator).trim(),
        (context, op, a) =>
            NotExpression(Source.fromContext(template, context), a));
  }
}
