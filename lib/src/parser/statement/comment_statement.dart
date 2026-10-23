import 'package:template_engine/template_engine.dart';

final commentStatement = StatementDefinition(
  documentation: DefinitionDocumentation(
    title: 'Comment statement',
    description:
        'A comment statement is a placeholder for comments for developers. '
        'A comment statement is ignored during rendering.',
    syntax: SyntaxDocumentation(
      codeBlockFunction: (delimiter) =>
          '${delimiter.start} // This is a comment ${delimiter.end}',
      explanationFunction: (delimiter) =>
          'Comments start with `//` and continue until the end of the line. '
          'For multiline comments, you can use multiple lines starting with `//`.',
    ),
    examples: [
      ExpressionBlockExample(
        (delimiter) =>
            '${delimiter.start} // This is a comment ${delimiter.end}',
        shouldRender: '',
      ),
      ExpressionBlockExample(
        (delimiter) =>
            '${delimiter.start}  // This is a<br>'
            '      multiline comment ${delimiter.end}',
        shouldRender: '',
      ),
      TestFileExample.fromProjectFilePath(
        'test/src/parser/statement/comment_statement_test.dart',
      ),
    ],
  ),
  reservedKeywords: {}, // '//' is not a keyword!
  matches: (tokens) {
    final first = tokens.peek(offset: 0);
    final second = tokens.peek(offset: 1);
    return (first.value == '/') && (second.value == '/');
  },
  parse: (parser, tokens) => CommentNode(),
);
