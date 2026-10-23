import 'package:template_engine/template_engine.dart';

/// Defines the contract used by delegate parsers to interact with the
/// surrounding template parsing process.
///
/// A [TemplateParserDelegate] provides controlled access to the parser's
/// state and utilities while parsing a template. It acts as a bridge between
/// low-level statement parsing logic and the higher-level template parser.
///
/// Implementations (such as [TemplateParser]) are responsible for:
/// - Managing the current position in the template.
/// - Providing access to parsing context such as errors and expression grammar.
/// - Coordinating traversal between [TemplateBlock]s.
/// - Delegating expression parsing when needed.
///
/// Delegate parsers (e.g. [StatementDefinition.parse]) use this interface to:
/// - Inspect upcoming [TemplateBlock]s.
/// - Advance through the template.
/// - Parse nested structures (e.g. `if`, `else`, `endif`).
/// - Report errors in a consistent way.
///
/// ### Lifecycle
/// A typical interaction looks like:
/// 1. A statement parser receives this delegate.
/// 2. It consumes tokens from the current [TemplateBlock].
/// 3. It may call [advanceBlock] to move forward.
/// 4. It may call [parseUntil] to recursively parse nested content.
/// 5. It creates AST nodes based on the parsed structure.
///
/// ### TemplateBlock-based parsing
/// Templates are split into [TemplateBlock]s (text vs code).
/// This delegate provides access to the *current* and *next*
/// block via token streams:
/// - [peekBlockTokens] allows lookahead without advancing.
/// - [advanceBlock] moves to the next block.
///
/// ### Expression parsing
/// For parsing expressions inside statements, implementations should use
/// [createExpressionParser], which ensures consistent configuration and
/// error tracking.
///
/// ### Error handling
/// All parsing errors should be reported through [errors], allowing the
/// parser to collect and return them as part of the final result.
///
/// Implementers must ensure that all returned data (tokens, locations,
/// parsers) remain consistent with the current parsing position.
abstract class TemplateParserDelegate {
  /// The configuration used for parsing
  Grammar get grammar;

  /// The list of accumulated parsing errors.
  ///
  /// Statement parsers should add errors here instead of throwing, so parsing
  /// can continue and report multiple issues at once.
  List<ParseError> get errors;

  TemplateBlock get currentBlock;

  /// Returns a [CodeTokenStream] for the current block without advancing.
  ///
  /// Returns `null` if there are no more blocks.
  ///
  /// This is typically used for lookahead (e.g. detecting `else` or `endif`).
  CodeTokenStream? peekBlockTokens();

  /// Advances the parser to the next block.
  ///
  /// After calling this, [peekBlockTokens] and [currentBlockLocation]
  /// will refer to the next block.
  void advanceBlock();

  /// Creates an [ExpressionParser] for the given [tokenStream].
  ///
  /// This should be used instead of constructing an [ExpressionParser]
  /// directly, so the correct grammar, location, and error list are applied.
  ExpressionParser createExpressionParser(CodeTokenStream tokenStream);

  /// Parses template nodes until one of the given [terminators] is encountered.
  ///
  /// Terminators are matched against the first token of a code block,
  /// typically using a lowercase string comparison (e.g. `'else'`, `'endif'`).
  ///
  /// The terminator itself is *not consumed*; it remains as the current
  /// block after this method returns.
  ///
  /// This method is primarily used for parsing nested block structures like:
  /// - `if` / `else` / `endif`
  /// - loops or other control flow constructs
  ///
  /// If the end of the template is reached before encountering a terminator,
  /// an error should be reported via [errors].
  List<AstNode> parseUntil(Set<String> terminators);
}

/// Default implementation of a template parser that transforms raw template
/// text into an abstract syntax tree (AST).
///
/// [TemplateParser] is responsible for:
/// - Tokenizing the input template into text and code blocks.
/// - Iterating through these blocks in order.
/// - Delegating parsing of code blocks to registered [StatementDefinition]s.
/// - Falling back to expression parsing when no statement matches.
/// - Building a [TemplateDocument] containing the resulting AST nodes.
/// - Collecting and reporting parsing errors.
///
/// ### Parsing model
/// The parser operates in a **block-based** manner:
/// - Plain text blocks are converted directly into [TextNode]s.
/// - Code blocks (delimited by the configured delimiters) are tokenized
///   into [CodeTokenStream]s and parsed.
///
/// For each code block:
/// 1. It attempts to match a [StatementDefinition] from the configuration.
/// 2. If a match is found, the statement’s `parse` callback is invoked.
/// 3. Otherwise, the block is treated as an expression.
/// 4. If parsing fails, an [ErrorNode] is emitted and an error recorded.
///
/// ### Statement integration
/// Statements are pluggable via [Grammar.statements].
/// This allows the parser to be extended with new language constructs without
/// modifying the parser itself.
///
/// Complex statements (such as `if` / `else` / `endif`) can recursively invoke
/// parsing through the [TemplateParserDelegate] interface implemented by this class.
///
/// ### Error handling
/// Parsing is designed to be resilient:
/// - Errors are collected in a list rather than thrown immediately.
/// - The parser continues processing after encountering errors where possible.
/// - The final result ([ParseResult]) contains both the parsed document
///   and all accumulated errors.
///
/// ### Output
/// Calling [parse] produces a [ParseResult], which includes:
/// - A [TemplateDocument] containing the full AST.
/// - An immutable list of [ParseError]s encountered during parsing.
///
/// ### Usage
/// Typically, a [TemplateParser] is created with a configuration and template text,
/// then executed once:
///
/// ```dart
/// final parser = TemplateParser(grammar, templateText);
/// final result = parser.parse();
/// ```
///
/// The resulting document can then be evaluated or rendered by the template engine.
class TemplateParser implements TemplateParserDelegate {
  @override
  final Grammar grammar;
  final Template source;
  final String text;
  final List<TemplateBlock> _blocks;
  final List<ParseError> _errors = [];

