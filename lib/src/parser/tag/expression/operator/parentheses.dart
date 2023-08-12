import 'package:petitparser/petitparser.dart';
import 'package:template_engine/template_engine.dart';

class Parentheses extends OperatorGroup {
  Parentheses() : super('Parentheses', [ParenthesesOperator()]);
}

class ParenthesesOperator extends Operator {
  static final codeExample = ProjectFilePath(
      '/test/src/parser/tag/expression/operator/parentheses_test.dart');

  @override
  addParser(Template template, ExpressionGroup2<Expression<Object>> group) {
    group.wrapper(
        char('(').trim(), char(')').trim(), (left, value, right) => value);
  }

  @override
  List<String> createMarkdownDocumentation(
      RenderContext renderContext, int titleLevel) {
    var writer = HtmlTableWriter();
    writer.addHeaderRow(['operator: ( ... )'], [2]);
    writer.addRow([
      'description:',
      'Groups expressions together so that the are calculated first'
    ]);
    writer.addRow(['expression example:', '{{(2+1)*3}} should render: 9']);
    writer.addRow(['code example:', codeExample.githubMarkdownLink]);
    return writer.toHtmlLines();
  }

  @override
  List<String> createMarkdownExamples(
          RenderContext renderContext, int titleLevel) =>
      ['* ${codeExample.githubMarkdownLink}'];

  @override
  String toString() => 'ParenthesesOperator{}';
}
