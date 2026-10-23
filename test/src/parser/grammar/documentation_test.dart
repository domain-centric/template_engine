import 'dart:io';

import 'package:shouldly/shouldly.dart';
import 'package:test/test.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  group('HtmlTableWriter', () {
    test('HtmlTableWriter formats a simple table', () {
      final writer = HtmlTableWriter();
      writer.setTitle(2, 'Title');
      writer.addRow(['a', 'b']);

      writer.toHtml().should.contain('## Title');
      writer.toHtml().should.contain('<td>a</td>');
    });
  });

  group('DefinitionDocumentation', () {
    test('DefinitionDocumentation produces HTML from examples', () {
      final doc = DefinitionDocumentation(
        title: 'Test',
        description: 'Desc',
        examples: [
          ExpressionBlockExample(
            (delimiter) => '${delimiter.start} x ${delimiter.end}',
            shouldRender: 'x',
          ),
        ],
      );
      final html = doc.createMarkdownDocumentation(Grammar.standard(), 1);
      html.should.contain('Test');
      html.should.contain('Desc');
      html.should.contain("{{ x }} should render: 'x'");
    });
  });

  group('typeDescription function', () {
    test('typeDescription returns human-friendly names', () {
      typeDescription(num).should.be('number');
      typeDescription(bool).should.be('boolean');
      typeDescription(String).should.be('String');
    });
  });

  group('TemplateEngineConfiguration.statementDefinitions', () {
    test("TestFileExample's should all exist", () async {
      var exampleProviders = Grammar.standard().statements.map(
        (d) => d.documentation,
      );
      await testIfAllTextFileExamplesExist(exampleProviders);
    });
    test("ExpressionBlockExample's should all be correct", () async {
      var standardConfig = Grammar.standard();
      var exampleProviders = standardConfig.statements.map(
        (d) => d.documentation,
      );
      await testIfAllExpressionBlockExamplesAreCorrect(
        TemplateEngine(standardConfig),
        exampleProviders,
      );
    });
  });

  group('TemplateEngineConfiguration.expressionGrammar.dataTypes', () {
    test("TestFileExample's should all exist", () async {
      var exampleProviders = Grammar.standard().dataTypes.map(
        (d) => d.documentation,
      );
      await testIfAllTextFileExamplesExist(exampleProviders);
    });
    test("ExpressionBlockExample's should all be correct", () async {
      var standardConfig = Grammar.standard();
      var exampleProviders = standardConfig.dataTypes.map(
        (d) => d.documentation,
      );
      await testIfAllExpressionBlockExamplesAreCorrect(
        TemplateEngine(standardConfig),
        exampleProviders,
      );
    });
  });

  group('TemplateEngineConfiguration.expressionGrammar.constants', () {
    test("TestFileExample's should all exist", () async {
      var exampleProviders = Grammar.standard().constants.map(
        (d) => d.documentation,
      );
      await testIfAllTextFileExamplesExist(exampleProviders);
    });
    test("ExpressionBlockExample's should all be correct", () async {
      var exampleProviders = Grammar.standard().constants.map(
        (d) => d.documentation,
      );
      await testIfAllExpressionBlockExamplesAreCorrect(
        TemplateEngine(Grammar.standard()),
        exampleProviders,
      );
    });
  });

  group('TemplateEngineConfiguration.expressionGrammar.unaryOperators', () {
    test("TestFileExample's should all exist", () async {
      var exampleProviders = Grammar.standard().unaryOperators.expand(
        (operator) => operator.signatures,
      );
      await testIfAllTextFileExamplesExist(exampleProviders);
    });
    test("ExpressionBlockExample's should all be correct", () async {
      var exampleProviders = Grammar.standard().unaryOperators.expand(
        (operator) => operator.signatures,
      );
      await testIfAllExpressionBlockExamplesAreCorrect(
        TemplateEngine(Grammar.standard()),
        exampleProviders,
      );
    });
  });

  group('TemplateEngineConfiguration.expressionGrammar.binaryOperators', () {
    test("TestFileExample's should all exist", () async {
      var exampleProviders = Grammar.standard().binaryOperators.expand(
        (def) => def.signatures,
      );
      await testIfAllTextFileExamplesExist(exampleProviders);
    });
    test("ExpressionBlockExample's should all be correct", () async {
      var exampleProviders = Grammar.standard().binaryOperators.expand(
        (def) => def.signatures,
      );
      await testIfAllExpressionBlockExamplesAreCorrect(
        TemplateEngine(Grammar.standard()),
        exampleProviders,
      );
    });
  });

  group('TemplateEngineConfiguration.expressionGrammar.functions', () {
    test("TestFileExample's should all exist", () async {
      var exampleProviders = Grammar.standard().functionGroups.expand(
        (group) => group.map((function) => function.documentation),
      );
      await testIfAllTextFileExamplesExist(exampleProviders);
    });
    test("ExpressionBlockExample's should all be correct", () async {
      var exampleProviders = Grammar.standard().functionGroups.expand(
        (group) => group.map((function) => function.documentation),
      );
      await testIfAllExpressionBlockExamplesAreCorrect(
        TemplateEngine(Grammar.standard()),
        exampleProviders,
      );
    });
  });

  group('TemplateEngineConfiguration.expressionGrammar.methods', () {
    test("TestFileExample's should all exist", () async {
      var exampleProviders = Grammar.standard().methods;
      await testIfAllTextFileExamplesExist(exampleProviders);
    });
    test("ExpressionBlockExample's should all be correct", () async {
      var exampleProviders = Grammar.standard().methods;
      await testIfAllExpressionBlockExamplesAreCorrect(
        TemplateEngine(Grammar.standard()),
        exampleProviders,
      );
    });
  });
}

