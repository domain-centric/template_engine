import 'package:template_engine/template_engine.dart';

class ExpressionParser {
  final Grammar grammar;
  final CodeTokenStream tokens;
  final List<ParseError> errors;

  ExpressionParser(this.grammar, this.tokens, this.errors);

  /// Parses an expression from the token stream
  /// and returns the resulting Expression object.
  ///
  /// Note that not all tokens are consumed,
  /// only those that are part of the expression.
  ///
  /// Throws a ParseException if the expression is invalid.
  Expression parseExpression([int minPrecedence = 0]) {
    var expression = _parsePrefix();
    expression = _parsePostfix(expression);
    return _parseBinaryExpression(expression, minPrecedence);
  }

  Expression _parseBinaryExpression(Expression left, int minPrecedence) {
    while (true) {
      final operatorDefinition = _findBinaryOperatorDefinition();
      final precedence = operatorDefinition?.precedence.level ?? -1;
      if (precedence < minPrecedence) {
        return left;
      }

      var operandLocation = tokens.currentLocation;
      consume(); // operand

      final nextMinPrecedence = _nextMinPrecedence(
        precedence,
        operatorDefinition!,
      );
      var right = parseExpression(nextMinPrecedence);
      left = BinaryOperatorExpression(
        location: operandLocation,
        definition: operatorDefinition,
        left: left,
        right: right,
      );
    }
  }

  Expression _parsePostfix(Expression expression) {
    var result = expression;

    while (_isMethodOrProperty()) {
      result = _isMethod()
          ? _parseMethodCall(result)
          : _parsePropertyAccess(result);
    }
    return result;
  }

  BinaryOperatorDefinition? _findBinaryOperatorDefinition() {
    final symbol = findBinaryOperatorSymbol(tokens).toLowerCase();
    return grammar.findBinaryOperator(symbol);
  }

  int _nextMinPrecedence(int precedence, BinaryOperatorDefinition definition) {
    return precedence + (definition.associativity == .left ? 1 : 0);
  }

  String findBinaryOperatorSymbol(CodeTokenStream tokens) {
    var currentToken = tokens.peek();
    var nextToken = tokens.peek(offset: 1);
    var opSymbol = currentToken.value;
    if ((currentToken.type == TokenType.operator ||
            currentToken.type == TokenType.punctuation) &&
        (nextToken.type == TokenType.operator ||
            nextToken.type == TokenType.punctuation)) {
      final combinedSymbol = '${currentToken.value}${nextToken.value}';
      if (grammar.operatorSymbols.contains(combinedSymbol.toLowerCase())) {
        return combinedSymbol;
      }
    }
    return opSymbol;
  }

  /// Parses the prefix part of an expression or throws an ParseException
  Expression _parsePrefix() {
    final token = tokens.peek();
    if (token.type == .endOfText) {
      throw ParseError('Unexpected end of expression', token.location);
    }

    final dataTypeDef = grammar.findDataTypeDefinition(tokens.peekRemaining());
    if (dataTypeDef != null) {
      return dataTypeDef.parse(tokens);
    }

    if (token.type == TokenType.reservedKeyword) {
      return _parseReservedKeyword(token);
    }

    if (token.type == TokenType.identifier) {
      return _parseIdentifier();
    }
    if (token.value == '(') {
      return _parseParenthesizedExpression();
    }

    var unaryOperatorDefinition = grammar.findUnaryOperator(
      token.value.toLowerCase(),
    );
    if (unaryOperatorDefinition != null) {
      return _parseUnaryExpression(unaryOperatorDefinition);
    }

    return _parseUnexpectedToken(token);
  }

  Expression _parseReservedKeyword(CodeToken token) {
    throw ParseError(
      "Unexpected reserved keyword `${token.value}`",
      token.location,
    );
  }

  Expression _parseIdentifier() {
    var startLocation = tokens.currentLocation;
    var nameToken = consume();
    final normalizedName = nameToken.value.toLowerCase();

    final constant = grammar.findConstant(normalizedName);
    if (constant != null) {
      return LiteralExpression(constant.value);
    }

    if (tokens.peek().value != '(') {
      return VariableExpression(startLocation, nameToken.value);
    }

    final function = grammar.findFunction(normalizedName);
    if (function == null) {
      throw ParseError('Unknown function `${nameToken.value}`', startLocation);
    }

    final arguments = ArgumentExpressionMap(
      parseArguments(),
      function.parameters,
    );
    errors.addAll(arguments.errors);
    return FunctionCallExpression(startLocation, function, arguments);
  }

  Expression _parseParenthesizedExpression() {
    consume();
    final expression = parseExpression();
    if (tokens.peek().value != ')') {
      throw ParseError('Missing closing parenthesis', tokens.currentLocation);
    }
    consume();
    return expression;
  }

  Expression _parseUnaryExpression(UnaryOperatorDefinition definition) {
    var startLocation = tokens.currentLocation;
    consume();
    return UnaryOperatorExpression(
      location: startLocation,
      definition: definition,
      operand: parseExpression(infinitePrecedence),
    );
  }

