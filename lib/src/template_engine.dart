import 'package:petitparser/petitparser.dart';
import 'package:template_engine/template_engine.dart';

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

  final List<BaseType> baseTypes;
  final List<Constant> constants;
  final List<TagFunction> functions;
  final List<OperatorGroup> operatorGroups;

  TemplateEngine({
    List<BaseType>? baseTypes,
    List<Constant>? constants,
    List<OperatorGroup>? operatorGroups,
    List<TagFunction>? functions,
    List<Tag>? tags,
    this.tagStart = '{{',
    this.tagEnd = '}}',
  })  : baseTypes = baseTypes ?? DefaultBaseTypes(),
        constants = constants ?? DefaultConstants(),
        functions = functions ?? DefaultFunctions(),
        operatorGroups = operatorGroups ?? DefaultOperators(),
        tags = tags ?? DefaultTags() {
    validateNamesAreUnique();
  }

  /// Parse the [Template] text into a
  /// [parser tree](https://en.wikipedia.org/wiki/Parse_tree).
  /// See [Renderer]
  ParseResult parse(Template template) {
    var context = ParserContext(
      template: template,
      engine: this,
    );
    var parser = templateParser(context);
    var result = parser.parse(template.text);

    if (result.isFailure) {
      context.errors.add(Error.fromFailure(
        stage: ErrorStage.parse,
        failure: result as Failure,
        template: template,
      ));
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
