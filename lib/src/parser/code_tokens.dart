import 'package:collection/collection.dart';
import 'package:template_engine/template_engine.dart';

/// A section of template source text that touches/borders to another
/// without any gap.
///
/// `TemplateParser` splits the original template into blocks that are either:
/// * raw text
/// * or code blocks that are either:
///   * a statement block
///   * an expression block
///
/// Each block carries its original range and a source location
/// so parse errors can be reported against the template.
class TemplateBlock {
  final String templateText;

  /// if this is a code block: between [CodeBlockDelimiter]s in a template text
  final bool isCode;

  /// start of block in [templateText].
  /// If this is a code block than this is after the [CodeBlockDelimiter.start]
  final int startOffset;

  /// end of block text in [templateText]
  /// If this is a code block than this is before the [CodeBlockDelimiter.end]
  final int endOffset;

  final bool hasMissingEndDelimiter;

  TemplateBlock({
    required this.templateText,
    required this.isCode,
    required this.startOffset,
    required this.endOffset,
    this.hasMissingEndDelimiter = false,
  });

  late final String blockText = templateText.substring(startOffset, endOffset);
  late final startLocation = TemplateLocation.fromOffset(
    templateText,
    startOffset,
  );
  TemplateLocation location({int offset = 0}) =>
      TemplateLocation.fromOffset(templateText, startOffset + offset);
  late final endLocation = TemplateLocation.fromOffset(templateText, endOffset);
}

/// A stream abstraction over a list of [CodeToken]s, providing
/// utilities for tokenization, lookahead, and sequential consumption.
///
/// This class is responsible for converting raw source text into a
/// structured sequence of tokens and exposing parsing-friendly APIs
/// such as [peek], [consume], and [lookAhead].
///
/// It filters out whitespace tokens by default and appends an EOF token
/// to simplify parsing logic.
///
/// Commonly used by parsers to iterate through tokens while building
/// an abstract syntax tree (AST).
class CodeTokenStream {
  final List<CodeToken> _tokens;
  int _position = 0;

  CodeTokenStream(
    Grammar grammar,
    String source,
    TemplateLocation startLocation,
  ) : _tokens = _tokenize(
        grammar,
        source,
        startLocation,
      ).where((token) => token.type != TokenType.whitespace).toList();

  CodeTokenStream._(this._tokens, this._position);

  CodeTokenStream clone() =>
      CodeTokenStream._(List.unmodifiable(_tokens), _position);

  static List<CodeToken> _tokenize(
    Grammar grammar,
    String source,
    TemplateLocation startLocation,
  ) {
    final tokens = <CodeToken>[];
    var index = 0;
    var line = startLocation.line;
    var column = startLocation.column;

    while (index < source.length) {
      final char = source[index];
      final tokenLocation = TemplateLocation(line, column);

      if (_isWhitespace(char)) {
        final start = index;
        while (index < source.length && _isWhitespace(source[index])) {
          if (source[index] == '\n') {
            line++;
            column = 1;
          } else {
            column++;
          }
          index++;
        }
        tokens.add(
          CodeToken(
            TokenType.whitespace,
            source.substring(start, index),
            tokenLocation,
          ),
        );
        continue;
      }

      if (_isDigit(char) ||
          (char == '.' &&
              index + 1 < source.length &&
              _isDigit(source[index + 1]))) {
        final start = index;
        if (char == '.') {
          index++;
          column++;
        }
        while (index < source.length && _isDigit(source[index])) {
          index++;
          column++;
        }
        if (index < source.length &&
            source[index] == '.' &&
            index + 1 < source.length &&
            _isDigit(source[index + 1])) {
          index++;
          column++;
          while (index < source.length && _isDigit(source[index])) {
            index++;
            column++;
          }
        }
        tokens.add(
          CodeToken(
            TokenType.number,
            source.substring(start, index),
            tokenLocation,
          ),
        );
        continue;
      }
      if (char == '"' || char == "'") {
        final quote = char;
        final start = index;
        index++;
        column++;
        final buffer = StringBuffer();
        while (index < source.length && source[index] != quote) {
          if (source[index] == '\\' && index + 1 < source.length) {
            index++;
            column++;
            final escape = source[index];
            buffer.write(_unescape(escape));
            index++;
            column++;
          } else {
            if (source[index] == '\n') {
              line++;
              column = 1;
            } else {
              column++;
            }
            buffer.write(source[index]);
            index++;
          }
        }
        if (index < source.length && source[index] == quote) {
          index++;
          column++;
          tokens.add(
            CodeToken(TokenType.string, buffer.toString(), tokenLocation),
          );
        } else {
          tokens.add(
            CodeToken(
              TokenType.unknown,
              source.substring(start),
              tokenLocation,
            ),
          );
        }
        continue;
      }
      if (_isPunctuation(char)) {
        tokens.add(CodeToken(TokenType.punctuation, char, tokenLocation));
        index++;
        column++;
        continue;
      }

      var rest = source.substring(index).toLowerCase();

      var keyword = grammar.reservedKeywords.firstWhereOrNull(
        (keyword) =>
            rest.startsWith(keyword) && _isKeywordBoundary(rest, keyword),
      );
      if (keyword != null) {
        tokens.add(
          CodeToken(TokenType.reservedKeyword, keyword, tokenLocation),
        );
        index += keyword.length;
        column += keyword.length;
        continue;
      }

      var operatorSymbol = grammar.operatorSymbols.firstWhereOrNull(
        (symbol) => rest.startsWith(symbol),
      );
      if (operatorSymbol != null) {
        tokens.add(
          CodeToken(TokenType.operator, operatorSymbol, tokenLocation),
        );
        index += operatorSymbol.length;
        column += operatorSymbol.length;
        continue;
      }

      if (_isIdentifierStart(char)) {
        final start = index;
        index++;
        column++;
        while (index < source.length && _isIdentifierPart(source[index])) {
          index++;
          column++;
        }
        tokens.add(
          CodeToken(
            TokenType.identifier,
            source.substring(start, index),
            tokenLocation,
          ),
        );
        continue;
      }
      tokens.add(CodeToken(TokenType.unknown, char, tokenLocation));
      index++;
      column++;
    }
    tokens.add(
      CodeToken(TokenType.endOfText, '', TemplateLocation(line, column)),
    );
    return tokens;
  }

