import 'package:petitparser/petitparser.dart';
import 'package:template_engine/src/parser/override_message_parser.dart';
import 'package:template_engine/template_engine.dart';

Parser<bool> boolParser() =>
    (stringIgnoreCase('true') | stringIgnoreCase('false'))
        .flatten('boolean expected')
        .trim()
        .map((value) => value.toLowerCase() == 'true');

Parser<num> numberParser() => (digit().plus() &
        (char('.') & digit().plus()).optional() &
        (pattern('eE') & pattern('+-').optional() & digit().plus()).optional())
    .flatten('number expected')
    .trim()
    .map((value) => num.parse(value));

Parser<String> quotedStringParser() => OverrideMessageParser(
    ((char("'") & any().starLazy(char("'")).flatten() & char("'")) |
            (char('"') & any().starLazy(char('"')).flatten() & char('"')))
        .trim()
        .map((values) => values[1]),
    'quoted string expected');

Parser<Expression> expressionParser(ParserContext context) {
  var tag =
      context.tags.firstWhere((tag) => tag is ExpressionTag) as ExpressionTag;
  final builder = ExpressionBuilder<Expression>();
  builder.primitive(
    ChoiceParser([
      quotedStringParser().map((string) => Value<String>(string)),
      numberParser().map((number) => Value<num>(number)),
      boolParser().map((boolean) => Value<bool>(boolean)),
      functionsParser(context, tag.functions),
      constantParser(tag.constants),
      variableParser(),
    ], failureJoiner: selectFarthestJoined),
  );

  var group = builder.group();

  ParenthesesOperator().addParser(group);
  group = builder.group();
  PositiveOperator().addParser(group);
  NegativeOperator().addParser(group);
  NotOperator().addParser(group);
  group = builder.group();
  CaretOperator().addParser(group);
  group = builder.group();
  MultiplyOperator().addParser(group);
  DivideOperator().addParser(group);
  ModuloOperator().addParser(group);
  AndOperator().addParser(group);
  group = builder.group();
  AddOperator().addParser(group);
  SubtractOperator().addParser(group);
  OrOperator().addParser(group);
  return builder.build();
}
