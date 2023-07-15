import 'package:petitparser/petitparser.dart';
import 'package:template_engine/template_engine.dart';

Parser<Expression> expressionParser(ParserContext context,
    {bool verboseErrors = false}) {
  SettableParser loopback = undefined();

  final builder = ExpressionBuilder<Expression>();
  builder.primitive(
    ChoiceParser([
      ...baseTypeParsers(context.engine.baseTypes),
      functionsParser(
          context: context,
          loopbackParser: loopback,
          verboseErrors: verboseErrors),
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
