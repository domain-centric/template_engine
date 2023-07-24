import 'package:collection/collection.dart';
import 'package:petitparser/parser.dart';
import 'package:template_engine/template_engine.dart';

/// [Tag]s are specific texts in [Template]s that are replaced by the
/// [TemplateEngine] with other information.
///
/// A [Tag]:
/// * Starts with some bracket and/or character combination, e.g.: {{
/// * Followed by some contents
/// * Ends with some closing bracket and/or character combination, e.g.: }}
///
/// A tag example: {{customer.name}}
///
/// By default the TemplateEngine [Tag]s start with {{ and end with }} brackets,
/// just like the popular template engines
/// [Mustache](http://mustache.github.io/) and
/// [Handlebars](https://handlebarsjs.com).
///
/// You can also define alternative [Tag] brackets in the [TemplateEngine]
/// constructor parameters. See [TemplateEngine.tagStart] and
/// [TemplateEngine.tagEnd].
///
/// It is recommended to use a start and end combination that is not used
/// elsewhere in your templates, e.g.: Do not use < > as [Tag] start and end
/// if your template contains HTML or XML
///
/// The [TemplateEngine] comes with [DefaultTags]. You can replace or add your
/// own [Tag]s by manipulating the the [TemplateEngine.tags] field.

abstract class Tag<T extends Object> implements DocumentationFactory {
  Tag({
    required this.name,
    required this.description,
  }) {
    TagName.validate(name);
  }

  final String name;
  final String description;

  /// gives an example of the tag, e.g. {{tag}}
  String example(TemplateEngine engine) => [
        engine.tagStart,
        name,
        engine.tagEnd,
      ].join();

  @override
  List<String> createMarkdownDocumentation(
          RenderContext renderContext, int titleLevel) =>
      [
        '${"#" * titleLevel} $name',
        description,
        'Example: ${example(renderContext.engine)}',
      ];

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
