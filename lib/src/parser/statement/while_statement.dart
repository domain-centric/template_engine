import 'package:template_engine/template_engine.dart';

final whileStatement = StatementDefinition(
  documentation: DefinitionDocumentation(
    title: 'While loop statement',
    description:
        'Loop while a condition is true using `while ... do` and `endwhile`.',
    syntax: SyntaxDocumentation(
      codeBlockFunction: (delimiter) =>
          '${delimiter.start} while condition do ${delimiter.end}...${delimiter.start} endwhile ${delimiter.end}',
      explanationFunction: (delimiter) =>
          'Evaluate condition before each loop iteration. Continue looping '
          'while the condition is truthy. Terminate the loop with `endwhile`.',
    ),
    examples: [
      ExpressionBlockExample(
        (delimiter) =>
            '${delimiter.start} count = 0 ${delimiter.end}'
            '${delimiter.start} while count < 3 do ${delimiter.end}'
            '${delimiter.start} count = count + 1 ${delimiter.end}'
            '${delimiter.start} count ${delimiter.end}'
            '${delimiter.start} endwhile ${delimiter.end}',
        shouldRender: '123',
      ),
      TestFileExample.fromProjectFilePath(
        'test/src/parser/statement/while_statement_test.dart',
      ),
    ],
  ),
  reservedKeywords: {'while', 'do', 'endwhile'},
  matches: (tokens) {
    final first = tokens.peek();
    return first.type == TokenType.reservedKeyword &&
        first.value.toLowerCase() == 'while';
  },
  parse: (parser, tokens) {
    tokens.consume(); // consume 'while'
    try {
      final condition = parser.createExpressionParser(tokens).parseExpression();

      final doToken = tokens.peek();
      if (doToken.value.toLowerCase() != 'do') {
        parser.errors.add(
          ParseError(
            'Expected `do` after while condition',
            parser.currentBlock.startLocation,
          ),
        );
      } else {
        tokens.consume();
      }

      parser.advanceBlock();
      final body = parser.parseUntil({'endwhile'});

      final endwhileBlock = parser.peekBlockTokens();
      if (endwhileBlock != null &&
          endwhileBlock.peek().value.toLowerCase() == 'endwhile') {
        parser.advanceBlock();
      }

      return WhileNode(condition, body);
    } catch (_) {
      tokens.consumeRemaining();
      rethrow;
    }
  },
);
