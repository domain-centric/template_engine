import 'package:collection/collection.dart';
import 'package:petitparser/parser.dart';
import 'package:template_engine/template_engine.dart';

/// [Tag]s are specific texts in [Template]s that are replaced by the
/// [TemplateEngine] with other information.
///
/// [Tag]s:
/// * Are surrounded with symbols like {{  }}
/// * Start with [TagName]
/// * Can be followed by [Attribute]s
abstract class Tag<T extends Object> {
  Tag({
    required this.name,
    required this.description,
  }) {
    TagName.validate(name);
  }

  final String name;
  final String description;

  /// gives an example of the tag, e.g. {{tag}}
  String example(ParserContext context) => [
        context.engine.tagStart,
        name,
        context.engine.tagEnd,
      ].join();

  /// gives documentation of the tag, e.g. {{tag}} e.g.:
  /// an example,
  /// a description
  /// a summary of attributes if any.
  String documentation(ParserContext context) =>
      ['Example: ${example(context)}', description].join('\n');

  Parser<T> createTagParser(ParserContext context);
}

/// A [TagName]:
/// * may not be empty
/// * is case un-sensitive
/// * may contain letters, numbers and dots. e.g.: 'project.path'
/// * must be unique
class TagName {
  static final nameParser = (letter().plus() & digit().star()).plus();
  static final namePathParser = (nameParser & (char('.') & nameParser).star());
  static final namePathParserUntilEnd = namePathParser.end();

  static validate(String namePath) {
    var result = namePathParserUntilEnd.parse(namePath);
    if (result.isFailure) {
      throw TagException('Tag name: "$namePath" is invalid: ${result.message} '
          'at position: ${result.position}');
    }
  }
}

class TagException implements Exception {
  final String message;

  TagException(this.message);
}

class DefaultTags extends DelegatingList<Tag> {
  DefaultTags() : super([ExpressionTag()]);
}
