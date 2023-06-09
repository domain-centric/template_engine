import 'package:petitparser/petitparser.dart';
import 'package:template_engine/src/error.dart';
import 'package:template_engine/src/generic_parser/map2_parser_extension.dart';
import 'package:template_engine/src/generic_parser/parser.dart';
import 'package:template_engine/src/tag/tag.dart';

/// A [TagFunction] is a [Tag] that generates the result using a
/// Dart [Function] that you can write yourself.
/// You can use attributes inside a [TagFunction].
/// These will be passed to the Dart [Function] together with the [ParserContext]
///
/// Example of an [TagFunction]: {{greetings name='world'}}
///
/// Note that attribute values can also be a tag. In the following example the
/// name attributes gets value of variable name.
/// Example : {{greetings name={{name}} }}
abstract class TagFunction<T extends Object> extends Tag {
  /// A [TagFunction] may have 0 or more [Attribute]s
  final List<Attribute> attributes;

  TagFunction({
    required super.name,
    required super.description,
    this.attributes = const [],
  });

  @override
  Parser<T> createTagParser(ParserContext context) =>
      (string(context.tagStart) &
              optionalWhiteSpace() &
              stringIgnoreCase(name) &
              optionalWhiteSpace() &
              rawAttributeParser(context) &
              optionalWhiteSpace() &
              string(context.tagEnd))
          .map2((values, parsePosition) => createParserResult(
              TemplateSource(
                template: context.template,
                parserPosition: parsePosition,
              ),
              values[4]));

  T createParserResult(TemplateSource source,
      String attributes); //TODO change value with attribute value map
}

/// A [Tag] can have 0 or more attributes.
/// An [Attribute]:
/// * Has a name
/// * Has a value of one of the following types:
///   * bool
///   * String
///   * int
///   * double
///   * date
///   * list where the elements are one of the types above
///   * map where the keys are a string and the values are one of the types above
///   * a [Tag] that is converted to a [Renderer]
///  * Can be optional
///  * Can have an default value when the attribute is optional
class Attribute {
  /// The name of the [Attribute]:
  /// * may not be empty
  /// * is case un-sensitive
  /// * may contain letters and numbers: 'title'
  final String name;

  /// A function to validate the value of an [Attribute]
  /// It returns an empty list when ok.
  /// It returns a list or error messages when not ok.
  final List<String> Function(Object value) validateValue;

  /// optional=true: the attribute is mandatory
  /// optional=false: the attribute may be omitted
  final bool optional;

  Attribute({
    required this.name,
    required this.validateValue,
    required this.optional,
  });
}

/// Creates a [Parser] that gets anything until the tag end
/// TODO tagValues may contain tags, we therefor need change the parser
Parser<String> rawAttributeParser(ParserContext context) =>
    (any().starLazy(string(context.tagEnd))).flatten();
