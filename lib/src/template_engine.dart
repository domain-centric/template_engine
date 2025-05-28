import 'package:petitparser/petitparser.dart';
import 'package:template_engine/template_engine.dart';

/// The [TemplateEngine] can:
/// * Parse the [Template] text into a
///   [parser tree](https://en.wikipedia.org/wiki/Parse_tree)
/// * Render the [parser tree](https://en.wikipedia.org/wiki/Parse_tree)
///   to a output such as:
///   * [Html](https://en.wikipedia.org/wiki/HTML)
///   * [Programming code](https://en.wikipedia.org/wiki/Programming_language)
///   * [Markdown](https://en.wikipedia.org/wiki/Markdown)
///   * [Xml](https://en.wikipedia.org/wiki/XML),
///   * [Json](https://en.wikipedia.org/wiki/JSON),
///   * [Yaml](https://en.wikipedia.org/wiki/YAML)
///   * Etc...
///
/// # Features
/// * Template expressions that can contain (combinations of):
///   * Data types
///   * Constants
///   * Variables
///   * Operators
///   * Functions
///     e.g. functions to import:
///     * Pure files (to be imported as is)
///     * Template files (to be parsed and rendered)
///     * XML files (to be used as a data source)
///     * JSON files (to be used as a data source)
///     * YAML files (to be used as a data source)
/// * All of the above can be customized or you could add your own.
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

  final List<DataType> dataTypes;
  final List<Constant> constants;
  final List<FunctionGroup> functionGroups;
  final List<OperatorGroup> operatorGroups;

  TemplateEngine({
    List<DataType>? dataTypes,
    List<Constant>? constants,
    List<OperatorGroup>? operatorGroups,
    List<FunctionGroup>? functionGroups,
    List<Tag>? tags,
    this.tagStart = '{{',
    this.tagEnd = '}}',
  })  : dataTypes = dataTypes ?? DefaultDataTypes(),
        constants = constants ?? DefaultConstants(),
        functionGroups = functionGroups ?? DefaultFunctionGroups(),
        operatorGroups = operatorGroups ?? StandardOperators(),
        tags = tags ?? DefaultTags() {
    validateNamesAreUnique();
  }

  Future<ParseResult> parseText(String text) =>
      parseTemplate(TextTemplate(text));

  /// Parse the [Template] text into a
  /// [parser tree](https://en.wikipedia.org/wiki/Parse_tree).
  /// See [Renderer]
  Future<ParseResult> parseTemplate(Template template) async {
    var context = ParserContext(
      this,
      template,
    );
    var parser = templateParser(context);
    var text = await template.text;
    var result = parser.parse(text);

    if (result is Failure) {
      context.errors.add(ParseError.fromFailure(result));
    }
    var templateParseResult = TemplateParseResult(
        template: template, children: result.value, errors: context.errors);
    return ParseResult([templateParseResult]);
  }

  /// Parse text from [Template]s into a
  /// [parser tree](https://en.wikipedia.org/wiki/Parse_tree).
  /// See [Renderer]
  Future<ParseResult> parseTemplates(List<Template> templates) async {
    var parseResults = <TemplateParseResult>[];
    for (var template in templates) {
      var context = ParserContext(
        this,
        template,
      );
      var parser = templateParser(context);
      var text = await template.text;
      var result = parser.parse(text);

      if (result is Failure) {
        context.errors.add(ParseError.fromFailure(result));
      }
      var parseResult = TemplateParseResult(
          template: template, children: result.value, errors: context.errors);
      parseResults.add(parseResult);
    }
    return ParseResult(parseResults);
  }

  /// Render the [parser tree](https://en.wikipedia.org/wiki/Parse_tree)
  /// to a string (and write it as files when needed)
  Future<RenderResult> render(ParseResult parseResults,
      [VariableMap? variables]) async {
    var results = TemplatesRenderResult([]);
    for (var parseResult in [...parseResults.children]) {
      var template = parseResult.template;
      var renderContext = RenderContext(
          engine: this,
          templateBeingRendered: template,
          variables: variables,
          parsedTemplates: parseResults.children);
      var renderResult = await parseResult.render(renderContext);
      var result = TemplateRenderResult(
        template: template,
        text: renderResult.text,
        errors: [...parseResult.errors, ...renderResult.errors],
      );
      results = results.add(result);
      for (var parseResult in renderContext.parsedTemplates
          .where((parseResult) => parseResult.template is ImportedTemplate)) {
        var result = ImportedTemplateParseErrors(
            parseResult.template, parseResult.errorMessage);
        results = results.add(result);
      }
    }

    return results;
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

class ImportedTemplateParseErrors implements TemplateRenderResult {
  @override
  final Template template;

  @override
  final String errorMessage;

  ImportedTemplateParseErrors(this.template, this.errorMessage);

  @override
  List<TemplateError> get errors => throw UnimplementedError();

  @override
  String get text => '';
}
