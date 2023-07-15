import 'package:petitparser/petitparser.dart';
import 'package:template_engine/template_engine.dart';

class Parentheses extends OperatorGroup {
  Parentheses() : super('Parentheses', [ParenthesesOperator()]);
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
