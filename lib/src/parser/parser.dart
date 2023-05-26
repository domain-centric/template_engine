import 'package:logging/logging.dart';
import 'package:petitparser/petitparser.dart';
import 'package:template_engine/src/parser/generic_parsers.dart';
import 'package:template_engine/src/render.dart';
import 'package:template_engine/src/tag/group.dart';
import 'package:template_engine/src/template.dart';
import 'package:template_engine/src/template_engine.dart';
import 'package:template_engine/src/variable/variable.dart';

/// Creates a parser that can convert a [Template] text to a
/// [parse tree](https://en.wikipedia.org/wiki/Parse_tree)
/// containing [String]s and [RenderNode]s.
///
/// It does this by combining multiple on a OR chain,
/// that could be repeated zero or more times.
Parser templateParser(ParserContext context) =>
    delegatingParser([variableParser(context) ]);


/// A [delegatingParser] delegates to work to other parsers.
Parser delegatingParser(List<Parser> delegates) {
  if (delegates.isEmpty) {
    return any().star().flatten().map((value) => [TextNode(value)]);
  }
  Parser parser = delegates.first;
  for (var delegate in delegates.sublist(1)) {
    parser = (parser |delegate) ;
  }
  // add a parser that takes what the other parsers could not get
  parser=parser | untilParser(parser);
   // add parser that takes what the other parsers could not get
  parser=parser | untilEndParser();
  // repeat all previous parsers as many times as possible
  parser=parser.star();
 
  return parser ;
}

Parser untilParser(Parser limit) => any().plusGreedy(limit).flatten().map((value) => TextNode(value));

Parser untilEndParser() => any().plus().flatten().map((value) => TextNode(value));

/// You can make a [Parser] that combines other [Parser]s in a OR chain.
/// Add a [remainingCharParser] at the end so that any characters that are not
/// processed by other [Parser]s is collected as a [String].
/// It is collected as a single character to implement a lazy parser.
@Deprecated('See restParser')
Parser<String> remainingCharParser() => any();

Parser variableParser(ParserContext context) => (string(context.tagStart) &
        whiteSpaceParser().optional() &
        variableNamePathParser() &
        whiteSpaceParser().optional() &
        string(context.tagEnd))
    .map((values) => VariableNode(
        templateSection: TemplateSection(
            //TODO experiment: Can VariableNode throw an error here, hoping that PetiteParser will continue and collect errors. If so remove TemplateSection
            text: values[2],
            row: -1,
            column: -1,
            template: TextTemplate('dummy')),
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
      'Template location: ${templateSection.row}:${templateSection.column}\n'
      'Template section: ${templateSection.text}\n';
}

class ParseException implements Exception {
  final String message;
  ParseException(this.message);
}

class ParserContext {
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
    required this.tagGroups,
    this.variables = const {},
    this.tagStart = '{{',
    this.tagEnd = '}}',
    required this.logger,
  });
}
