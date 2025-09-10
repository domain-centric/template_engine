import 'package:collection/collection.dart';
import 'package:petitparser/petitparser.dart';
import 'package:template_engine/template_engine.dart';

class ExpressionTag extends Tag {
  ExpressionTag()
    : super(
        name: 'Expression',
        description: [
          'Evaluates an expression that can contain:',
          '* Data Types (e.g. boolean, number or String)',
          '* Constants (e.g. pi)',
          '* Variables (e.g. person.name )',
          '* Operators (e.g. + - * /)',
          '* Functions (e.g. cos(7) )',
          '* or any combination of the above',
        ],
        example:
            'The volume of a sphere = '
            '{{ round( (3/4) * pi * (radius ^ 3) )}}.',
        exampleResult: null,
        exampleFile: ProjectFilePath(
          'test/src/parser/tag/expression/'
          'tag_expression_parser_test.dart',
        ),
      );

  @override
  Parser<Object> createInnerTagParser(ParserContext context) =>
      expressionParser(context);

  @override
  List<String> createMarkdownExamples(
    RenderContext renderContext,
    int titleLevel,
  ) => [
    '${'#' * titleLevel} $name',
    '* ${exampleFile.githubMarkdownLink}',
    ..._createMarkDownExamplesFor(
      renderContext: renderContext,
      title: 'Data Types',
      customExample: ProjectFilePath(
        'test/src/parser/tag/expression/data_type/'
        'custom_data_type_test.dart',
      ),
      exampleFactories: renderContext.engine.dataTypes,
      titleLevel: titleLevel + 1,
    ),
    ..._createMarkDownExamplesFor(
      renderContext: renderContext,
      title: 'Constants',
      customExample: ProjectFilePath(
        'test/src/parser/tag/expression/constant/'
        'custom_constant_test.dart',
      ),
      exampleFactories: renderContext.engine.constants,
      titleLevel: titleLevel + 1,
    ),
    ..._createMarkDownExamplesFor(
      renderContext: renderContext,
      title: 'Variables',
      exampleFactories: [VariableExamples()],
      titleLevel: titleLevel + 1,
    ),
    ..._createMarkDownExamplesFor(
      renderContext: renderContext,
      title: 'Functions',
      customExample: ProjectFilePath(
        'test/src/parser/tag/expression/function/'
        'custom_function_test.dart',
      ),
      exampleFactories: renderContext.engine.functionGroups,
      titleLevel: titleLevel + 1,
    ),
    ..._createMarkDownExamplesFor(
      renderContext: renderContext,
      title: 'Operators',
      customExample: ProjectFilePath(
        'test/src/parser/tag/expression/operator/'
        'custom_operator_test.dart',
      ),
      exampleFactories: renderContext.engine.operatorGroups,
      titleLevel: titleLevel + 1,
    ),
  ];
}

List<String> _createMarkDownExamplesFor({
  required RenderContext renderContext,
  title,
  ProjectFilePath? customExample,
  required List<ExampleFactory> exampleFactories,
  required int titleLevel,
}) {
  if (exampleFactories.isEmpty) {
    return [];
  } else {
    return [
      '${'#' * (titleLevel)} $title',
      if (customExample != null) '* ${customExample.githubMarkdownLink}',
      ...exampleFactories
          .map(
            (dataType) =>
                dataType.createMarkdownExamples(renderContext, titleLevel + 1),
          )
          .flattened,
    ];
  }
}
