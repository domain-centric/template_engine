import 'package:collection/collection.dart';
import 'package:petitparser/petitparser.dart';
import 'package:template_engine/src/parser/error.dart';
import 'package:template_engine/src/parser/map2_parser_extension.dart';
import 'package:template_engine/src/parser/parser.dart';
import 'package:template_engine/src/parser/tag/tag.dart';

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
  final List<Attribute> attributeDefinitions;

  TagFunction({
    required super.name,
    required super.description,
    this.attributeDefinitions = const [],
  });

  @override
  Parser<T> createTagParser(ParserContext context) =>
      _createParserWithoutMapping(context, failsOnAttributeError: true)
          .map2((values, parsePosition) {
        return createParserResult(
            TemplateSource(
              template: context.template,
              parserPosition: parsePosition,
            ),
            values[3]);
      });

  Parser<List<dynamic>> _createParserWithoutMapping(ParserContext context,
      {required bool failsOnAttributeError}) {
    return (string(context.tagStart) &
        optionalWhiteSpace() &
        stringIgnoreCase(name) &
        AttributesParser(
          parserContext: context,
          attributes: attributeDefinitions,
          failsOnError: failsOnAttributeError,
        ) &
        optionalWhiteSpace() &
        string(context.tagEnd));
  }

  /// creates a parser that returns success when a [TagFunction] is found but the attributes contains an error.
  /// It will return a map with attribute errors
  Parser<Map<String, Object>>
      createTagFunctionParserThatReturnsMapWithAttributeErrors(
              ParserContext context) =>
          _createParserWithoutMapping(context, failsOnAttributeError: false)
              .map((values) {
            return values[3];
          });

  T createParserResult(TemplateSource source, Map<String, Object> attributes);
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
class Attribute<T> {
  /// The name of the [Attribute]:
  /// * may not be empty
  /// * is case un-sensitive
  /// * may contain letters and numbers: 'title'
  final String name;

  /// optional=true: the attribute is mandatory
  /// optional=false: the attribute may be omitted
  final bool optional;

  /// The [Attribute] will get the [defaultValue] when the [Attribute]
  /// is [optional] and the [defaultValue] is not null
  final T? defaultValue;

  Type get valueType => T;

  Attribute({
    required this.name,
    this.optional = false,
    this.defaultValue,
  }) {
    AttributeName.validate(name);
  }
}

/// The [VariableName]:
/// * must start with a letter, optionally followed by letters and or digits.
/// * is case unsensitive .
///
/// E.g.: myValue1
class AttributeName {
  static final parser = (letter().plus() & digit().star()).plus().flatten();

  static validate(String name) {
    var result = parser.end().parse(name);
    if (result.isFailure) {
      throw AttributeException(
          'Attribute name: "$name" is invalid: ${result.message} at position: ${result.position}');
    }
  }
}

/// See [attributeValueParser] for the [AttributeValue] types that are supported
abstract class AttributeValue {
  // for documentation only;
}

class AttributeException implements Exception {
  final String message;

  AttributeException(this.message);
}

class AttributeExceptions implements Exception {
  final List<String> messages;

  AttributeExceptions(this.messages);
}

/// The following [AttributeValue] types are supported:
/// * [number]
/// * [boolean]
/// * [quotedString]
Parser<Object> attributeValueParser() =>
    ChoiceParser([number(), boolean(), quotedString()]);

/// Creates parsers for each attribute name = value
/// Then validates the result and converts attributes to a name-value [Map]
class AttributesParser extends Parser<Map<String, Object>> {
  final List<AttributeNameAndValueParser> nameAndValueParsers;
  final List<Attribute> attributes;
  final ParserContext parserContext;
  final bool failsOnError;

  AttributesParser(
      {required this.parserContext,
      required this.attributes,
      required this.failsOnError})
      : nameAndValueParsers = attributes
            .map((attribute) => AttributeNameAndValueParser(attribute))
            .toList();

