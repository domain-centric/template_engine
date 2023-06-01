import 'package:petitparser/petitparser.dart';
import 'package:template_engine/src/error.dart';
import 'package:template_engine/src/generic_parser/map2_parser_extension.dart';
import 'package:template_engine/template_engine.dart';

Parser<RenderNode> unknownTagOrVariableParser(ParserContext context) =>
    (string(context.tagStart) &
            whiteSpaceParser().optional() &
            // any text up unit the Tag end
            any().starLazy(string(context.tagEnd)).flatten() &
            whiteSpaceParser().optional() &
            string(context.tagEnd))
        .map2((values, parserPosition) {
      context.errors.add(Error(
          stage: ErrorStage.parse,
          message: 'Unknown tag or variable.',
          source: ErrorSource(
            template: context.template,
            parserPosition: parserPosition,
          )));
      return TextNode(values.join());
    });

/// Adds an error if a [Tag] end is found but no [Tag] start because if
/// they are both present they would have been parsed already.
/// It replaces the [Tag] end to a [TextNode] e.g. containing: }}
Parser<RenderNode> missingTagStartParser(ParserContext context) =>
    string(context.tagEnd).map2((value, parsePosition) {
      context.errors.add(Error(
          stage: ErrorStage.parse,
          message: 'Found tag end: ${context.tagEnd}, '
              'but it was not preceded with a tag start: ${context.tagStart}',
          source: ErrorSource(
              template: context.template, parserPosition: parsePosition)));
      return TextNode(value.toString());
    });

// Adds an error if a [Tag] start is found but no [Tag] start because if
/// they are both present they would have been parsed already.
/// It replaces the [Tag] end to a [TextNode] e.g. containing: {{
Parser<RenderNode> missingTagEndParser(ParserContext context) =>
    (string(context.tagStart) & any().star() & string(context.tagEnd).not())
        .map2((values, parsePosition) {
      context.errors.add(Error(
          stage: ErrorStage.parse,
          message: 'Found tag start: ${context.tagStart}, '
              'but it was not followed with a tag end: ${context.tagEnd}',
          source: ErrorSource(
              template: context.template, parserPosition: parsePosition)));
      return TextNode(values.first.toString());
    });
