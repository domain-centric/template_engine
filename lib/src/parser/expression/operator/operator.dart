import 'package:recase/recase.dart';
import 'package:template_engine/template_engine.dart';

/// Provides aggregated Markdown documentation for all operators
/// (both unary and binary) available in the template engine.
///
/// This class generates a complete operator reference, including:
/// - A general introduction to operators and evaluation order
/// - Documentation for all unary operators
/// - Documentation for all binary operators, grouped by precedence
/// - Guidance on defining custom operators
///
/// Binary operators are grouped and ordered by their
/// [BinaryOperatorPrecedence], ensuring the generated documentation reflects
/// the actual evaluation order used by the parser.
///
/// The generated documentation is intended for end users of the template
/// engine, helping them understand operator behavior, syntax, and usage.
String aggregatedOperatorDocumentation(Grammar grammar, int titleLevel) {
  var markDown = StringBuffer();

  markDown.writeln(
    'An expression can contain one or more operators. '
    'An [operator](https://en.wikipedia.org/wiki/Operator_(computer_programming)) '
    'is a symbol or keyword that performs '
    'an operation on one or more values (operands).\n\n'
    'Common simple examples include arithmetic '
    '(e.g. addition with +) and logical operations (e.g. &).\n\n'
    'Operators can be combined, e.g.: 3 + 4 - 2, which results in 5.\n\n'
    'Operators are processed in a specific order, '
    'e.g.: 3 + 2 * 5, which results in 2 * 5 = 10 + 3 = 13\n\n'
    'This order that operators are processed '
    'is the order of the following paragraphs.\n\n'
    'You can change the order that operators are processed '
    'with parentheses, e.g.: (3 + 2) * 5, which results in 3 + 2 = 5 * 5 =25',
  );

  markDown.writeln(markdownTitle(titleLevel, 'Unary operators'));
  var unaryOperators = grammar.unaryOperators;
  for (var unaryOperator in unaryOperators) {
    markDown.writeln(
      unaryOperator.documentation.createMarkdownDocumentation(
        grammar,
        titleLevel + 1,
      ),
    );
  }
  var binaryOperators = grammar.binaryOperators;
  var docs = binaryOperators.map(
    (binaryOperator) => binaryOperator.documentation,
  );
  var precedences = docs.map((d) => d.precedence).toSet().toList();
  precedences.sort((a, b) => b.level.compareTo(a.level));
  for (var precedence in precedences) {
    markDown.writeln(
      markdownTitle(titleLevel, '${precedence.name.sentenceCase} operators'),
    );
    for (var doc in docs.where((d) => d.precedence == precedence)) {
      markDown.writeln(
        doc.createMarkdownDocumentation(grammar, titleLevel + 1),
      );
    }
  }
  markDown.writeln(markdownTitle(titleLevel + 1, 'Custom operators'));
  markDown.writeln(
    'You can use the operators that are packaged with Template Engine, '
    'but you can also add or replace these with '
    'your own custom made operators. '
    'This is done by creating your own TemplateEngineConfiguration or '
    'adding to it with the following TemplateEngineConfiguration methods:\n'
    '* withAdditionalUnaryOperators()\n'
    '* withAdditionalBinaryOperators()\n',
  );
  markDown.write('Example: ');
  markDown.writeln(customOperatorExample.toMarkdownLink());

  return markDown.toString();
}

final customOperatorExample = TestFileExample.fromProjectFilePath(
  'test/src/parser/expression/operator/custom_operator_test.dart',
);
