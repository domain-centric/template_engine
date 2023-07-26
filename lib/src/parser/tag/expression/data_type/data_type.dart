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
/// * [Default Data Types](https://github.com/domain-centric/template_engine/blob/main/example/expression_data_type_default.dart)
/// * [Custom Data Type](https://github.com/domain-centric/template_engine/blob/main/example/expression_data_type_custom.dart)

abstract class DataType<T extends Object> implements DocumentationFactory {
  String get name;
  String get description;
  List<ProjectFilePath> get examples;
  Parser<Value<T>> createParser();

  @override
  List<String> createMarkdownDocumentation(
      RenderContext renderContext, int titleLevel) {
    var writer = HtmlTableWriter();
    writer.addHeaderRow([name], [2]);
    writer.addRow(['description:', description]);
    if (examples.isNotEmpty) {
      writer.addRow([
        examples.length == 1 ? 'example:' : 'examples:',
        examples.map((example) => example.githubMarkdownLink).join('<br>\n')
      ]);
    }
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
  List<ProjectFilePath> get examples => [
        ProjectFilePath(
            '/test/src/parser/tag/expression/data_type/bool_test.dart')
      ];

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
  List<ProjectFilePath> get examples => [
        ProjectFilePath(
            '/test/src/parser/tag/expression/data_type/num_test.dart')
      ];

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
  List<ProjectFilePath> get examples => [
        ProjectFilePath(
            '/test/src/parser/tag/expression/data_type/string_test.dart')
      ];

  @override
  Parser<Value<String>> createParser() => OverrideMessageParser(
      ((char("'") & any().starLazy(char("'")).flatten() & char("'")) |
              (char('"') & any().starLazy(char('"')).flatten() & char('"')))
          .trim()
          .map((values) => Value<String>(values[1])),
      'quoted string expected');
}
