import 'package:petitparser/petitparser.dart';
import 'package:template_engine/src/generic_parser/map2_parser_extension.dart';
import 'package:template_engine/template_engine.dart';

class InvalidTagParser extends Parser<String> {
  final ParserContext context;
  late Parser<String> internalParser;
  late List<Parser<Map<String, Object>>> tagFunctionAttributeErrorParsers;

  InvalidTagParser(this.context) {
    internalParser = createInternalParser();
    tagFunctionAttributeErrorParsers = context.tags
        .whereType<TagFunction>()
        .map((tagFunction) => tagFunction
            .createTagFunctionParserThatReturnsMapWithAttributeErrors(context))
        .toList();
  }

  @override
  Parser<String> copy() => InvalidTagParser(context);

  @override
  Result<String> parseOn(Context context) => internalParser.parseOn(context);

  Parser<String> createInternalParser() => (string(context.tagStart) &
              optionalWhiteSpace().optional() &
              untilEndOfTagParser(context.tagStart, context.tagEnd) &
              optionalWhiteSpace().optional() &
              string(context.tagEnd))
          .map2((values, parserPosition) {
        var source = TemplateSource(
          template: context.template,
          parserPosition: parserPosition,
        );

        var tag = values.join();

        var errors = findTagFunctionsWithAttributeErrors(tag);
        if (errors.isEmpty) {
          errors.add(Error(
              stage: ErrorStage.parse,
              message: 'Invalid tag.',
              source: source));
        }

        context.errors.addAll(errors);

        return tag;
      });

  List<Error> findTagFunctionsWithAttributeErrors(String tag) {
    for (var parser in tagFunctionAttributeErrorParsers) {
      var result = parser.parse(tag);
      if (result.isSuccess) {
        return (result.value as Map<String, Error>).values.toList();
      }
    }
    return [];
  }
}

/// Adds an error if a [Tag] end is found but not a  [Tag] start.
/// It replaces the [Tag] end to a [String] e.g. containing: }}
Parser<String> missingTagStartParser(ParserContext context) =>
    string(context.tagEnd).map2((value, parsePosition) {
      context.errors.add(Error(
          stage: ErrorStage.parse,
          message: 'Found tag end: ${context.tagEnd}, '
              'but it was not preceded with a tag start: ${context.tagStart}',
          source: TemplateSource(
              template: context.template, parserPosition: parsePosition)));
      return value;
    });

// Adds an error if a [Tag] start is found but no [Tag] start because if
/// they are both present they would have been parsed already.
/// It replaces the [Tag] end to a [String] e.g. containing: {{
Parser<String> missingTagEndParser(ParserContext context) =>
    (string(context.tagStart) & any().star() & string(context.tagEnd).not())
        .map2((values, parsePosition) {
      context.errors.add(Error(
          stage: ErrorStage.parse,
          message: 'Found tag start: ${context.tagStart}, '
              'but it was not followed with a tag end: ${context.tagEnd}',
          source: TemplateSource(
              template: context.template, parserPosition: parsePosition)));
      return values.first;
    });
