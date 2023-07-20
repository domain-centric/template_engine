import 'package:petitparser/petitparser.dart';
import 'package:template_engine/template_engine.dart';

class ExpressionTag extends Tag {
  ExpressionTag()
      : super(
          name: 'ExpressionTag',
          description: 'Evaluates an expression that can contain values '
              '(bool, num, string), operators, functions, constants '
              'and variables.',
        );

  @override
  String example(TemplateEngine engine) =>
      'The cos of 2 pi = ${engine.tagStart}cos(2 * pi)${engine.tagEnd}. '
      'The volume of a sphere = '
      '${engine.tagStart} (3/4) * pi * (radius ^ 3) ${engine.tagEnd}.';

  @override
  Parser<Object> createTagParser(ParserContext context) =>
      (string(context.engine.tagStart) &
              expressionParser(context) &
              string(context.engine.tagEnd))
          .valueContextMap((values, parsePosition) => values[1]);
}
