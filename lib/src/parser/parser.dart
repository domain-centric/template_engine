// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';
import 'package:petitparser/petitparser.dart';

import 'package:template_engine/template_engine.dart';

Parser<String> optionalWhiteSpace() => whitespace().star().flatten();

// /// Creates a parser that can convert a [Template] text to a
// /// [parse tree](https://en.wikipedia.org/wiki/Parse_tree)
// /// containing [Renderer]s.
// ///
// /// Note that:
// /// * Errors or warnings are stored in [ParserContext.errors]
// ///   and are can be later accessed in the [TemplateParseResult].
// /// * The start en end of a [Tag] or [Variable] can be escaped so that you
// ///   can use them in a [Template] without being parsed as [Tag] or [Variable].
// ///   e.g. \{{ this is not a tag or variable and does not throw errors \}}
// Parser<List<Object>> templateParser(ParserContext context) =>
//     TemplateParser(context);
//{
//   //context.variables.validateNames();
//   return delegatingParser(
//     delegates: [
//       escapedTagStartParser(context.engine.tagStart),
//       escapedTagEndParser(context.engine.tagEnd),
//       ...context.engine.tags.map((tag) => tag.createTagParser(context)),
//       InvalidTagParser(context),
//       missingTagStartParser(context),
//       missingTagEndParser(context),
//     ],
//     tagStart: context.engine.tagStart,
//     tagEnd: context.engine.tagEnd,
//   );
// }

// /// A [delegatingParser] delegates to work to other parsers.
// /// Text that is not handled by the delegates will also be collected
// Parser<List<Object>> delegatingParser({
//   required List<Parser<Object>> delegates,
//   required String tagStart,
//   required String tagEnd,
// }) {
//   if (delegates.isEmpty) {
//     return any().star().flatten().map((value) => [value]);
//   }

//   var parser = ChoiceParser<Object>([
//     ChoiceParser<Object>(delegates),
//     untilEndOfTagParser(tagStart, tagEnd),
//     untilEndParser(),
//   ]);
//   return parser.plus();
// }

Parser<String> untilTagStartOrEndParser(String tagStart, String tagEnd) => any()
    .plusLazy(
      ChoiceParser([
        string('\\$tagStart'),
        string('\\$tagEnd'),
        string(tagStart),
        string(tagEnd),
      ]),
    )
    .flatten();

Parser<String> untilEndParser() => any().plus().flatten();

/// Replaces an escaped [Tag] start (e.g. : \{{ )
/// to a [String] e.g. containing:  {{ (without escape)
/// so that it is not parsed as a [Tag] or [Variable]
Parser<String> escapedTagStartParser(String tagStart) =>
    string('\\$tagStart').map((value) => tagStart);

/// Replaces an escaped [Tag] end (e.g. : \}} )
/// to a [String] e.g. containing: }} (without escape)
/// so that it is not parsed as a [Tag] or [Variable]
Parser<String> escapedTagEndParser(String tagEnd) =>
    string('\\$tagEnd').map((value) => tagEnd);

class ParserContext {
  /// The template being parsed (for error or warning logging)
  final Template template;

  TemplateEngine engine;

  final List<ParseError> errors;

  ParserContext(this.engine, this.template) : errors = [];
}

/// The result of parsing a single [Template]
class TemplateParseResult extends ParserTree<Object> {
  final List<ParseError> errors;
  final Template template;

  TemplateParseResult({
    required this.template,
    required List<Object> children,
    this.errors = const [],
  }) : super(children);

  String get errorMessage {
    if (errors.isEmpty) {
      return '';
    }
    if (errors.length == 1) {
      return 'Parse error in: ${template.sourceTitle}:\n'
          '${errors.map((error) => '  $error').join('\n')}';
    }
    return 'Parse errors in: ${template.sourceTitle}:\n'
        '${errors.map((error) => '  $error').join('\n')}';
  }
}

/// The result of parsing one or more [Template]s
class ParseResult extends ParserTree<TemplateParseResult> {
  ParseResult(super.templateParseResults);

  String get errorMessage => children
      .where((result) => result.errorMessage.isNotEmpty)
      .map((result) => result.errorMessage)
      .join('\n');
}

/// A parser that converts a [Template] text to a
/// list of objects that can be converted or rendered to one result [String].
///
/// Note that:
/// * Errors or warnings are stored in [ParserContext.errors]
///   and are can be later accessed in the [TemplateParseResult].
/// * The start en end of a [Tag] or [Variable] can be escaped so that you
///   can use them in a [Template] without being parsed as [Tag] or [Variable].
///   e.g. \{{ this is not a tag or variable and does not throw errors \}}
class TemplateParser extends Parser<List<Object>> {
  ///TODO get rid of [parseContext]: [TemplateParser] could be a [ParserContext] itself
  final ParserContext parserContext;
  final List<Parser> parsers;

  TemplateParser(this.parserContext) : parsers = createParsers(parserContext);

  @override
  Parser<List<Object>> copy() => TemplateParser(parserContext);

  @override
  Result<List<Object>> parseOn(Context context) {
    int start = 0;
    var input = context.buffer;
    var ast = AbstractStatementTree(parserContext);
    while (start < input.length) {
      var result = findResult(input, start);
      if (result is Failure) {
        return result;
      }
      var token = result.value;
      ast.process(token);
      start = result.position;
    }
    ast.verifyIfClosed();
    return context.success(
      ast.rootBranch,
    ); //TODO return ast (where ast is a TemplateResult???)
  }

