import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('Custom operator : should work correctly', () {
    var engine = TemplateEngine();
    var group =
        engine.operatorGroups.firstWhere((group) => group is Multiplication);
    group.add(DivideOperator());
    var parseResult = engine.parseTemplate(TextTemplate('{{6 : 3}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('2.0');
  });
}

class DivideOperator extends OperatorWith2Values {
  DivideOperator()
      : super(
          ':',
          OperatorAssociativity.left,
          [
            TwoValueOperatorVariant<num>(
                description: 'Divides 2 numbers',
                expressionExample: '{{6:4}}',
                expressionExampleResult: '1.5',
                function: (left, right) => left / right)
          ],
        );
}
