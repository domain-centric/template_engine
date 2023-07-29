import 'package:collection/collection.dart';
import 'package:petitparser/petitparser.dart';
import 'package:template_engine/template_engine.dart';

class ExpressionTag extends Tag {
  ExpressionTag()
      : super(
          name: 'ExpressionTag',
          description: [
            'Evaluates an expression that can a contain:',
            '* Data Types (e.g. boolean, number or String)',
            '* Constants (e.g. pi)',
            '* Variables (e.g. person.name )',
            '* Operators (e.g. + - * /)',
            '* Functions (e.g. cos(7) )',
            '* or any combination of the above'
          ],
          exampleExpression: 'The volume of a sphere = '
              '{{ round( (3/4) * pi * (radius ^ 3) )}}.',
          exampleCode: ProjectFilePath('/test/src/parser/tag/expression/'
              'tag_expression_parser_test.dart'),
        );

  @override
  Parser<Object> createTagParser(ParserContext context) =>
      (string(context.engine.tagStart) &
              (whitespace().star()) &
              expressionParser(context) &
              (whitespace().star()) &
              string(context.engine.tagEnd))
          .valueContextMap((values, parsePosition) => values[2]);

  @override
  List<String> createMarkdownExamples(
          RenderContext renderContext, int titleLevel) =>
      [
        '${'#' * titleLevel} $name',
        '* ${exampleCode.githubMarkdownLink}',
        ..._createMarkDownExamplesFor(
            renderContext: renderContext,
            title: 'Data Types',
            exampleFactories: renderContext.engine.dataTypes,
            titleLevel: titleLevel + 1),
        ..._createMarkDownExamplesFor(
            renderContext: renderContext,
            title: 'Variables',
            exampleFactories: [VariableExamples()],
            titleLevel: titleLevel + 1),
        //TODO constants
        //TODO operators
        ..._createMarkDownExamplesFor(
            renderContext: renderContext,
            title: 'Functions',
            exampleFactories: renderContext.engine.functionGroups,
            titleLevel: titleLevel + 1)
      ];
}

List<String> _createMarkDownExamplesFor(
    {required RenderContext renderContext,
    title,
    required List<ExampleFactory> exampleFactories,
    required int titleLevel}) {
  if (exampleFactories.isEmpty) {
    return [];
  } else {
    return [
      '${'#' * (titleLevel)} $title',
      ...exampleFactories
          .map((dataType) =>
              dataType.createMarkdownExamples(renderContext, titleLevel + 1))
          .flattened
    ];
  }
}
