import 'package:template_engine/template_engine.dart';

final ifStatement = StatementDefinition(
  documentation: DefinitionDocumentation(
    title: 'If statement',
    description:
        'Conditionally render content using `if`, optional `else`, and `endif`.',
    syntax: SyntaxDocumentation(
      codeBlockFunction: (delimiter) =>
          '${delimiter.start} if condition ${delimiter.end}'
          'Text and/or statement blocks that render if condition is true.'
          '${delimiter.start} else ${delimiter.end}'
          'Text and/or statement blocks that render if condition is false.'
          '${delimiter.start} endif ${delimiter.end}',
      explanationFunction: (delimiter) =>
          '${delimiter.start}if ... ${delimiter.end} starts the if statement\n'
          'condition is any boolean expression (see expression grammar)\n'
          '${delimiter.start}else${delimiter.end} is optional (fallback section)\n'
          '${delimiter.start}endif${delimiter.end} closes the if statement\n',
    ),
    examples: [
      ExpressionBlockExample(
        (delimiter) =>
            '${delimiter.start} if user.isActive ${delimiter.end}'
            'Active'
            '${delimiter.start} else ${delimiter.end}'
            'Inactive'
            '${delimiter.start} endif ${delimiter.end}',
        variables: {
          'user': {'isActive': false},
        },
        shouldRender: 'Inactive',
      ),
      TestFileExample.fromProjectFilePath(
        'test/src/parser/statement/if_statement_test.dart',
      ),
    ],
  ),
  reservedKeywords: {'if', 'elseif', 'else', 'endif'},
  matches: (tokens) {
    final first = tokens.peek();
    return first.type == TokenType.reservedKeyword &&
        first.value.toLowerCase() == 'if';
  },
  parse: (parser, tokens) {
    var thrownErrors = <ParseError>[];
    tokens.consume(); // consume 'if'

    Expression? condition;
    try {
      condition = parser.createExpressionParser(tokens).parseExpression();
    } on ParseError catch (e) {
      tokens.consumeRemaining();
      thrownErrors.add(e);
    }
    parser.advanceBlock();

    final thenNodes = parser.parseUntil({'elseif', 'else', 'endif'});

    List<AstNode> elseNodes = [];
    var nextBlockTokens = parser.peekBlockTokens();

    // If there are elseif blocks, collect them then build nested IfNodes
    if (nextBlockTokens != null &&
        nextBlockTokens.peek().value.toLowerCase() == 'elseif') {
      final elseifList = <MapEntry<Expression, List<AstNode>>>[];
      while (nextBlockTokens != null &&
          nextBlockTokens.peek().value.toLowerCase() == 'elseif') {
        nextBlockTokens.consume();
        try {
          final elseifCondition = parser
              .createExpressionParser(nextBlockTokens)
              .parseExpression();
          parser.advanceBlock();
          final elseifNodes = parser.parseUntil({'elseif', 'else', 'endif'});
          elseifList.add(MapEntry(elseifCondition, elseifNodes));
          nextBlockTokens = parser.peekBlockTokens();
        } on ParseError catch (e) {
          nextBlockTokens?.consumeRemaining();
          thrownErrors.add(e);
        }
      }

      // optional else after elseif chain
      if (nextBlockTokens != null &&
          nextBlockTokens.peek().value.toLowerCase() == 'else') {
        parser.advanceBlock();
        elseNodes = parser.parseUntil({'endif'});
        nextBlockTokens = parser.peekBlockTokens();
      }

      // consume endif if present
      if (nextBlockTokens != null &&
          nextBlockTokens.peek().value.toLowerCase() == 'endif') {
        parser.advanceBlock();
      }

      // Build nested IfNode chain from the end
      List<AstNode> tail = elseNodes;
      for (final e in elseifList.reversed) {
        final nestedIf = IfNode(e.key, e.value, tail);
        tail = [nestedIf];
      }
      elseNodes = tail;
    } else {
      // optional else
      if (nextBlockTokens != null &&
          nextBlockTokens.peek().value.toLowerCase() == 'else') {
        parser.advanceBlock();
        elseNodes = parser.parseUntil({'endif'});
      }

      // Attempt to consume 'endif' if present, but do not error if missing
      final endifBlockTokens = parser.peekBlockTokens();
      if (endifBlockTokens != null &&
          endifBlockTokens.peek().value.toLowerCase() == 'endif') {
        parser.advanceBlock();
      }
    }
    if (thrownErrors.isNotEmpty) {
      parser.errors.addAll(thrownErrors);
      return ErrorNode(tokens.consumedText);
    } else {
      return IfNode(condition!, thenNodes, elseNodes);
    }
  },
);