  CodeToken peek({int offset = 0}) {
    final position = _position + offset;
    return position < _tokens.length ? _tokens[position] : _tokens.last;
  }

  CodeToken consume() {
    if (_position >= _tokens.length) return _tokens.last;
    return _tokens[_position++];
  }

  void consumeRemaining() {
    while (!isAtEnd) {
      consume();
    }
  }

  String get consumedText =>
      _tokens.sublist(0, _position).map((token) => token.value).join();

  CodeToken get previous => _position > 0 && _position - 1 < _tokens.length
      ? _tokens[_position - 1]
      : CodeToken(.beginOfText, '', TemplateLocation(1, 1));

  bool get isAtEnd => peek().type == TokenType.endOfText;

  TemplateLocation get currentLocation => peek().location;

  static bool _isWhitespace(String char) =>
      char == ' ' || char == '\t' || char == '\n' || char == '\r';
  static bool _isIdentifierStart(String char) =>
      RegExp(r'[A-Za-z_]').hasMatch(char);
  static bool _isIdentifierPart(String char) =>
      RegExp(r'[A-Za-z0-9_]').hasMatch(char);
  static bool _isDigit(String char) => RegExp(r'[0-9]').hasMatch(char);
  static bool _isPunctuation(String char) =>
      const {'(', ')', ',', '.', ';'}.contains(char);

  static bool _isKeywordBoundary(String rest, String keyword) {
    final nextIndex = keyword.length;
    if (nextIndex >= rest.length) {
      return true;
    }
    return !_isIdentifierPart(rest[nextIndex]);
  }

  // static bool _isOperatorStart(String char) =>
  //     _operatorChars.contains(char) || _punctuationChars.contains(char);
  static String _unescape(String char) {
    switch (char) {
      case 'n':
        return '\n';
      case 'r':
        return '\r';
      case 't':
        return '\t';
      case '"':
        return '"';
      case "'":
        return "'";
      case r'\\':
        return r'\\';
    }
    return char;
  }

  /// Returns an unmodifiable list until the end
  List<CodeToken> peekRemaining({int offset = 0}) {
    final result = <CodeToken>[];

    var index = _position + offset;

    // Clamp to valid range
    if (index < 0) index = 0;
    if (index >= _tokens.length) {
      return [_tokens.last]; // EOF fallback
    }

    while (index < _tokens.length) {
      final token = _tokens[index];
      result.add(token);

      if (token.type == TokenType.endOfText) {
        break;
      }

      index++;
    }

    return List.unmodifiable(result);
  }

  // static const _punctuationChars = '(),.';
}

enum TokenType {
  beginOfText,
  reservedKeyword,
  identifier,
  number,
  string,
  operator,
  punctuation,
  whitespace,
  endOfText,
  unknown,
}

/// A single lexical token produced during tokenization.
///
/// Each token consists of a [type], the textual [value], and the
/// original [location] in the source string.
///
/// Tokens are the fundamental units consumed by the parser to
/// construct higher-level syntax structures.
class CodeToken {
  final TokenType type;
  final String value;
  final TemplateLocation location;

  CodeToken(this.type, this.value, this.location);

  @override
  String toString() {
    return 'CodeToken{$value}';
  }
}