  @override
  Result<Map<String, Object>> parseOn(Context context) {
    List<Error> errors = [];
    Map<String, Object> namesAndValues = {};
    List<AttributeNameAndValueParser> parsers = [...nameAndValueParsers];
    var current = context;

    AttributeNameAndValueParser? parserWithSuccess;
    do {
      parserWithSuccess = null;
      for (var parser in parsers) {
        if (parserWithSuccess == null) {
          var result = parser.parseOn(current);
          if (result.isSuccess) {
            parserWithSuccess = parser;
            namesAndValues[parser.attribute.name] = result.value;
            current = result;
          }
        }
      }
      if (parserWithSuccess != null) {
        // remove parser for efficiency
        parsers.remove(parserWithSuccess);
      }
    } while (parserWithSuccess != null);

    var remainingParser = (whitespace().plus().flatten()) &
        untilEndOfTagParser(parserContext.tagStart, parserContext.tagEnd);
    var result = remainingParser.parseOn(current);
    if (result.isSuccess) {
      var remainingText = result.value[1].trim();
      if (remainingText.isNotEmpty) {
        errors.add(Error(
            source: _createTemplateSource(current),
            message: 'Invalid attribute defintion: $remainingText',
            stage: ErrorStage.parse));
      }
      current = result;
    }

    errors.addAll(_validateIfMandatoryAttributesWhereFound(parsers, current));

    namesAndValues.addAll(_missingDefaultValues(namesAndValues));

    if (failsOnError) {
      if (errors.isEmpty) {
        return current.success(namesAndValues);
      } else {
        return current.failure(errors.join('\n'));
      }
    } else {
      var errorMap = {
        for (int i = 0; i < errors.length; i++) i.toString(): errors[i]
      };
      return current.success(errorMap);
    }
  }

  @override
  AttributesParser copy() => AttributesParser(
        parserContext: parserContext,
        attributes: attributes,
        failsOnError: failsOnError,
      );

  List<Error> _validateIfMandatoryAttributesWhereFound(
      List<AttributeNameAndValueParser> parsers, Context context) {
    var missingMandatoryAttributes = parsers
        .whereNot((parser) => parser.attribute.optional)
        .map((parser) => parser.attribute)
        .toList();
    if (missingMandatoryAttributes.isNotEmpty) {
      if (missingMandatoryAttributes.length == 1) {
        return [
          Error(
            stage: ErrorStage.parse,
            source: _createTemplateSource(context),
            message:
                'Mandatory attribute: ${missingMandatoryAttributes.first.name} is missing',
          )
        ];
      } else {
        return [
          Error(
            stage: ErrorStage.parse,
            source: _createTemplateSource(context),
            message:
                'Mandatory attributes: ${missingMandatoryAttributes.map((e) => e.name).join(', ')} are missing',
          )
        ];
      }
    }
    return [];
  }

  Map<String, Object> _missingDefaultValues(
      Map<String, Object> namesAndValues) {
    Map<String, Object> missingDefaultValues = {};

    var optionalAttributesWithDefaultValue = attributes.where(
        (attribute) => attribute.optional && attribute.defaultValue != null);
    for (var optionalAttribute in optionalAttributesWithDefaultValue) {
      if (!namesAndValues.containsKey(optionalAttribute.name)) {
        missingDefaultValues[optionalAttribute.name] =
            optionalAttribute.defaultValue;
      }
    }
    return missingDefaultValues;
  }

  TemplateSource _createTemplateSource(Context context) => TemplateSource(
      template: parserContext.template,
      parserPosition: context.toPositionString());
}

class AttributeNameAndValueParser extends Parser<Object> {
  final Attribute attribute;
  final Parser<Object> internalParser;
  AttributeNameAndValueParser(this.attribute)
      : internalParser = _createInternalParser(attribute);

  @override
  Parser<Object> copy() => AttributeNameAndValueParser(attribute);

  @override
  Result<Object> parseOn(Context context) => internalParser.parseOn(context);

  /// Returns a parser that returns the value of an attribute
  /// Note that it must start with a whitespace for separation!
  static Parser<Object> _createInternalParser(Attribute attribute) =>
      (whitespace().plus() &
              stringIgnoreCase(attribute.name) &
              optionalWhiteSpace() &
              char('=') &
              optionalWhiteSpace() &
              attributeValueParser())
          .map((values) => values[5] as Object);
}
