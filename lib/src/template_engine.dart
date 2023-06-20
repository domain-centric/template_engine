import 'package:template_engine/src/parser/error.dart';
import 'package:template_engine/src/parser/parser.dart';
import 'package:template_engine/src/render.dart';
import 'package:template_engine/src/parser/tag/group.dart';
import 'package:template_engine/src/parser/tag/tag.dart';
import 'package:template_engine/src/template.dart';

/// The [TemplateEngine] does the following:
/// * Parse the [Template] text into a
///   [parser tree](https://en.wikipedia.org/wiki/Parse_tree), see [Renderer]
/// * Render the [parser tree](https://en.wikipedia.org/wiki/Parse_tree)
///   to a output such as:
///   * [Html](https://en.wikipedia.org/wiki/HTML)
///   * [Programming code](https://en.wikipedia.org/wiki/Programming_language)
///   * [Markdown](https://en.wikipedia.org/wiki/Markdown)
///   * [Xml](https://en.wikipedia.org/wiki/XML),
///     [Json](https://en.wikipedia.org/wiki/JSON),
///     [Yaml](https://en.wikipedia.org/wiki/YAML)
///   * Etc...
///
/// See the [examples](https://pub.dev/packages/template_engine/example)

class TemplateEngine {
  /// If null it will use [StandardTagParsers]
  final List<Tag> tags;

  /// The tag starts with given prefix.
  /// Use a prefix combination that is not used elsewhere in your templates.
  /// e.g.: Do not use < as a prefix if your template contains HTML or XML
  /// By default the prefix is: {{
  /// Examples of other prefixes and suffixes:
  /// * HTML and XML uses < >
  /// * JSON uses { }
  /// * PHP uses <? ?>
  /// * JSP and ASP uses <% %>
  final String tagStart;

  /// The tag ends with given suffix.
  /// Use a suffix combination that is not used elsewhere in your templates.
  /// e.g.: Do not use > as a suffix if your template contains HTML or XML
  /// By default the prefix is: }}
  /// Examples of other prefixes and suffixes:
  /// * HTML and XML uses < >
  /// * JSON uses { }
  /// * PHP uses <? ?>
  /// * JSP and ASP uses <% %>
  String tagEnd = '}}';

  TemplateEngine({
    List<Tag>? tags,
    this.tagStart = '{{',
    this.tagEnd = '}}',
  }) : tags = tags ?? StandardTags() {
    validateNamesAreUnique();
  }

  /// Parse the [Template] text into a
  /// [parser tree](https://en.wikipedia.org/wiki/Parse_tree).
  /// See [Renderer]
  ParseResult parse(Template template) {
    var context = ParserContext(
        tags: tags, tagStart: tagStart, tagEnd: tagEnd, template: template);
    var parser = templateParser(context);
    var result = parser.parse(template.text);

    if (result.isFailure) {
      context.errors.add(Error(
          stage: ErrorStage.parse,
          message: result.message,
          source: TemplateSource(
            template: template,
            parserPosition: result.toPositionString(),
          )));
    }
    return ParseResult(children: result.value, errors: context.errors);
  }

  /// Render the [parser tree](https://en.wikipedia.org/wiki/Parse_tree)
  /// to a string (and write it as files when needed)
  RenderResult render(ParserTree renderResult,
      [Map<String, Object> variables = const {}]) {
    var context = RenderContext(variables);
    var text = renderResult.render(context);
    return RenderResult(
      text: text,
      errors: context.errors,
    );
  }

  void validateNamesAreUnique() {
    Set<String> processedNames = {};
    List<String> allNames = tags.map((tag) => tag.name.toLowerCase()).toList();
    Set<String> doubleNames =
        allNames.where((name) => !processedNames.add(name)).toSet();
    switch (doubleNames.length) {
      case 0:
        break;
      case 1:
        throw TagException('Tag name: ${doubleNames.first} is not unique');
      default:
        throw TagException(
            'Tag names: ${doubleNames.join(', ')} are not unique');
    }
  }
}