  // Internal index tracking the current block being parsed.
  int _index = 0;
  bool _recoverAfterUnexpectedEndDelimiter = false;

  TemplateParser({
    required this.grammar,
    required this.source,
    required this.text,
  }) : _blocks = _tokenize(text, grammar.codeBlockDelimiter);

  ParseResult parse() {
    final nodes = _parseUntil(const {});
    _reportUnconsumedBlocks();
    final document = TemplateDocument(template: source, nodes: nodes);
    return ParseResult(document: document, errors: List.unmodifiable(_errors));
  }

  List<AstNode> _parseUntil(Set<String> terminators) {
    final nodes = <AstNode>[];
    final startLocation = _currentLocation;

    while (_index < _blocks.length) {
      final block = _blocks[_index];
      if (block.isCode) {
        final tokenStream = _createTokenStream(block);
        if (_isTerminator(tokenStream, terminators)) {
          return nodes;
        }
        nodes.addAll(_parseCodeBlock(block, tokenStream));
      } else {
        nodes.addAll(_parseTextBlock(block));
        continue;
      }
    }
    _reportMissingTerminator(terminators, startLocation);
    return nodes;
  }

  TemplateLocation get _currentLocation => _index < _blocks.length
      ? _blocks[_index].startLocation
      : const TemplateLocation(1, 1);

  List<AstNode> _parseTextBlock(TemplateBlock block) {
    final nodes = <AstNode>[];
    final delimiter = grammar.codeBlockDelimiter.end;
    var offset = 0;
    var delimiterOffset = block.blockText.indexOf(delimiter);
    while (delimiterOffset >= 0) {
      if (delimiterOffset > offset) {
        nodes.add(TextNode(block.blockText.substring(offset, delimiterOffset)));
      }
      _errors.add(
        ParseError(
          'Unexpected code block end delimiter '
          '`${grammar.codeBlockDelimiter.end}` without preceding '
          'start delimiter `${grammar.codeBlockDelimiter.start}`',
          block.location(offset: delimiterOffset),
        ),
      );
      nodes.add(ErrorNode(delimiter, renderOriginalCode: true));
      offset = delimiterOffset + delimiter.length;
      delimiterOffset = block.blockText.indexOf(delimiter, offset);
    }
    if (offset < block.blockText.length) {
      nodes.add(TextNode(block.blockText.substring(offset)));
    }
    _recoverAfterUnexpectedEndDelimiter = nodes.any(
      (node) => node is ErrorNode,
    );
    _index++;
    return nodes;
  }

  CodeTokenStream _createTokenStream(TemplateBlock block) {
    return CodeTokenStream(grammar, block.blockText, block.startLocation);
  }

  bool _isTerminator(CodeTokenStream tokenStream, Set<String> terminators) {
    final firstToken = tokenStream.peek();
    return terminators.contains(firstToken.value.toLowerCase());
  }

  List<AstNode> _parseCodeBlock(
    TemplateBlock block,
    CodeTokenStream tokenStream,
  ) {
    if (block.hasMissingEndDelimiter) {
      _errors.add(
        ParseError(
          'Unexpected code block start delimiter '
          '`${grammar.codeBlockDelimiter.start}` without succeeding end '
          'delimiter `${grammar.codeBlockDelimiter.end}`',
          block.startLocation,
        ),
      );
      _index++;
      final nodes = <AstNode>[
        ErrorNode(grammar.codeBlockDelimiter.start, renderOriginalCode: true),
      ];
      if (_recoverAfterUnexpectedEndDelimiter && block.blockText.isNotEmpty) {
        nodes.add(
          TextNode(
            block.blockText.substring(grammar.codeBlockDelimiter.start.length),
            renderText: false,
          ),
        );
      }
      _recoverAfterUnexpectedEndDelimiter = false;
      return nodes;
    }

    _recoverAfterUnexpectedEndDelimiter = false;
    final statementDefinition = grammar.findStatementDefinition(tokenStream);
    if (statementDefinition == null) {
      return [_parseExpressionBlockWithErrors(tokenStream, block)];
    }

    return [_parseStatementBlock(statementDefinition, tokenStream, block)];
  }