  Expression _parseUnexpectedToken(CodeToken token) {
    if (token.type == TokenType.operator ||
        token.type == TokenType.punctuation) {
      consume();
      throw ParseError(
        'Unexpected `${token.value}` in expression',
        tokens.currentLocation,
      );
    }
    consume();
    throw ParseError(
      'Unsupported `${token.value}` in expression',
      tokens.currentLocation,
    );
  }

  static const namedParametersFromNowOn = -1;

  static const int infinitePrecedence = 1000000;

  Expression _parseMethodCall(Expression owner) {
    consume(); // .

    final nameToken = tokens.consume();
    // assuming the method name is an identifier (see _isMethodOrProperty())
    // so no further error checking is needed here
    final normalizedMethodName = nameToken.value.toLowerCase();
    final methodDefinitions = grammar.findMethod(normalizedMethodName);
    if (methodDefinitions == null) {
      throw ParseError(
        'Unknown method `${nameToken.value}`',
        nameToken.location,
      );
    }

    var argumentList = ArgumentExpressionList(tokens.currentLocation, []);
    if (tokens.peek().value == '(') {
      argumentList = parseArguments();
      var hasMatch = methodDefinitions
          .map((m) => m.parameters)
          .any(
            (parameters) =>
                ArgumentExpressionMap(argumentList, parameters).errors.isEmpty,
          );
      if (!hasMatch) {
        errors.add(
          ParseError(
            'Arguments do not match any parameter definitions '
            'for method `$normalizedMethodName`',
            argumentList.endOfArguments,
          ),
        );
      }
    } else {
      errors.add(
        ParseError(
          'Method call `${nameToken.value}` must include parentheses',
          nameToken.location,
        ),
      );
    }

    return MethodCallExpression(
      owner,
      nameToken.location,
      methodDefinitions,
      argumentList,
    );
  }

  // parses the function or method arguments: anything between parentheses ()
  ArgumentExpressionList parseArguments() {
    consume();
    final args = _parseArgumentItems();
    final endOfArguments = tokens.currentLocation;
    final arguments = ArgumentExpressionList(endOfArguments, args);
    if (tokens.peek().value == ')') {
      consume();
    } else {
      _reportInvalidArguments(endOfArguments);
    }

    return arguments;
  }

  List<ArgumentExpression> _parseArgumentItems() {
    final arguments = <ArgumentExpression>[];
    while (!_isEndOfArguments) {
      arguments.add(
        _isNamedArgument() ? _parseNamedArgument() : _parsePositionalArgument(),
      );
      if (tokens.peek().value != ',') {
        break;
      }
      consume();
    }
    return arguments;
  }

  bool get _isEndOfArguments => tokens.peek().value == ')' || tokens.isAtEnd;

  void _reportInvalidArguments(TemplateLocation location) {
    final tokensUntilClosingParenthesis =
        _consumeTokensUntilClosingParenthesis();
    final message = tokensUntilClosingParenthesis.isEmpty
        ? 'Missing closing parenthesis'
        : 'Invalid argument syntax';
    errors.add(ParseError(message, location));
  }

  PositionalArgumentExpression _parsePositionalArgument() {
    var location = tokens.currentLocation;
    var value = parseExpression();
    return PositionalArgumentExpression(location, value);
  }

  /// parses and consumes a named argument
  /// puts it into the argument map
  /// returns if a named argument was found
  NamedArgumentExpression _parseNamedArgument() {
    var location = tokens.currentLocation;
    var name = consume().value;
    consume(); //=
    var value = parseExpression();
    return NamedArgumentExpression(location, name, value);
  }

  CodeToken consume() {
    return tokens.consume();
  }

  bool _isNamedArgument() {
    var argumentName = tokens.peek(offset: 0);
    var equals = tokens.peek(offset: 1);
    var afterEquals = tokens.peek(offset: 2);
    return (argumentName.type == .identifier &&
        equals.value == '=' &&
        afterEquals.type != .endOfText);
  }

  List<CodeToken> _consumeTokensUntilClosingParenthesis() {
    var foundTokens = <CodeToken>[];
    var offset = 0;
    var deep = 1;
    while (tokens.peek(offset: offset).type != .endOfText) {
      var token = tokens.peek(offset: offset);
      foundTokens.add(token);
      offset++;
      if (token.value == '(') {
        deep++;
      }
      if (token.value == ')') {
        deep--;
        //found closing parenthesis?
        if (deep == 0) {
          // consume found tokens
          for (int i = 0; i < foundTokens.length; i++) {
            tokens.consume();
          }
          return foundTokens;
        }
      }
    }
    // closing parenthesis was not found return without tokens and without consuming
    return [];
  }

  // we assume that _isMethodOrProperty() has already been checked before calling this method
  // so we only have to check for open parenthesis
  bool _isMethod() => tokens.peek(offset: 2).value == '(';

  bool _isMethodOrProperty() {
    if (tokens.peek().value != '.') {
      return false;
    }
    final nameToken = tokens.peek(offset: 1);
    return nameToken.type == TokenType.identifier;
  }

  Expression _parsePropertyAccess(Expression left) {
    consume(); // .

    final propertyNameToken = tokens.consume();
    // assuming the property name is an identifier (see _isPropertyAccess())
    // so no further error checking is needed here

    return MapPropertyExpression(
      location: tokens.currentLocation,
      owner: left,
      propertyName: propertyNameToken.value,
    );
  }
}
