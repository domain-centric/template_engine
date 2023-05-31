import 'package:petitparser/parser.dart';
import 'package:template_engine/src/error.dart';
import 'package:template_engine/src/generic_parser/map2_parser_extension.dart';
import 'package:template_engine/src/tag/group.dart';
import 'package:template_engine/src/variable/variable_renderer.dart';
import 'package:template_engine/template_engine.dart';

import '../variable/variable_parser.dart';
import 'error_parser.dart';

Parser whiteSpaceParser() => whitespace().star().flatten();

Parser intParser() => digit().plus().flatten().map(int.parse);

/// Creates a parser that can convert a [Template] text to a
/// [parse tree](https://en.wikipedia.org/wiki/Parse_tree)
/// containing [RenderNode]s.
///
/// Note that:
/// * Errors or warnings are stored in [ParserContext.errors]
///   and are later thrown by the [TemplateEngine.parse] method.
/// * The start en end of a [Tag] or [Variable] can be escaped so that you
///   can use them in a [Template] without being parsed as [Tag] or [Variable].
///   e.g. \{{ this is not a tag or variable and does not throw errors \}}
Parser<List<RenderNode>> templateParser(ParserContext context) =>
    delegatingParser([
      escapedTagStartParser(context),
      escapedTagEndParser(context),
      variableParser(context),
      unknownTagOrVariableParser(context),
      missingTagStartParser(context),
      missingTagEndParser(context),
    ]);

/// Replaces an escaped [Tag] start (e.g. : /{{ )
/// to a [TextNode] e.g. containing:  {{ (without escape)
/// so that it is not parsed as a [Tag] or [Variable]
Parser<TextNode> escapedTagStartParser(ParserContext context) =>
    string('\\${context.tagStart}').map((value) => TextNode(context.tagStart));

/// Replaces an escaped [Tag] end (e.g. : /}} )
/// to a [TextNode] e.g. containing: }} (without escape)
/// so that it is not parsed as a [Tag] or [Variable]
Parser<TextNode> escapedTagEndParser(ParserContext context) =>
    string('\\${context.tagEnd}').map((value) => TextNode(context.tagEnd));

/// Adds an event if a [Tag] start is found without a following [Tag] end
/// It replaces the [Tag] start to a [TextNode] e.g. containing: {{
Parser<TextNode> missingTagEndParser(ParserContext context) =>
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

/// Adds an event if a [Tag] end is found but no [Tag] start because if
/// they are both present they would have been parsed already.
/// It replaces the [Tag] end to a [TextNode] e.g. containing: }}
Parser<TextNode> missingTagStartParser(ParserContext context) =>
    string(context.tagEnd).map2((value, parsePosition) {
      context.errors.add(Error(
          stage: ErrorStage.parse,
          message: 'Found tag end: ${context.tagEnd}, '
              'but it was not preceded with a tag start: ${context.tagStart}',
          source: ErrorSource(
              template: context.template, parserPosition: parsePosition)));
      return TextNode(value.toString());
    });

/// A [delegatingParser] delegates to work to other parsers.
/// Text that is not handled by the delegates will also be collected
Parser<List<RenderNode>> delegatingParser(List<Parser<RenderNode>> delegates) {
  if (delegates.isEmpty) {
    return any().star().flatten().map((value) => [TextNode(value)]);
  }
  var parser = ChoiceParser<RenderNode>(delegates);
  parser = ChoiceParser<RenderNode>([
    parser,
    untilParser(parser),
    untilEndParser(),
  ]);
  return parser.plus();
}

Parser<RenderNode> untilParser(Parser limit) =>
    any().plusLazy(limit).flatten().map((value) => TextNode(value));

Parser<RenderNode> untilEndParser() =>
    any().plus().flatten().map((value) => TextNode(value));

class ParserContext {
  /// The template being parsed (for error or warning logging)
  final Template template;

  /// See [tagGroups] doc in [TemplateEngine] constructor
  final TagGroups tagGroups;

  /// See [variables] doc in [TemplateEngine] constructor
  final Map<String, Object> variables; //T

  /// See [tagStart] doc in [TemplateEngine] constructor
  final String tagStart;

  /// See [tagEnd] doc in [TemplateEngine] constructor
  final String tagEnd;

  final List<Error> errors;

  ParserContext({
    required this.template,
    required this.tagGroups,
    this.variables = const {},
    this.tagStart = '{{',
    this.tagEnd = '}}',
  }) : errors = [];
}

class ParseResult extends ParentNode {
  final List<Error> errors;

  ParseResult({
    required List<RenderNode> children,
    this.errors = const [],
  }) : super(children);

  String get errorMessage =>
      errors.map((event) => event.toString()).toSet().join('\n');
}
