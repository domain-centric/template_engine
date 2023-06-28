import 'package:petitparser/petitparser.dart';
import 'package:template_engine/template_engine.dart';

/// Parses [bool] values such as:
/// * true, false
/// * True, False
/// * TRUE, FALSE
/// * TRue, FALse
/// You can use operators such as"
/// * ! : not e.g.: !false => true
/// * & : and e.g.: true & true => true
/// * | : or e.g.: false | true => true
/// * ^ : xor e.g.: false | true => true
/// * () : parentheses e.g.: true & (false | true) => true
Parser<Expression<bool>> boolExpressionParser() {
  final builder = ExpressionBuilder<Expression<bool>>();
  builder.primitive(boolParser().map((boolValue) => Value<bool>(boolValue)));
  // ..primitive((letter() & word().star())
  //     .flatten('variable expected')
  //     .trim()
  //     .map((name) => Variable2<String>(name)));

  builder
      .group()
      //   ..wrapper(
      //       seq2(
      //         word().plusString('function expected').trim(),
      //         char('(').trim(),
      //       ),
      //       char(')').trim(),
      //       (left, value, right) =>
      //           TagFunction2<String>(left.first, value, functions[left.first]!))

      /// parentheses
      .wrapper(
          char('(').trim(), char(')').trim(), (left, value, right) => value);

  builder
      .group()

      /// not
      .prefix(
          char('!').trim(), (op, a) => UnaryOperator<bool>('!', a, (x) => !x));

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
