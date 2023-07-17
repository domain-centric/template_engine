import 'package:petitparser/parser.dart';
import 'package:template_engine/template_engine.dart';

class Additions extends OperatorGroup {
  Additions()
      : super('Additions', [AddOperator(), SubtractOperator(), OrOperator()]);
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
  void addParser(Template template, ExpressionGroup2<Expression> group) {
    group.left(
        char(operator).trim(),
        (context, left, op, right) => createExpression(
            Source.fromContext(template, context), left, right));
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
  void addParser(Template template, ExpressionGroup2<Expression> group) {
    group.left(
        char(operator).trim(),
        (context, left, op, right) => createExpression(
            Source.fromContext(template, context), left, right));
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
  void addParser(Template template, ExpressionGroup2<Expression> group) {
    group.left(
        char(operator).trim(),
        (context, left, op, right) => createExpression(
            Source.fromContext(template, context), left, right));
  }
}
