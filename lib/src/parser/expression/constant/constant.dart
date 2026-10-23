import 'dart:math';

import 'package:template_engine/template_engine.dart';

/// A [ConstantDefinition] is a value that does not change value over time.
///
/// The [TemplateEngine] comes with several mathematical constants.
class ConstantDefinition<T> implements DocumentationProvider {
  final String name;
  final T value;
  @override
  final ConstantDocumentation<T> documentation;

  ConstantDefinition({
    required String name,
    required String description,
    List<Example> examples = const [],
    required this.value,
  }) : // name is case-insensitive, so we convert it to lowercase to ensure consistency.
       name = name.toLowerCase(),
       documentation = ConstantDocumentation<T>(
         name: name,
         description: description,
         value: value,
         examples: examples,
       ) {
    validateIdentifier(nameType: 'constant name', nameToValidate: name);
  }
}

final standardConstants = <ConstantDefinition>[
  ConstantDefinition<double>(
    name: 'e',
    description: 'Base of the natural logarithms.',
    examples: [
      TestFileExample.fromProjectFilePath(
        'test/src/parser/expression/constant/e_test.dart',
      ),
    ],
    value: e,
  ),
  ConstantDefinition<double>(
    name: 'ln10',
    description: 'Natural logarithm of 10.',
    examples: [
      TestFileExample.fromProjectFilePath(
        'test/src/parser/expression/constant/ln10_test.dart',
      ),
    ],
    value: ln10,
  ),
  ConstantDefinition<double>(
    name: 'ln2',
    description: 'Natural logarithm of 2.',
    examples: [
      TestFileExample.fromProjectFilePath(
        'test/src/parser/expression/constant/ln2_test.dart',
      ),
    ],
    value: ln2,
  ),
  ConstantDefinition<double>(
    name: 'log10e',
    description: 'Base-10 logarithm of e.',
    examples: [
      TestFileExample.fromProjectFilePath(
        'test/src/parser/expression/constant/log10e_test.dart',
      ),
    ],
    value: log10e,
  ),
  ConstantDefinition<double>(
    name: 'log2e',
    description: 'Base-2 logarithm of e.',
    examples: [
      TestFileExample.fromProjectFilePath(
        'test/src/parser/expression/constant/log2e_test.dart',
      ),
    ],
    value: log2e,
  ),
  ConstantDefinition<double>(
    name: 'pi',
    description: "The ratio of a circle's circumference to its diameter",
    examples: [
      TestFileExample.fromProjectFilePath(
        'test/src/parser/expression/constant/pi_test.dart',
      ),
    ],
    value: pi,
  ),
];

class ConstantDocumentation<T>
    implements MarkdownDocumentation, ExampleProvider {
  final String name;
  final String description;
  final T value;
  @override
  final List<Example> examples;

  ConstantDocumentation({
    required this.name,
    required this.description,
    required this.value,
    required this.examples,
  });

  @override
  String createMarkdownDocumentation(Grammar grammar, int titleLevel) {
    var writer = HtmlTableWriter();
    writer.setTitle(titleLevel + 1, '$name Constant');
    writer.addRow(['description:', description]);
    writer.addRow(['value:', '$value (${typeDescription(T)})']);
    for (var example in examples) {
      writer.addRow([
        '${example.typeString}:',
        example.toMarkdown(grammar.codeBlockDelimiter),
      ]);
    }
    return writer.toHtml();
  }
}

String aggregatedConstantDocumentation(Grammar grammar, int titleLevel) {
  var markDown = StringBuffer();

  markDown.writeln(
    'A [Constant](https://en.wikipedia.org/wiki/Constant_(computer_programming)) '
    'is a value that does not change value over time.\n\n'
    'The [template_engine](https://pub.dev/packages/template_engine) '
    'comes with several mathematical constants.',
  );

  for (var constant in grammar.constants) {
    markDown.writeln(
      constant.documentation.createMarkdownDocumentation(
        grammar,
        titleLevel + 1,
      ),
    );
  }

  markDown.writeln(markdownTitle(titleLevel + 1, 'Custom constants'));
  markDown.writeln(
    'You can use the constant that are packaged with Template Engine, '
    'but you can also add or replace these with '
    'your own custom made constants. '
    'This is done by creating your own TemplateEngineConfiguration or '
    'adding to it using the withAdditionalConstants() method\n',
  );
  markDown.write('Example: ');
  markDown.writeln(customConstantExample.toMarkdownLink());
  return markDown.toString();
}

final customConstantExample = TestFileExample.fromProjectFilePath(
  'test/src/parser/expression/constant/custom_constant_test.dart',
);
