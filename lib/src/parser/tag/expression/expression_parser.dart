import 'package:petitparser/petitparser.dart';
import 'package:template_engine/template_engine.dart';

Parser<Expression> expressionParser() {
  final builder = ExpressionBuilder<Expression>();
  builder
    ..primitive(boolExpressionParser())
    ..primitive(numExpressionParser())
    ..primitive(stringExpressionParser());
  return builder.build();
}
