import 'package:petitparser/petitparser.dart';
import 'package:template_engine/template_engine.dart';

class ExpressionTag extends Tag {
  ExpressionTag()
      : super(name: 'ExpressionTag', description: [
          'Evaluates an expression that can a contain:',
          '* Base Types (e.g. boolean, number or String)',
          '* Constants (e.g. pi)',
          '* Variables (e.g. person.name )',
          '* Operators (e.g. + - * /)',
          '* Functions (e.g. cos(7) )',
          '* or any combination of the above'
        ]);

  @override
  List<String> examples(TemplateEngine engine) => [
        'The cos of 2 pi = ${engine.tagStart} cos(2 * pi) ${engine.tagEnd}.',
        'The volume of a sphere = '
            '${engine.tagStart} (3/4) * pi * (radius ^ 3) ${engine.tagEnd}.'
      ];

  @override
  Parser<Object> createTagParser(ParserContext context) =>
      (string(context.engine.tagStart) &
              (whitespace().star()) &
              expressionParser(context) &
              (whitespace().star()) &
              string(context.engine.tagEnd))
          .valueContextMap((values, parsePosition) => values[2]);
}
