import 'package:petitparser/petitparser.dart';
import 'package:template_engine/template_engine.dart';

Parser<String> qouatedStringParser() =>
    ((char("'") & any().starLazy(char("'")).flatten() & char("'")) |
            (char('"') & any().starLazy(char('"')).flatten() & char('"')))
        .map((values) => values[1]);

/// Parses [String] values such as: "Hello" or 'world'
/// You can contactate strings with the + and & attributes.
/// E.g.:
/// "Hel" + 'l' & "o" results in [String]: Hello
Parser<Expression<String>> stringExpressionParser() {
  final builder = ExpressionBuilder<Expression<String>>();

  builder.primitive(
      (whitespace().star() & qouatedStringParser() & whitespace().star())
          .map((values) => Value<String>(values[1])));
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
    ..left(char('+').trim(),
        (a, op, b) => BinaryOperator<String>('+', a, b, (x, y) => '$x$y'))
    ..left(char('&').trim(),
        (a, op, b) => BinaryOperator<String>('&', a, b, (x, y) => '$x$y'));
  return builder.build();
}

// final functions = {
//   'length': (String text) => text.length,
// };
