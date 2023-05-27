import 'package:logging/logging.dart';
import 'package:petitparser/petitparser.dart';
import 'package:template_engine/src/parser/map2_parser_extension.dart';
import 'package:template_engine/src/parser/generic_parsers.dart';
import 'package:template_engine/src/render.dart';
import 'package:template_engine/src/tag/group.dart';
import 'package:template_engine/src/template.dart';
import 'package:template_engine/src/template_engine.dart';
import 'package:template_engine/src/variable/variable.dart';

/// Creates a parser that can convert a [Template] text to a
/// [parse tree](https://en.wikipedia.org/wiki/Parse_tree)
/// containing [RenderNode]s.
Parser<List<RenderNode>> templateParser(ParserContext context) =>
    delegatingParser([variableParser(context)]);

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

Parser<RenderNode> variableParser(ParserContext context) =>
    (string(context.tagStart) &
            whiteSpaceParser().optional() &
            variableNamePathParser() &
            whiteSpaceParser().optional() &
            string(context.tagEnd))
        .map2((values, position) => VariableNode(
            templateSection: TemplateSection(
              template: context.template,
              parserPosition: position,
            ),
            namePath: values[2]));

Parser variableNameParser() => (letter() | digit()).plus().flatten();

Parser variableNamePathParser() =>
    (variableNameParser() & (char('.') & variableNameParser()).star())
        .flatten();

class ParserWarning {
  final TemplateSection templateSection;
  final String message;

  ParserWarning(
    this.templateSection,
    this.message,
  );

  @override
  String toString() => 'Parser warning: $message\n'
      'Template source: ${templateSection.template.source}\n'
      'Template location: ${templateSection.parserPosition}\n';
}

class ParseException implements Exception {
  final String message;
  ParseException(this.message);
}

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

  /// for logging parsing errors or warnings.
  final Logger logger;

  ParserContext({
    required this.template,
    required this.tagGroups,
    this.variables = const {},
    this.tagStart = '{{',
    this.tagEnd = '}}',
    required this.logger,
  });
}
