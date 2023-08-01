import 'package:petitparser/petitparser.dart';
import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('Custom operator : should work correctly', () {
    var engine = TemplateEngine();
    var group =
        engine.operatorGroups.firstWhere((group) => group is Multiplication);
    group.add(DivideOperator());
    var parseResult = engine.parse(const TextTemplate('{{6 : 3}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('2.0');
  });
}

class DivideOperator extends OperatorWith2Values {
  DivideOperator()
      : super(
          ':',
          [
            TwoValueOperatorVariant<num>('Divides 2 numbers, e.g.: 6*4=1.5',
                (left, right) => left / right)
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
