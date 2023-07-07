import 'package:petitparser/petitparser.dart';
import 'package:template_engine/template_engine.dart';

class ExpressionTag extends Tag {
  final List<Constant> constants;
  final List<TagFunction> functions;

  ExpressionTag({
    List<Constant>? constants,
    List<TagFunction>? functions,
  })  : constants = constants ?? DefaultConstants(),
        functions = functions ?? DefaultFunctions(),
        super(
          name: 'ExpressionTag',
          description: 'Evaluates an expression that can contain values '
              '(bool, num, string), operators, functions, constants '
              'and variables',
        );

  @override
  Parser<Object> createTagParser(ParserContext context) =>
      (string(context.tagStart) &
              expressionParser(context) &
              string(context.tagEnd))
          .map2((values, parsePosition) => values[1]);
}
