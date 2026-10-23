import 'dart:io';

import 'package:recase/recase.dart';
import 'package:template_engine/template_engine.dart';

/// Functions that create documentation of the [TemplateEngine] configuration
final standardDocumentationFunctions =
    FunctionGroup('Documentation functions', [
      codeBlockDocumentation,
      dataTypeDocumentation,
      constantDocumentation,
      variableDocumentation,
      operatorDocumentation,
      functionDocumentation,
      methodDocumentation,
      exampleDocumentation,
    ]);

class TitleLevelParameter extends Parameter<int> {
  TitleLevelParameter()
    : super(
        name: 'titleLevel',
        description: 'The level of the title',
        presence: PresenceOptionalWithDefaultValue(1),
      );
}

class DocumentationFunction extends FunctionDefinition<String> {
  DocumentationFunction({
    required super.name,
    required super.documentation,
    required String Function(RenderContext renderContext, int titleLevel)
    documentationFunction,
  }) : super(
         parameters: [TitleLevelParameter()],
         function: (context) => Future.value(
           documentationFunction(context.renderContext, _titleLevel(context)),
         ),
       );

  static int _titleLevel(FunctionCallContext context) {
    var titleLevel = context.argumentValues['titleLevel'];
    if (titleLevel < 1) {
      context.addWarning(
        'Parameter titleLevel was $titleLevel but must be >=1',
        context.argumentLocations['titleLevel']!,
      );
      titleLevel = 1;
    }
    if (titleLevel > 10) {
      context.addWarning(
        'Parameter titleLevel was $titleLevel but must be <=10',
        context.argumentLocations['titleLevel']!,
      );
      titleLevel = 10;
    }
    return titleLevel;
  }
}

final codeBlockDocumentation = DocumentationFunction(
  name: 'codeBlockDocumentation',
  documentation: FunctionDefinitionDocumentation(
    description:
        'Generates markdown documentation of all code blocks that can be used '
        'within a TemplateEngine',
    examples: [],
  ),
  documentationFunction: (renderContext, titleLevel) =>
      aggregatedCodeBlockDocumentation(
        _applicableConfig(renderContext),
        titleLevel,
      ),
);

final dataTypeDocumentation = DocumentationFunction(
  name: 'dataTypeDocumentation',
  documentation: FunctionDefinitionDocumentation(
    description:
        'Generates markdown documentation of all the data '
        'types that can be used within a template',
    examples: [],
  ),
  documentationFunction: (renderContext, titleLevel) =>
      aggregatedDataTypeDocumentation(
        _applicableConfig(renderContext),
        titleLevel,
      ),
);

final constantDocumentation = DocumentationFunction(
  name: 'constantDocumentation',
  documentation: FunctionDefinitionDocumentation(
    description:
        'Generates markdown documentation of all the constants '
        'that can be used within a template',
    examples: [],
  ),

  documentationFunction:
      // aggregateConstantMarkdownDocumentation
      (renderContext, titleLevel) => aggregatedConstantDocumentation(
        _applicableConfig(renderContext),
        titleLevel,
      ),
);

final functionDocumentation = DocumentationFunction(
  name: 'functionDocumentation',
  documentation: FunctionDefinitionDocumentation(
    description:
        'Generates markdown documentation of all the functions '
        'that can be used within a template',
    examples: [],
  ),
  documentationFunction: (renderContext, titleLevel) =>
      aggregatedFunctionDocumentation(
        _applicableConfig(renderContext),
        titleLevel,
      ),
);

final methodDocumentation = DocumentationFunction(
  name: 'methodDocumentation',
  documentation: FunctionDefinitionDocumentation(
    description:
        'Generates markdown documentation of all the methods '
        'that can be used within a template',
    examples: [],
  ),
  documentationFunction: (renderContext, titleLevel) =>
      aggregatedMethodDocumentation(
        _applicableConfig(renderContext),
        titleLevel,
      ),
);