  Result findResult(String input, int start) {
    for (var parser in parsers) {
      var result = parser.parse(input, start: start);
      if (result is Success && result.position > start) {
        return result;
      }
    }
    return Failure(input, start, 'Could not find a parser to consume input');
  }

  static List<Parser> createParsers(ParserContext context) => [
    escapedTagStartParser(context.engine.tagStart),
    escapedTagEndParser(context.engine.tagEnd),
    ...context.engine.tags.map((tag) => tag.createTagParser(context)),
    InvalidTagParser(context),
    missingTagStartParser(context),
    missingTagEndParser(context),
    textParser(context),
  ];
}

TextParser textParser(ParserContext context) => TextParser(context);

class TextParser extends Parser<String> {
  final ParserContext parserContext;
  TextParser(this.parserContext)
    : parser = untilTagStartOrEndParser(
        parserContext.engine.tagStart,
        parserContext.engine.tagEnd,
      );
  final Parser<String> parser;

  @override
  Parser<String> copy() => TextParser(parserContext);

  @override
  Result<String> parseOn(Context context) {
    var result = parser.parseOn(context);
    if (result is Success) {
      // until tagStart Or tagEnd
      return result;
    }
    // rest of input
    var rest = context.buffer.substring(context.position);
    return context.success(rest, context.position + rest.length);
  }
}

/// Result of [TemplateParser]
class AbstractStatementTree {
  final ParserContext context;
  final Branch rootBranch = Branch();
  late Branch currentBranch = rootBranch;

  AbstractStatementTree(this.context);

  void verifyIfClosed() {
    if (currentBranch != rootBranch) {
      var parent = findParentNodeOfCurrentBranch()!;
      context.errors.add(
        ParseError(
          '${parent.runtimeType} tag is not followed by '
          '${(parent as TagSequence).followedBy.join(' or ')} tag',
          parent.position,
        ),
      );
    }
  }

  void process(Object token) {
    if (token is UnsupportedTagSyntax) {
      context.errors.add(
        ParseError(
          'Unsupported tag syntax: "${token.content}"',
          token.position,
        ),
      );
      return;
    }

    if (token is BranchChanger) {
      var tagSequence = (token as TagSequence);
      if (tagSequence.precededBy.isNotEmpty) {
        var parentNode = findParentNodeOfCurrentBranch();
        if (!tagSequence.precededBy.any(
          (type) => parentNode.runtimeType == type,
        )) {
          context.errors.add(
            ParseError(
              '${token.runtimeType} tag is not preceded by '
              '${tagSequence.precededBy.join(' or ')} tag',
              token.position,
            ),
          );
        }
      }
      currentBranch = token.nextBranch(this);
    } else {
      currentBranch.add(token);
    }
  }

  Branch findParentBranchOfCurrentBranch() =>
      rootBranch.findParentBranch(currentBranch)!;

  BranchOwner? findParentNodeOfCurrentBranch() =>
      rootBranch.findParentNode(currentBranch)!;
}

/// Represents a part of the template text as an object.
/// Different texts can be converted to different objects.
/// See the implementations of [Token2]
abstract class Token2 {
  /// The position where the [Token2]
  /// originated from (needed for errors or warnings)
  Position get position;
}

/// Defines the order tags should follow each other
abstract class TagSequence {
  List<Type> get precededBy;
  List<Type> get followedBy;
}

abstract class BranchChanger implements Token2, TagSequence {
  /// returns the next branch on which to continue adding [Token]s
  Branch nextBranch(AbstractStatementTree ast);
}

abstract class BranchOwner implements Token2, TagSequence {
  List<Branch> get branches;
}

class Branch extends DelegatingList<Object> {
  Branch() : super([]);

  Branch? findParentBranch(Branch branchToFind) {
    for (var node in this) {
      if (node is BranchOwner) {
        for (var branch in node.branches) {
          if (branch == branchToFind) {
            return this;
          }
          // Recursively search in child branches
          for (var childNode in branch) {
            if (childNode is BranchOwner) {
              var parent = branch.findParentBranch(branchToFind);
              if (parent != null) {
                return parent;
              }
            }
          }
        }
      }
    }
    return null;
  }

  BranchOwner? findParentNode(Branch branchToFind) {
    for (var node in this) {
      if (node is BranchOwner) {
        for (var branch in node.branches) {
          if (branch == branchToFind) {
            return node;
          }
          // Recursively search in child branches
          for (var childNode in branch) {
            if (childNode is BranchOwner) {
              var parent = branch.findParentNode(branchToFind);
              if (parent != null) {
                return parent;
              }
            }
          }
        }
      }
    }
    return null;
  }
}

class UnsupportedTagSyntax implements Token2 {
  @override
  final Position position;
  final String content;

  @override
  String toString() => 'UnSupportedTagToken("$content")';

  UnsupportedTagSyntax(this.content, this.position);
}

class Position {
  final int line;
  final int column;

  Position({required this.line, required this.column});

  Position.unknown() : line = -1, column = -1;

  factory Position.ofContext(Context context) {
    var line = 1, offset = 0;
    for (final token in newline().token().allMatches(context.buffer)) {
      if (context.position < token.stop) {
        return Position(line: line, column: context.position - offset + 1);
      }
      line++;
      offset = token.stop;
    }
    return Position(line: line, column: context.position - offset + 1);
  }

  @override
  String toString() => line < 0 || column < 0 ? '?' : '$line:$column';
}