  AstNode _parseExpressionBlockWithErrors(
    CodeTokenStream tokenStream,
    TemplateBlock block,
  ) {
    try {
      final node = _parseExpressionBlock(tokenStream, block);
      _index++;
      return node;
    } catch (error) {
      _addBlockError('expression', error, block);
      _index++;
      return ErrorNode(block.blockText);
    }
  }

  AstNode _parseStatementBlock(
    StatementDefinition statementDefinition,
    CodeTokenStream tokenStream,
    TemplateBlock block,
  ) {
    final originalIndex = _index;
    try {
      return statementDefinition.parse(this, tokenStream);
    } catch (error) {
      _addBlockError('statement', error, block);
      return ErrorNode(block.blockText);
    } finally {
      if (_index == originalIndex) {
        _index++;
      }
    }
  }

  void _addBlockError(String blockType, Object error, TemplateBlock block) {
    if (error is ParseError) {
      _errors.add(
        ParseError(
          'Unable to parse $blockType block: ${error.message}',
          error.location,
        ),
      );
      return;
    }

    _errors.add(
      ParseError(
        'Unable to parse $blockType block: $error',
        block.startLocation,
      ),
    );
  }

  void _reportMissingTerminator(
    Set<String> terminators,
    TemplateLocation startLocation,
  ) {
    if (terminators.isEmpty) {
      return;
    }

    final expected = terminators
        .map((terminator) => '`$terminator`')
        .join(' or ');
    _errors.add(
      ParseError('Expected $expected before end of template', startLocation),
    );
  }

  void _reportUnconsumedBlocks() {
    if (_index >= _blocks.length) {
      return;
    }

    final block = _blocks[_index];
    final message = block.isCode
        ? 'Parser did not consume entire template: invalid statement or expression'
        : 'Parser did not consume entire template';
    _errors.add(ParseError(message, block.endLocation));
  }

  /// Parses a code block as an expression and returns
  /// an [ExpressionBlockNode] or throws a [ParseError] if parsing fails.
  AstNode _parseExpressionBlock(
    CodeTokenStream tokenStream,
    TemplateBlock block,
  ) {
    try {
      var expressionParserErrors = <ParseError>[];
      final parser = ExpressionParser(
        grammar,
        tokenStream,
        expressionParserErrors,
      );
      final expression = parser.parseExpression();
      if (!tokenStream.isAtEnd && expressionParserErrors.isEmpty) {
        var token = tokenStream.peek();
        errors.add(ParseError('Unexpected `${token.value}`', token.location));
      }
      _errors.addAll(expressionParserErrors);
      return ExpressionBlockNode(expression);
    } catch (e) {
      if (e is ParseError) {
        rethrow;
      } else {
        throw ParseError('Expression parse error: $e', block.startLocation);
      }
    }
  }

  @override
  List<ParseError> get errors => _errors;

  @override
  CodeTokenStream? peekBlockTokens() {
    if (_index < _blocks.length) {
      final block = _blocks[_index];
      return CodeTokenStream(grammar, block.blockText, block.startLocation);
    }
    return null;
  }

  @override
  void advanceBlock() {
    _index++;
  }

  @override
  ExpressionParser createExpressionParser(CodeTokenStream tokenStream) {
    return ExpressionParser(grammar, tokenStream, errors);
  }

  @override
  List<AstNode> parseUntil(Set<String> terminators) {
    return _parseUntil(terminators);
  }

  static List<TemplateBlock> _tokenize(
    String text,
    CodeBlockDelimiter codeBlockDelimiter,
  ) {
    final blocks = <TemplateBlock>[];
    var cursor = 0;
    while (cursor < text.length) {
      final offsetCodeBlockStartDelimiter = text.indexOf(
        codeBlockDelimiter.start,
        cursor,
      );
      if (offsetCodeBlockStartDelimiter < 0) {
        blocks.add(
          // remaining text block until end of the template text
          TemplateBlock(
            templateText: text,
            isCode: false,
            startOffset: cursor,
            endOffset: text.length,
          ),
        );
        break;
      }
      if (offsetCodeBlockStartDelimiter > cursor) {
        blocks.add(
          // text block up to next code block
          TemplateBlock(
            templateText: text,
            isCode: false,
            startOffset: cursor,
            endOffset: offsetCodeBlockStartDelimiter,
          ),
        );
      }
      final codeStart =
          offsetCodeBlockStartDelimiter + codeBlockDelimiter.start.length;
      final end = text.indexOf(codeBlockDelimiter.end, codeStart);
      if (end < 0) {
        blocks.add(
          // remaining code block after the start delimiter
          // until end of the template text (end delimiter is missing)
          TemplateBlock(
            templateText: text,
            isCode: true,
            startOffset: offsetCodeBlockStartDelimiter,
            endOffset: text.length,
            hasMissingEndDelimiter: true,
          ),
        );
        break;
      }
      // code block between delimiters
      blocks.add(
        TemplateBlock(
          templateText: text,
          isCode: true,
          startOffset: codeStart,
          endOffset: end,
        ),
      );
      cursor = end + codeBlockDelimiter.end.length;
    }
    return blocks;
  }

  @override
  TemplateBlock get currentBlock => _blocks[_index];
}
