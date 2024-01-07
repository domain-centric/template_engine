import 'package:petitparser/parser.dart';
import 'package:template_engine/template_engine.dart';

class Assignments extends OperatorGroup {
  Assignments() : super('Assignment', [AssignmentOperator()]);
}

class AssignmentOperator extends Operator {
  static const String operator = '=';
  static final codeExample = ProjectFilePath(
      'test/src/parser/tag/expression/operator/assignment/assignment_test.dart');

  AssignmentOperator();

  @override
  List<String> createMarkdownDocumentation(
      RenderContext renderContext, int titleLevel) {
    var writer = HtmlTableWriter();
    writer.addHeaderRow(['operator: ='], [2]);
    writer.addRow([
      'description:',
      'Assigns a value to a variable. '
          'A new variable will be created when it did not exist before, '
          'otherwise it will be overridden with a new value.'
    ]);
    writer.addRow(
        ['expression example:', '{{x=2}}{{x=x+3}}{{x}} should render: 5']);
    writer.addRow(['code example:', codeExample.githubMarkdownLink]);
    return writer.toHtmlLines();
  }

  @override
  List<String> createMarkdownExamples(
          RenderContext renderContext, int titleLevel) =>
      ['* ${codeExample.githubMarkdownLink}'];

  @override
  String toString() => 'Operator{$operator}';

  @override
  addParser(Template template, ExpressionGroup2<Expression<Object>> group) {
    group.right(
        char(operator).trim(),
        (context, left, op, right) => AssignVariableExpression(
              position: context.toPositionString(),
              left: left,
              right: right,
            ));
  }
}

class AssignVariableExpression extends ExpressionWithSourcePosition<String> {
  final Expression<Object> left;
  final Expression<Object> right;

  AssignVariableExpression(
      {required super.position, required this.left, required this.right});

  @override
  Future<String> render(RenderContext context) async {
    var variableExpression = left;
    if (variableExpression is! VariableExpression) {
      throw RenderException(
          message:
              'The left side of the = operation must be a valid variable name',
          position: super.position);
    }
    if (variableExpression.namePath.contains('.')) {
      throw RenderException(
          message: 'The left side of the = operation '
              'must be a name of a root variable '
              '(not contain dots)',
          position: super.position);
    }

    var value = await right.render(context);
    context.variables[variableExpression.namePath] = value;
    return ''; // variable assignment returns an empty string.
  }

  @override
  String toString() => 'AssignVariableExpression{}';
}
