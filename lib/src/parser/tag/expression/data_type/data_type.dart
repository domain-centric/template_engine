import 'package:collection/collection.dart';
import 'package:petitparser/petitparser.dart';
import 'package:template_engine/src/parser/override_message_parser.dart';
import 'package:template_engine/template_engine.dart';

/// A [data type](https://en.wikipedia.org/wiki/Data_type) defines what the
/// possible values an expression, such as a variable, operator
/// or a function call, might take.
///
/// The [TemplateEngine] supports several default [DataType]s.
///
/// You can adopt or add your custom [DataType]s by manipulating the
/// [TemplateEngine.dataTypes] field.
///
/// Examples
/// * [Default Data Types]
/// * [Custom Data Type]
abstract class DataType<T extends Object> implements DocumentationFactory {
  String get name;
  String get description;
  List<String> get examples;
  Parser<Value<T>> createParser();

  @override
  List<String> createMarkdownDocumentation(
      RenderContext renderContext, int titleLevel) {
    var writer = HtmlTableWriter();
    writer.addHeaderRow([name], [2]);
    writer.addRow(['description:', description]);
    writer.addRow(['examples:', examples.join('<br>\n')]);
    return writer.toHtmlLines();
  }
}

class DefaultDataTypes extends DelegatingList<DataType> {
  DefaultDataTypes()
      : super([
          QuotesString(),
          Number(),
          Boolean(),
        ]);
}

List<Parser<Expression>> dataTypeParsers(List<DataType> dataTypes) =>
    dataTypes.map((dataType) => dataType.createParser()).toList();

class Boolean extends DataType<bool> {
  @override
  String get name => 'Boolean';

  @override
  String get description =>
      'a form of data with only two possible values :"true" and "false"';

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

class Number extends DataType<num> {
  @override
  String get name => 'Number';

  @override
  String get description => 'a form of data to express the size of something.';

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

class QuotesString extends DataType<String> {
  @override
  String get name => 'String';

  @override
  String get description =>
      'a form of data containing a sequence of characters';
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
