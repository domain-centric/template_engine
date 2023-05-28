import 'package:petitparser/parser.dart';
import 'package:template_engine/src/event.dart';
import 'package:template_engine/src/tag/group.dart';
import 'package:template_engine/template_engine.dart';

import '../variable/variable_parser.dart';
import 'error_parser.dart';

Parser whiteSpaceParser() => whitespace().star().flatten();

Parser intParser() => digit().plus().flatten().map(int.parse);

/// Creates a parser that can convert a [Template] text to a
/// [parse tree](https://en.wikipedia.org/wiki/Parse_tree)
/// containing [RenderNode]s.
Parser<List<RenderNode>> templateParser(ParserContext context) =>
    delegatingParser(
        [variableParser(context), unknownTagOrVariableParser(context)]);

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
  return parser.star();
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

  final List<Event> events;

  ParserContext({
    required this.template,
    required this.tagGroups,
    this.variables = const {},
    this.tagStart = '{{',
    this.tagEnd = '}}',
  }) : events = [];
}

class ParseException implements Exception {
  final List<Event> events;
  final String message;

  ParseException(this.events)
      : message = events.map((event) => event.toString()).join('\n\n');

  @override
  String toString() => message;
}
