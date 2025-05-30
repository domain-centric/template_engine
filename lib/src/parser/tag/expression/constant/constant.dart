import 'dart:math';

import 'package:collection/collection.dart';
import 'package:petitparser/petitparser.dart';
import 'package:template_engine/template_engine.dart';

/// A [Constant] is a value that does not change value over time.
///
/// The [TemplateEngine] comes with several mathematical constants.
class Constant<T> implements DocumentationFactory, ExampleFactory {
  /// See [IdentifierName]
  final String name;
  final String description;
  final ProjectFilePath? codeExample;
  final T value;

  Constant({
    required this.name,
    required this.description,
    this.codeExample,
    required this.value,
  }) {
    IdentifierName.validate(name);
  }

  @override
  List<String> createMarkdownDocumentation(
    RenderContext renderContext,
    int titleLevel,
  ) {
    var writer = HtmlTableWriter();
    writer.setHeader(titleLevel + 1, '$name Constant');
    writer.addRow(['description:', description]);
    writer.addRow(['return type:', typeDescription<T>()]);
    if (codeExample != null) {
      writer.addRow(['code example:', codeExample!.githubMarkdownLink]);
    }
    return writer.toHtmlLines();
  }

  @override
  List<String> createMarkdownExamples(
    RenderContext renderContext,
    int titleLevel,
  ) => codeExample == null ? [] : ['* ${codeExample!.githubMarkdownLink}'];
}

class DefaultConstants extends DelegatingList<Constant> {
  DefaultConstants()
    : super([
        Constant<double>(
          name: 'e',
          description: 'Base of the natural logarithms.',
          codeExample: ProjectFilePath(
            'test/src/parser/tag/expression/constant/e_test.dart',
          ),
          value: e,
        ),
        Constant<double>(
          name: 'ln10',
          description: 'Natural logarithm of 10.',
          codeExample: ProjectFilePath(
            'test/src/parser/tag/expression/constant/ln10_test.dart',
          ),
          value: ln10,
        ),
        Constant<double>(
          name: 'ln2',
          description: 'Natural logarithm of 2.',
          codeExample: ProjectFilePath(
            'test/src/parser/tag/expression/constant/ln2_test.dart',
          ),
          value: ln2,
        ),
        Constant<double>(
          name: 'log10e',
          description: 'Base-10 logarithm of e.',
          codeExample: ProjectFilePath(
            'test/src/parser/tag/expression/constant/log10e_test.dart',
          ),
          value: log10e,
        ),
        Constant<double>(
          name: 'log2e',
          description: 'Base-2 logarithm of e.',
          codeExample: ProjectFilePath(
            'test/src/parser/tag/expression/constant/log2e_test.dart',
          ),
          value: log2e,
        ),
        Constant<double>(
          name: 'pi',
          description: "The ratio of a circle's circumference to its diameter",
          codeExample: ProjectFilePath(
            'test/src/parser/tag/expression/constant/pi_test.dart',
          ),
          value: pi,
        ),
      ]);
}

Parser<Expression> constantParser(List<Constant> constants) {
  return ChoiceParser(
        constants.map(
          (constant) => string(constant.name) & (letter() | digit()).not(),
        ),
      )
      .flatten('constant expected')
      .trim()
      .map(
        (name) => Value(
          constants.firstWhere((constant) => constant.name == name).value,
        ),
      );
}