final variableDocumentation = DocumentationFunction(
  name: 'variableDocumentation',
  documentation: FunctionDefinitionDocumentation(
    description:
        'Generates markdown documentation of variables '
        'that can be used within a template',
    examples: [],
  ),

  documentationFunction: (renderContext, titleLevel) => [
    'A [variable](https://en.wikipedia.org/wiki/Variable_(computer_science)) is',
    'a named container for some type of information',
    '(like a [number](https://en.wikipedia.org/wiki/Double-precision_floating-point_format), '
        '[boolean](https://en.wikipedia.org/wiki/Boolean_data_type), '
        '[string](https://en.wikipedia.org/wiki/String_(computer_science)), etc...)',
    '',
    '* Variables are stored as key, value pairs in a dart Map<String, dynamic> where:',
    '  * String=Variable name',
    '  * dynamic=Variable value',
    '* Variables can be used in an expression',
    '* Initial variable values are passed to the TemplateEngine.render method',
    '* Variables can be modified during rendering',
    '',
    'The [variable name](https://en.wikipedia.org/wiki/Variable_(computer_science)) ',
    'identifies the variable and corresponds with the keys',
    'in the variable map.',
    '',
    'The [variable names](https://en.wikipedia.org/wiki/Variable_(computer_science)):  ',
    '* are [case sensitive](https://en.wikipedia.org/wiki/Case_sensitivity)!',
    '* conventions: use [lowerCamelCase](https://en.wikipedia.org/wiki/Camel_case)',
    '* must be unique and does not match a other reserved keyword '
        '(e.g. statements, functions, constants, etc)',
    '',
    'Variables can be nested. Concatenate '
        '[variable names](https://en.wikipedia.org/wiki/Variable_(computer_science))'
        ' separated with dot\'s to get the variable value of a nested '
        '[variable name](https://en.wikipedia.org/wiki/Variable_(computer_science)):'
        '',
    'E.g.:<br>',
    'Variable map: {\'person\': {\'name\': \'John Doe\', \'age\',30}}<br>',
    'Variable name person.name: refers to the variable value of \'John Doe\'',
    '',
    'Examples:',
    ...variableExamples.map((example) => '* ${example.toMarkdownLink()}'),
  ].join('\n'),
);

final operatorDocumentation = DocumentationFunction(
  name: 'operatorDocumentation',
  documentation: FunctionDefinitionDocumentation(
    description:
        'Generates markdown documentation of all the operators '
        'that can be used within a template',
    examples: [],
  ),
  documentationFunction: (renderContext, titleLevel) =>
      aggregatedOperatorDocumentation(
        _applicableConfig(renderContext),
        titleLevel,
      ),
);

final exampleDocumentation = DocumentationFunction(
  name: 'exampleDocumentation',
  documentation: FunctionDefinitionDocumentation(
    description:
        'Generates markdown documentation of all the examples. '
        'This could be used to generate example.md file.',
    examples: [],
  ),
  documentationFunction: (renderContext, titleLevel) =>
      _createMarkdownExamples(_applicableConfig(renderContext), titleLevel),
);

