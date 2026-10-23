import 'package:template_engine/template_engine.dart';

final assignStatement = StatementDefinition(
  documentation: DefinitionDocumentation(
    title: 'Variable assignment statement',
    description: 'Assign a value to a variable.',
    syntax: SyntaxDocumentation(
      codeBlockFunction: (delimiter) =>
          '${delimiter.start} variableName = expression ${delimiter.end}',
      explanationFunction: (delimiter) =>
          'variableName is the name of the variable '
          'to assign to (must be a valid identifier)\n'
          '= is the assignment operator\n'
          'expression is any valid expression (see expression grammar) '
          'and any supported data type\n',
    ),
    examples: [
      ExpressionBlockExample(
        (delimiter) => '${delimiter.start} name = "World" ${delimiter.end}',
        explanation: 'Assign the string "World" to the variable `name`.',
        shouldRender: '',
      ),
      TestFileExample.fromProjectFilePath(
        'test/src/parser/statement/assignment_statement_test.dart',
      ),
    ],
  ),
  reservedKeywords: {},
  matches: (tokens) {
    // check if tokens matches <identifier> = <expression>
    var identifier = tokens.peek(offset: 0);
    var equals = tokens.peek(offset: 1);
    var afterEquals = tokens.peek(offset: 2);
    return identifier.type == .identifier &&
        equals.value == '=' &&
        afterEquals.value != '='; // prevent consuming == operator
  },
  parse: (parser, tokens) {
    final variable = tokens.consume().value;
    tokens.consume(); // '='
    try {
      final expression = ExpressionParser(
        parser.grammar,
        tokens,
        parser.errors,
      ).parseExpression();
      return AssignmentNode(variable, expression);
    } catch (_) {
      tokens.consumeRemaining();
      rethrow;
    }
  },
);
