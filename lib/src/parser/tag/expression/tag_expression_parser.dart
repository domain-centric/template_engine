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
  Parser<Object> createTagParser(ParserContext context) =>
      (string(context.engine.tagStart) &
              expressionParser(context) &
              string(context.engine.tagEnd))
          .map2((values, parsePosition) => values[1]);
}
