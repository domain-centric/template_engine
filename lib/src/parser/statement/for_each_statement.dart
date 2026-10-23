import 'package:template_engine/template_engine.dart';

final forEachStatement = StatementDefinition(
  documentation: DefinitionDocumentation(
    title: 'For each loop statement',
    description:
        'Iterate over an iterable or collection using `for each` and `next <variable>`.',
    syntax: SyntaxDocumentation(
      codeBlockFunction: (delimiter) =>
          '${delimiter.start} for each item in items ${delimiter.end}...${delimiter.start} next item ${delimiter.end}',
      explanationFunction: (delimiter) =>
          'Iterate over each value in the provided iterable or collection. '
          'The loop variable is available inside the loop body and the '
          'closing `next` must use the same variable name.',
    ),
    examples: [
      ExpressionBlockExample(
        (delimiter) =>
            '${delimiter.start} for each item in items ${delimiter.end}'
            '${delimiter.start} item ${delimiter.end}'
            '${delimiter.start} next item ${delimiter.end}',
        shouldRender: 'ABC',
        variables: {
          'items': ['A', 'B', 'C'],
        },
      ),
      TestFileExample.fromProjectFilePath(
        'test/src/parser/statement/for_each_statement_test.dart',
      ),
    ],
  ),
  reservedKeywords: {'for', 'each', 'in', 'next'},
  matches: (tokens) {
    final first = tokens.peek();
    final second = tokens.peek(offset: 1);
    return first.type == TokenType.reservedKeyword &&
        first.value.toLowerCase() == 'for' &&
        second.type == TokenType.reservedKeyword &&
        second.value.toLowerCase() == 'each';
  },
  parse: (parser, tokens) {
    tokens.consume(); // consume 'for'

    final eachToken = tokens.peek();
    if (eachToken.value.toLowerCase() != 'each') {
      parser.errors.add(
        ParseError(
          'Expected `each` in for each statement',
          parser.currentBlock.startLocation,
        ),
      );
    } else {
      tokens.consume(); // consume 'each'
    }

    final variableToken = tokens.consume();
    final variableName = variableToken.value;

    final inToken = tokens.peek();
    if (inToken.value.toLowerCase() != 'in') {
      parser.errors.add(
        ParseError(
          'Expected `in` in for each statement',
          parser.currentBlock.startLocation,
        ),
      );
    } else {
      tokens.consume(); // consume 'in'
    }

    try {
      final iterableExpression = parser
          .createExpressionParser(tokens)
          .parseExpression();

      parser.advanceBlock();

      final body = parser.parseUntil({'next'});

      final nextBlockTokens = parser.peekBlockTokens();
      if (nextBlockTokens != null &&
          nextBlockTokens.peek().value.toLowerCase() == 'next') {
        nextBlockTokens.consume(); // consume 'next'
        if (!nextBlockTokens.isAtEnd) {
          var location = nextBlockTokens.currentLocation;
          final name = nextBlockTokens.consume().value;
          if (name.toLowerCase() != variableName.toLowerCase()) {
            parser.errors.add(
              ParseError(
                'Mismatched loop variable in next: expected `$variableName`',
                location,
              ),
            );
          }
        }
        parser.advanceBlock();
      }

      return ForEachNode(variableName, iterableExpression, body);
    } catch (_) {
      tokens.consumeRemaining();
      rethrow;
    }
  },
);
