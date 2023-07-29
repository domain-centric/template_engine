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
/// ## Custom DataTypes
/// You can adopt existing DataTypes or add your own custom DataTypes by
/// manipulating the TemplateEngine.dataTypes field.
/// See [Example](https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/data_type/custom_test.dart).

abstract class DataType<T extends Object>
    implements DocumentationFactory, ExampleFactory {
  String get name;
  String get description;
  String get syntaxDescription;
  List<ProjectFilePath> get examples;
  Parser<Value<T>> createParser();

  @override
  List<String> createMarkdownDocumentation(
      RenderContext renderContext, int titleLevel) {
    var writer = HtmlTableWriter();
    writer.addHeaderRow([name], [2]);
    writer.addRow(['description:', description]);
    writer.addRow(['syntax:', syntaxDescription]);

    if (examples.isNotEmpty) {
      writer.addRow([
        examples.length == 1 ? 'example:' : 'examples:',
        examples.map((example) => example.githubMarkdownLink).join('<br>\n')
      ]);
    }
    return writer.toHtmlLines();
  }

  @override
  List<String> createMarkdownExamples(
          RenderContext renderContext, int titleLevel) =>
      examples.map((e) => '* ${e.githubMarkdownLink}').toList();
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
      'A form of data with only two possible values: true or false';

  @override
  String get syntaxDescription =>
      'A boolean is declared with the word true or false. '
      'The letters are case insensitive.';

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
  String get description => 'A form of data to express the size of something.';

  @override
  String get syntaxDescription => 'A number is declared with:<br>'
      '* optional: positive (+) or negative (-) prefix. nno prefix =positive (e.g. -12)<br>'
      '* one or more digits (e.g. 12)<br>'
      '* optional fragments (e.g. 0.12)<br>'
      '* optional: scientific notation: the letter E is used to mean'
      '"10 to the power of." (e.g. 1.314E+1 means 1.314 * 10^1'
      'which is 13.14).<br>';

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
      'A form of data containing a sequence of characters';

  @override
  String get syntaxDescription =>
      'A string is declared with a chain of characters, surrounded by '
      'two single (\') or double (") quotes to indicate the '
      'start and end of a string. In example: \'Hello\' or "Hello"';

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
