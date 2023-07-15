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

Parser<Expression> expressionParser(ParserContext context,
    {bool verboseErrors = false}) {
  SettableParser loopback = undefined();

  final builder = ExpressionBuilder<Expression>();
  builder.primitive(
    ChoiceParser([
      quotedStringParser().map((string) => Value<String>(string)),
      numberParser().map((number) => Value<num>(number)),
      boolParser().map((boolean) => Value<bool>(boolean)),
      functionsParser(
        context: context,
        functions: context.engine.functions,
        loopbackParser: loopback,
        verboseErrors: verboseErrors,
      ),
      constantParser(context.engine.constants),
      variableParser(),
    ], failureJoiner: selectFarthestJoined),
  );

  _addOperators(context.engine.operatorGroups, builder);

  var parser = builder.build();
  loopback.set(parser);
  return parser;
}

void _addOperators(
    List<OperatorGroup> operatorGroups, ExpressionBuilder<Expression> builder) {
  for (var operatorGroup in operatorGroups) {
    var builderGroup = builder.group();
    for (var operator in operatorGroup) {
      operator.addParser(builderGroup);
    }
  }
}
