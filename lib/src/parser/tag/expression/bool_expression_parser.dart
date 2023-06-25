import 'package:petitparser/petitparser.dart';
import 'package:template_engine/template_engine.dart';

Parser<bool> boolParser() => (whitespace().star() &
        (stringIgnoreCase('true') | stringIgnoreCase('false'))
            .flatten('boolean expected'))
    .map((values) => values[1].toLowerCase() == 'true');

/// Parses [bool] values such as:
/// * true, false
/// * True, False
/// * TRUE, FALSE
/// * TRue, FALse
/// You can use operators such as"
/// * !
/// * $
/// * |
/// * ()
Parser<Expression<bool>> boolExpressionParser() {
  final builder = ExpressionBuilder<Expression<bool>>();
  builder.primitive(boolParser().map((boolValue) => Value<bool>(boolValue)));
  // ..primitive((letter() & word().star())
  //     .flatten('variable expected')
  //     .trim()
  //     .map((name) => Variable2<String>(name)));

  // builder.group()
  //   ..wrapper(
  //       seq2(
  //         word().plusString('function expected').trim(),
  //         char('(').trim(),
  //       ),
  //       char(')').trim(),
  //       (left, value, right) =>
  //           TagFunction2<String>(left.first, value, functions[left.first]!))
  //   ..wrapper(
  //       char('(').trim(), char(')').trim(), (left, value, right) => value);
  builder.group()

    /// modulo
    ..left(char('^').trim(),
        (a, op, b) => BinaryOperator<bool>('^', a, b, (x, y) => x ^ y))

    /// and
    ..left(char('&').trim(),
        (a, op, b) => BinaryOperator<bool>('&', a, b, (x, y) => x & y))

    /// or
    ..left(char('|').trim(),
        (a, op, b) => BinaryOperator<bool>('|', a, b, (x, y) => x | y));
  return builder.build();
}

// final functions = {
//   'length': (String text) => text.length,
// };
