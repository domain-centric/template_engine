import 'package:petitparser/parser.dart';
import 'package:template_engine/src/error.dart';
import 'package:template_engine/src/tag/group.dart';
import 'package:template_engine/src/tag/tag_parser.dart';
import 'package:template_engine/src/variable/variable.dart';
import 'package:template_engine/template_engine.dart';

import '../variable/variable_parser.dart';
import 'error_parser.dart';

Parser whiteSpaceParser() => whitespace().star().flatten();

Parser intParser() => digit().plus().flatten().map(int.parse);

/// Creates a parser that can convert a [Template] text to a
/// [parse tree](https://en.wikipedia.org/wiki/Parse_tree)
/// containing [Renderer]s.
///
/// Note that:
/// * Errors or warnings are stored in [ParserContext.errors]
///   and are later thrown by the [TemplateEngine.parse] method.
/// * The start en end of a [Tag] or [Variable] can be escaped so that you
///   can use them in a [Template] without being parsed as [Tag] or [Variable].
///   e.g. \{{ this is not a tag or variable and does not throw errors \}}
Parser<List<Object>> templateParser(ParserContext context) {
  context.variables.validateNames();
  var tagParser = createTagParser(context);
  var variableParser = createVariableParser(context);
  return delegatingParser(
    delegates: [
      escapedTagStartParser(context),
      escapedTagEndParser(context),
      if (tagParser != null) tagParser,
      if (variableParser != null) variableParser,
      unknownTagOrVariableParser(context),
      missingTagStartParser(context),
      missingTagEndParser(context),
    ],
    tagStart: context.tagStart,
    tagEnd: context.tagEnd,
  );
}

/// A [delegatingParser] delegates to work to other parsers.
/// Text that is not handled by the delegates will also be collected
Parser<List<Object>> delegatingParser({
  required List<Parser<Object>> delegates,
  required String tagStart,
  required String tagEnd,
}) {
  if (delegates.isEmpty) {
    return any().star().flatten().map((value) => [value]);
  }

  var parser = ChoiceParser<Object>([
    ChoiceParser<Object>(delegates),
    untilParser(tagStart, tagEnd),
    untilEndParser(),
  ]);
  return parser.plus();
}

Parser<String> untilParser(String tagStart, String tagEnd) => any()
    .plusLazy(ChoiceParser([
      string('\\$tagStart'),
      string('\\$tagEnd'),
      string(tagStart),
      string(tagEnd),
    ]))
    .flatten()
    .map((value) => value);

Parser<String> untilEndParser() => any().plus().flatten().map((value) => value);

/// Replaces an escaped [Tag] start (e.g. : /{{ )
/// to a [String] e.g. containing:  {{ (without escape)
/// so that it is not parsed as a [Tag] or [Variable]
Parser<String> escapedTagStartParser(ParserContext context) =>
    string('\\${context.tagStart}').map((value) => context.tagStart);

/// Replaces an escaped [Tag] end (e.g. : /}} )
/// to a [String] e.g. containing: }} (without escape)
/// so that it is not parsed as a [Tag] or [Variable]
Parser<String> escapedTagEndParser(ParserContext context) =>
    string('\\${context.tagEnd}').map((value) => context.tagEnd);

class ParserContext {
  /// The template being parsed (for error or warning logging)
  final Template template;

  /// See [tagGroups] doc in [TemplateEngine] constructor
  final TagGroups tagGroups;

  /// See [variables] doc in [TemplateEngine] constructor
  final Variables variables;

  /// See [tagStart] doc in [TemplateEngine] constructor
  final String tagStart;

  /// See [tagEnd] doc in [TemplateEngine] constructor
  final String tagEnd;

  final List<Error> errors;

  ParserContext({
    required this.template,
    required this.tagGroups,
    this.variables = const Variables({}),
    this.tagStart = '{{',
    this.tagEnd = '}}',
  }) : errors = [];
}

class ParseResult extends ParserTree {
  final List<Error> errors;

  ParseResult({
    required List<Object> children,
    this.errors = const [],
  }) : super(children);

  String get errorMessage => errors.map((error) => error.toString()).join('\n');
}
