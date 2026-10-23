import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('Custom operator : should work correctly', () async {
    var grammar = Grammar.standard().withAdditionalBinaryOperators([
      additionalDivideOperator,
    ]);
    var engine = TemplateEngine(grammar);
    var parseResult = await engine.parseText('{{6 : 3}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('2.0');
  });
}

final additionalDivideOperator = BinaryOperatorDefinition(
  symbol: ':',
  precedence: .multiplicative,
  associativity: .left,
  signatures: [
    BinaryOperatorSignature<num, num, num>(
      description: 'Divides 2 numbers with : operator',
      function: (left, right) => left / right,
      examples: [
        ExpressionBlockExample(
          (delimiter) => '${delimiter.start}6:4${delimiter.end}',
          shouldRender: '1.5',
        ),
      ],
    ),
  ],
);
