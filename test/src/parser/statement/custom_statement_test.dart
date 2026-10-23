import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  group('Custom log statement', () {
    test('parses and renders log statement correctly', () async {
      Grammar grammar = Grammar.standard();
      grammar = grammar.withAdditionalStatements([LogStatement.definition()]);

      var templateEngine = TemplateEngine(grammar);
      var parseResult = await templateEngine.parseText(
        '{{ log "Hello, World!" }}',
      );
      var renderResult = await templateEngine.render(parseResult);

      renderResult.text.should.be('');
      renderResult.errors.should.beEmpty();
      renderResult.variables.should.not.beEmpty();
      var variables = renderResult.variables;
      variables.should.containKey('log');
      var log = variables['log'] as List<dynamic>;
      log.should.haveCount(1);
      var firstLog = log.first as String;
      firstLog.should.be('Hello, World!');
    });
  });
}

class LogStatement {
  static StatementDefinition definition() {
    return StatementDefinition(
      documentation: DefinitionDocumentation(
        title: 'Log statement',
        description:
            'Evaluates an expression and appends the result to the "log" variable of the render context.',
        syntax: SyntaxDocumentation(
          codeBlockFunction: (delimiter) =>
              '${delimiter.start} log expression ${delimiter.end}',
          explanationFunction: (delimiter) =>
              'log is the keyword for this statement\n'
              'expression is any valid expression\n'
              'the evaluated result is stored in the render context under a log collection\n',
        ),
        examples: [
          ExpressionBlockExample(
            (delimiter) =>
                '${delimiter.start} log "Hello world" ${delimiter.end}',
            explanation:
                'Stores the string "Hello world" in the "log" variable of the render context.',
            shouldRender: '',
          ),
        ],
      ),
      reservedKeywords: {'log'},
      matches: (tokens) {
        final next = tokens.peek();
        return next.type == TokenType.reservedKeyword && next.value == 'log';
      },
      parse: (parser, tokens) {
        try {
          tokens.consume(); // consume 'log'

          final expression = ExpressionParser(
            parser.grammar,
            tokens,
            parser.errors,
          ).parseExpression();

          return LogNode(expression);
        } catch (_) {
          tokens.consumeRemaining();
          rethrow;
        }
      },
    );
  }
}

class LogNode extends AstNode {
  final Expression expression;
  static const logVariableName = 'log';
  LogNode(this.expression);

  @override
  Future<String> render(RenderContext context) async {
    var value = await expression.evaluate(context);
    if (context.variables[logVariableName] == null) {
      context.variables[logVariableName] = [];
    }
    context.variables[logVariableName].add(value);
    return Future.value('');
  }
}
