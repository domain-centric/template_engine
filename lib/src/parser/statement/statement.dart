import 'package:template_engine/template_engine.dart';

final standardStatements = <StatementDefinition>[
  commentStatement,
  assignStatement,
  ifStatement,
  forStatement,
  forEachStatement,
  whileStatement,
];

class StatementDefinition {
  /// [reservedKeywords] are used to check if identifiers (e.g. variables,
  /// function names, constants, etc) are not using reserved keywords
  /// All statement related keywords should be added here
  /// (e.g. if, else, endif, for, next, while etc)
  final Set<String> reservedKeywords;
  final bool Function(CodeTokenStream tokens) matches;
  final AstNode Function(TemplateParserDelegate parser, CodeTokenStream tokens)
  parse;
  final DefinitionDocumentation documentation;

  const StatementDefinition({
    required this.reservedKeywords,
    required this.matches,
    required this.parse,
    required this.documentation,
  });
}

String aggregatedCodeBlockDocumentation(Grammar grammar, int titleLevel) => [
  'Templates that are processed by $templateEngineHyperLink '
      'are made out of different blocks:',
  '* Text blocks: static template text that is not a code block',
  '* Code blocks:',
  '  * statement blocks: perform an action',
  '  * expression blocks: produce a value',
  '',
  'A code block:',
  '* Starts with some bracket and/or character combination, e.g.: {{',
  '* Followed by statement or expression syntax',
  '* Ends with some closing bracket and/or character combination, e.g.: }}',
  markdownTitle(titleLevel + 1, 'Code block delimiters'),
  'By default the $templateEngineHyperLink code blocks start with {{ and end with }} ',
  'brackets, just like the popular template engines ',
  '[Mustache](https://mustache.github.io/) and ',
  '[Handlebars](https://handlebarsjs.com).',
  '',
  'You can also define alternative code block delimiters in '
      'the $templateEngineHyperLink ',
  'constructor grammar parameter. See Grammar.codeBlockDelimiter',
  '',
  'It is recommended to use a start and end combination that is not used ',
  'elsewhere in your templates, e.g.: Do not use < > as code block start and end ',
  'if your template contains HTML or XML',

  markdownTitle(titleLevel, 'Statements'),
  'A statement is a code block '
      '(or a combination of code blocks with text blocks between them) '
      'that performs an action. ',
  'Examples are: ',
  '* if statements',
  '* for statements',
  '* variable assignments',
  '* etc... ',
  ...grammar.statements.map(
    (statementDefinition) => statementDefinition.documentation
        .createMarkdownDocumentation(grammar, titleLevel + 1),
  ),
  '',
  markdownTitle(titleLevel + 1, 'Custom statements'),
  'The $templateEngineHyperLink comes with its own statements ',
  '(see next paragraphs). ',
  'Statements are pluggable, which means that you can ',
  'remove/change or add your own statement syntax. ',
  'See ${customStatementExample.toMarkdownLink()}',
  '',
  markdownTitle(titleLevel, 'Expressions'),
  'An expression is a piece of code that produces a value. ',
  'Examples are: ',
  '* variables',
  '* constants',
  '* operators',
  '* function calls',
  '* method calls',
  '* or a combination of all of the above',
  '* etc... ',
  '',
  'Expressions can be used:',
  '* inside statements (e.g. the condition of an if statement or '
      'the value of an assignment statement)',
  '* as an expression code block, e.g. '
      '${grammar.codeBlockDelimiter.start} sin(pi) ${grammar.codeBlockDelimiter.end}',
  '',
  'You can define your own expression grammar or '
      'modify or add tot the standard $templateEngineHyperLink grammar.',
  '* ${customDataTypeExample.toMarkdownLink()}',
  '* ${customConstantExample.toMarkdownLink()}',
  '* ${customOperatorExample.toMarkdownLink()}',
  '* ${customFunctionExample.toMarkdownLink()}',
  '* ${customMethodExample.toMarkdownLink()}',
  '',
].join('\n');

final customStatementExample = TestFileExample.fromProjectFilePath(
  'test/src/parser/statement/custom_statement_test.dart',
);
