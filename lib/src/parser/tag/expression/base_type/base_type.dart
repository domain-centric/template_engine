import 'package:collection/collection.dart';
import 'package:petitparser/petitparser.dart';
import 'package:template_engine/src/parser/override_message_parser.dart';
import 'package:template_engine/template_engine.dart';

abstract class BaseType<T extends Object> {
  String get name;
  List<String> get examples;
  Parser<Value<T>> createParser();
}

class DefaultBaseTypes extends DelegatingList<BaseType> {
  DefaultBaseTypes()
      : super([
          QuotesString(),
          Number(),
          Boolean(),
        ]);
}

List<Parser<Expression>> baseTypeParsers(List<BaseType> baseTypes) =>
    baseTypes.map((baseType) => baseType.createParser()).toList();

class Boolean extends BaseType<bool> {
  @override
  String get name => 'Boolean';

  @override
  List<String> get examples =>
      ['true', 'TRUE', 'TRue', 'false', 'FALSE', 'FAlse'];

  @override
  Parser<Value<bool>> createParser() =>
      (stringIgnoreCase('true') | stringIgnoreCase('false'))
          .flatten('boolean expected')
          .trim()
          .map((value) => Value<bool>(value.toLowerCase() == 'true'));
}

class Number extends BaseType<num> {
  @override
  String get name => 'Number';

  @override
  List<String> get examples => ["42", "-123", "3.141", "1.2e5", "3.4e-1"];

  @override
  Parser<Value<num>> createParser() => (digit().plus() &
          (char('.') & digit().plus()).optional() &
          (pattern('eE') & pattern('+-').optional() & digit().plus())
              .optional())
      .flatten('number expected')
      .trim()
      .map((value) => Value<num>(num.parse(value)));
}

class QuotesString extends BaseType<String> {
  @override
  String get name => 'String';

  @override
  List<String> get examples =>
      ["'Hello'", '"world"', "'Hel'+'lo '&\"world\" & \".\""];

  @override
  Parser<Value<String>> createParser() => OverrideMessageParser(
      ((char("'") & any().starLazy(char("'")).flatten() & char("'")) |
              (char('"') & any().starLazy(char('"')).flatten() & char('"')))
          .trim()
          .map((values) => Value<String>(values[1])),
      'quoted string expected');
}
