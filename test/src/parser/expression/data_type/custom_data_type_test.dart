import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test(
    '{{0b1110}} should be rendered as 14 by a custom binary data type',
    () async {
      var grammar = Grammar.standard().copyWith(
        dataTypes: [binary, ...standardDataTypes],
      );
      var engine = TemplateEngine(grammar);
      var parseResult = await engine.parseText('{{0b1110}}');
      var renderResult = await engine.render(parseResult);
      renderResult.text.should.be('14');
    },
  );
}

final binary = DataTypeDefinition(
  documentation: DefinitionDocumentation(
    title: 'Binary',
    description:
        "A binary number is declared with '1's and '0's, "
        "followed by a lower case letter b (for binary)",
  ),
  matches: (tokens) =>
      tokens.length > 2 &&
      tokens[0].value == '0' &&
      tokens[1].value.toLowerCase().startsWith('b') &&
      tokens[1].value.length > 1 &&
      RegExp(
        r'^[01]+$',
        caseSensitive: false,
      ).hasMatch(tokens[1].value.substring(1)),
  parse: (tokenStream) {
    tokenStream.consume(); // consume 0
    var token1 = tokenStream
        .consume(); // consume b followed by 1 and 0 characters
    return LiteralExpression(int.parse(token1.value.substring(1), radix: 2));
  },
);
