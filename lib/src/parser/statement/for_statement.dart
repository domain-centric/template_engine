import 'package:template_engine/template_engine.dart';

final forStatement = StatementDefinition(
  documentation: DefinitionDocumentation(
    title: 'For loop statement',
    description: 'A numeric for loop using `for` and `next`.',
    syntax: SyntaxDocumentation(
      codeBlockFunction: (delimiter) =>
          '${delimiter.start} for i = 1 to 10 ${delimiter.end}...${delimiter.start} next i ${delimiter.end}',
      explanationFunction: (delimiter) =>
          'Loop from start to end (inclusive). The loop variable is available '
          'inside the loop body and optionally checked on the matching `next`.',
    ),
    examples: [
      ExpressionBlockExample(
        (delimiter) =>
            '${delimiter.start} for i = 1 to 3 ${delimiter.end}${delimiter.start} i ${delimiter.end}${delimiter.start} next i ${delimiter.end}',
        shouldRender: '123',
      ),
      ExpressionBlockExample(
        (delimiter) =>
            '${delimiter.start} for i = 7 to 4 ${delimiter.end}${delimiter.start} i ${delimiter.end}${delimiter.start} next i ${delimiter.end}',
        shouldRender: '7654',
      ),
      TestFileExample.fromProjectFilePath(
        'test/src/parser/statement/for_statement_test.dart',
      ),
    ],
  ),
  reservedKeywords: {'for', 'next', 'to'},
  matches: (tokens) {
    final first = tokens.peek();
    final second = tokens.peek(offset: 1);
    return first.type == TokenType.reservedKeyword &&
        first.value.toLowerCase() == 'for' &&
        second.type != TokenType.reservedKeyword &&
        second.value.toLowerCase() != 'each';
  },
  parse: (parser, tokens) {
    tokens.consume(); // consume 'for'

    final variableToken = tokens.consume();
    final variableName = variableToken.value;

    tokens.consume(); // consume '='
    try {
      final startExpression = parser
          .createExpressionParser(tokens)
          .parseExpression();

      // expect 'to'
      final maybeTo = tokens.peek();
      if (maybeTo.value.toLowerCase() != 'to') {
        parser.errors.add(
          ParseError(
            'Expected `to` in for statement',
            parser.currentBlock.startLocation,
          ),
        );
      } else {
        tokens.consume();
      }

      final endExpression = parser
          .createExpressionParser(tokens)
          .parseExpression();

      parser.advanceBlock();

      final body = parser.parseUntil({'next'});

      final nextBlockTokens = parser.peekBlockTokens();
      if (nextBlockTokens != null &&
          nextBlockTokens.peek().value.toLowerCase() == 'next') {
        nextBlockTokens.consume(); // consume 'next'
        // optional variable name after next
        if (!nextBlockTokens.isAtEnd) {
          final name = nextBlockTokens.consume().value;
          if (name.toLowerCase() != variableName.toLowerCase()) {
            parser.errors.add(
              ParseError(
                'Mismatched loop variable in next: expected `$variableName`',
                nextBlockTokens.peek().location,
              ),
            );
          }
        }
        parser.advanceBlock();
      }

      return ForNode(variableName, startExpression, endExpression, body);
    } catch (_) {
      tokens.consumeRemaining();
      rethrow;
    }
  },
);
