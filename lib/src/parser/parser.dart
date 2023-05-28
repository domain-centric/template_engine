import 'package:petitparser/petitparser.dart';
import 'package:template_engine/src/event.dart';
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

Parser<RenderNode> variableParser(ParserContext context) =>
    (string(context.tagStart) &
            whiteSpaceParser().optional() &
            VariableNamePathParser(context) &
            whiteSpaceParser().optional() &
            string(context.tagEnd))
        .map2((values, position) => VariableNode(
            source: TemplateSection(
              template: context.template,
              parserPosition: position,
            ),
            namePath: values[2]));

Parser variableNameParser() => (letter() | digit()).plus().flatten();

class VariableNamePathParser extends Parser<String> {
  VariableNamePathParser(ParserContext context)
      : _parser = _createParser(context);

  final Parser<String> _parser;

  @override
  Parser<String> copy() => _parser.copy();

  @override
  Result<String> parseOn(Context context) => _parser.parseOn(context);

  static Parser<String> _createParser(ParserContext context) {
    var variables = context.variables;
    if (variables.isEmpty) {
      return string('Never supposed to find this when there are no variables');
    } else {}
    return ChoiceParser<String>(_createNamePathParsers(variables));
  }

  static List<Parser<String>> _createNamePathParsers(
      Map<String, Object> variables,
      [String parentPath = '']) {
    List<Parser<String>> namePathParsers = [];
    for (String name in variables.keys) {
      //TODO validate name
      String namePath = _createNamePath(parentPath, name);
      namePathParsers.add(string(namePath));
      var value = variables[name];
      if (value is Map<String, Object>) {
        // recursive call
        // TODO do we need to add something to prevent endless round trips?
        namePathParsers.addAll(_createNamePathParsers(value, namePath));
      }
    }
    return namePathParsers;
  }

  static String _createNamePath(String parentPath, String name) {
    if (parentPath.isEmpty) {
      return name;
    } else {
      return '$parentPath.$name';
    }
  }
}

Parser<RenderNode> unknownTagOrVariableParser(ParserContext context) =>
    (string(context.tagStart) &
            whiteSpaceParser().optional() &
            // any text up unit the Tag end
            any().starLazy(string(context.tagEnd)) &
            whiteSpaceParser().optional() &
            string(context.tagEnd))
        .map2((values, parserPosition) {
      context.events.add(Event.parseWarning(
          'Unknown tag or variable.',
          TemplateSection(
            template: context.template,
            parserPosition: parserPosition,
          )));
      return TextNode(values.join());
    });

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
