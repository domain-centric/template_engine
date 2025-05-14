import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('Custom operator : should work correctly', () async {
    var engine = TemplateEngine();
    var group =
        engine.operatorGroups.firstWhere((group) => group is Multiplication);
    group.add(DivideOperator());
    var parseResult = await engine.parseText('{{6 : 3}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('2.0');
  });
}

class DivideOperator extends OperatorWith2Values {
  DivideOperator()
      : super(
          name: 'Divide',
          symbol: ':',
          associativity: OperatorAssociativity.left,
          variants: [
            TwoValueOperatorVariant<num, num>(
                description: 'Divides 2 numbers',
                expressionExample: '{{6:4}}',
                expressionExampleResult: '1.5',
                function: (left, right) => left / right)
          ],
        );
}