Future<void> testIfAllExpressionBlockExamplesAreCorrect(
  TemplateEngine templateEngine,
  Iterable<ExampleProvider> exampleProviders,
) async {
  var expressionBlockExamples = exampleProviders
      .expand(
        (provider) => provider.examples.whereType<ExpressionBlockExample>(),
      )
      .toList();
  var invalidExpressionBlockExamples = <String>[];
  for (var expressionBlockExample in expressionBlockExamples) {
    if (expressionBlockExample.shouldRender != null) {
      try {
        var expressionBlock = expressionBlockExample.expressionBlockFunction(
          templateEngine.grammar.codeBlockDelimiter,
        );
        var parseResult = await templateEngine.parseText(expressionBlock);
        var variables = expressionBlockExample.variables;

        var renderResult = await templateEngine.render(
          parseResult,
          variables: variables,
        );
        var shouldRender = expressionBlockExample.shouldRender;
        var matched = renderResult.text == shouldRender;
        if (renderResult.errors.isNotEmpty || !matched) {
          var message = StringBuffer();
          message.write(
            expressionBlockExample.expressionBlockFunction(
              templateEngine.grammar.codeBlockDelimiter,
            ),
          );
          if (!matched) {
            message.write(
              ' rendered "${renderResult.text}" and not "$shouldRender"',
            );
          }
          if (renderResult.errors.isNotEmpty) {
            message.write(' , errors:\n');
            message.write('  ');
            message.write(
              [
                ...renderResult.parserErrors,
                ...renderResult.renderErrors,
              ].map((error) => error.toString()).join('\n  '),
            );
          }
          invalidExpressionBlockExamples.add(message.toString());
        }
      } catch (e, stackTrace) {
        var message = StringBuffer();
        message.write(
          expressionBlockExample.expressionBlockFunction(
            templateEngine.grammar.codeBlockDelimiter,
          ),
        );
        message.write(' throw error: $e');
        message.write(' stack trace: $stackTrace');
        invalidExpressionBlockExamples.add(message.toString());
      }
    }
  }
  invalidExpressionBlockExamples.should
      .as('invalidExpressionBlockExamples')
      .beEmpty();
}

Future<void> testIfAllTextFileExamplesExist(
  Iterable<ExampleProvider> exampleProviders,
) async {
  var testFileExamples = exampleProviders
      .expand((provider) => provider.examples.whereType<TestFileExample>())
      .toList();
  var testFilePaths = testFileExamples
      .map(
        (testFileExample) => testFileExample.uri.toString().replaceFirst(
          TestFileExample.gitProjectUri.toString(),
          '',
        ),
      )
      .toList();
  var noneExistingTestFilePaths = <String>[];
  for (var testFilePath in testFilePaths) {
    if (!await File(testFilePath).exists()) {
      noneExistingTestFilePaths.add(testFilePath);
    }
  }
  noneExistingTestFilePaths
      .join('\n')
      .should
      .as('noneExistingTestFilePaths')
      .beBlank();
}