String _createMarkdownExamples(Grammar grammar, int titleLevel) => [
  markdownTitle(titleLevel, 'Code blocks'),
  markdownTitle(titleLevel + 1, 'Statement code blocks'),
  for (var statement in grammar.statements)
    _createMarkDownExamplesFor(
      title: statement.documentation.title,
      titleLevel: titleLevel + 2,
      testFileExamples: statement.documentation.examples
          .whereType<TestFileExample>(),
    ),
  _createMarkDownExamplesFor(
    title: 'Custom statements',
    titleLevel: titleLevel + 2,
    testFileExamples: [customStatementExample],
  ),
  _createMarkDownExamplesFor(
    title: 'Expression code blocks',
    titleLevel: titleLevel + 1,
    testFileExamples: [
      grammar.dataTypes.first.documentation.examples
          .whereType<TestFileExample>()
          .first,
      grammar.constants.first.documentation.examples
          .whereType<TestFileExample>()
          .first,
      variableExamples.first,
      grammar.unaryOperators.first.documentation.examples
          .whereType<TestFileExample>()
          .first,
      grammar.binaryOperators.first.documentation.examples
          .whereType<TestFileExample>()
          .first,
      grammar.functionGroups.first.examples.whereType<TestFileExample>().first,
      grammar.methods.first.examples.whereType<TestFileExample>().first,
    ],
  ),

  markdownTitle(titleLevel, 'Expressions'),

  _createMarkDownExamplesFor(
    title: 'Data Types',
    titleLevel: titleLevel + 1,
    testFileExamples: [
      ...grammar.dataTypes.expand(
        (dataType) =>
            dataType.documentation.examples.whereType<TestFileExample>(),
      ),
      customDataTypeExample,
    ],
  ),
  _createMarkDownExamplesFor(
    title: 'Constants',
    titleLevel: titleLevel + 1,
    testFileExamples: [
      ...grammar.constants.expand(
        (constant) =>
            constant.documentation.examples.whereType<TestFileExample>(),
      ),
      customConstantExample,
    ],
  ),
  _createMarkDownExamplesFor(
    title: 'Variables',
    titleLevel: titleLevel + 1,
    testFileExamples: variableExamples,
  ),

  markdownTitle(titleLevel + 1, 'Operators'),
  _createMarkDownExamplesFor(
    title: 'Unary operators',
    titleLevel: titleLevel + 2,
    testFileExamples: grammar.unaryOperators
        .expand((operator) => operator.documentation.examples)
        .whereType<TestFileExample>(),
  ),
  for (var precedence in _orderedPrecedences(grammar))
    _createMarkDownExamplesFor(
      title: '${precedence.name.titleCase} operator',
      titleLevel: titleLevel + 2,
      testFileExamples: grammar.binaryOperators
          .where((operatorDef) => operatorDef.precedence == precedence)
          .expand((operator) => operator.documentation.examples)
          .whereType<TestFileExample>(),
    ),
  _createMarkDownExamplesFor(
    title: 'Custom operators',
    titleLevel: titleLevel + 2,
    testFileExamples: [customOperatorExample],
  ),
  markdownTitle(titleLevel + 1, 'Functions'),
  for (var functionGroup in grammar.functionGroups)
    _createMarkDownExamplesFor(
      title: functionGroup.name,
      titleLevel: titleLevel + 2,
      testFileExamples: functionGroup.examples.whereType<TestFileExample>(),
    ),
  _createMarkDownExamplesFor(
    title: 'Custom functions',
    titleLevel: titleLevel + 2,
    testFileExamples: [customFunctionExample],
  ),

  markdownTitle(titleLevel + 1, 'Methods'),
  for (var methodEntry in grammar.methodsPerOwnerType.entries)
    _createMarkDownExamplesFor(
      title: typeDescription(methodEntry.key),
      titleLevel: titleLevel + 2,
      testFileExamples: methodEntry.value
          .expand((methodDef) => methodDef.examples)
          .whereType<TestFileExample>(),
    ),
  _createMarkDownExamplesFor(
    title: 'Custom methods',
    titleLevel: titleLevel + 2,
    testFileExamples: [customMethodExample],
  ),
].join('\n');

List<BinaryOperatorPrecedence> _orderedPrecedences(Grammar grammar) {
  var binaryOperators = grammar.binaryOperators;
  var precedences = binaryOperators
      .map((operator) => operator.precedence)
      .toSet()
      .toList();
  precedences.sort((a, b) => b.level.compareTo(a.level));
  return precedences;
}

String _createMarkDownExamplesFor({
  required String title,
  required int titleLevel,
  required Iterable<TestFileExample> testFileExamples,
}) {
  if (testFileExamples.isEmpty) return '';
  return [
    '${'#' * (titleLevel)} $title',
    ...testFileExamples.map(
      (testFileExample) => '* ${testFileExample.toMarkdownLink()}',
    ),
  ].join('\n');
}

/// The documentation for template_engine is generated by the
/// documentation_builder which has an extended TemplateEngineConfiguration
/// So if this [isTemplateEngineProject]
/// than we return the standard [Grammar]
/// if not we return the grammar from the [renderContext]
Grammar _applicableConfig(RenderContext renderContext) =>
    isTemplateEngineProject ? Grammar.standard() : renderContext.grammar;

// Checks if the current directory is named 'template_engine'
// This is needed because the documentation is generated by the
// documentation_builder which has additional functions that
// we do not want to display in the template_engine documentation
//
// This uses the current working directory from Dart:io
// and compares the last segment to 'template_engine'
bool get isTemplateEngineProject {
  try {
    return Directory.current.path.split(Platform.pathSeparator).last ==
        'template_engine';
  } catch (_) {
    // If Directory.current is not available (e.g., web), return false
    return false;
  }
}
