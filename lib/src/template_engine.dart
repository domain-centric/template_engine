import 'dart:async';

import 'package:template_engine/template_engine.dart';

/// The [TemplateEngine] can:
/// * Parse the [Template] text into a
///   [parser tree](https://en.wikipedia.org/wiki/Parse_tree)
/// * Render the [parser tree](https://en.wikipedia.org/wiki/Parse_tree)
///   to an output such as:
///   * [Html](https://en.wikipedia.org/wiki/HTML)
///   * [Programming code](https://en.wikipedia.org/wiki/Programming_language)
///   * [Markdown](https://en.wikipedia.org/wiki/Markdown)
///   * [Xml](https://en.wikipedia.org/wiki/XML),
///   * [Json](https://en.wikipedia.org/wiki/JSON),
///   * [Yaml](https://en.wikipedia.org/wiki/YAML)
///   * Etc...
///
/// # Features
/// Template code blocks support:
/// * Statements, like
///   * comments
///   * variable assignments
///   * if, then, else
///   * loops
///   * etc...
/// * Expressions that can contain (combinations of):
///   * Data types
///   * Constants
///   * Variables
///   * Operators
///   * Methods
///   * Functions
///     e.g. functions to import:
///     * Pure files (to be imported as is)
///     * Template files (to be parsed and rendered)
///     * XML files (to be used as a data source)
///     * JSON files (to be used as a data source)
///     * YAML files (to be used as a data source)
/// * All of the above can be customized by replacing or adding your own grammar.
class TemplateEngine {
  /// The grammar used to parse templates.
  final Grammar grammar;

  /// Creates an engine using [grammar], or [Grammar.standard] by default.
  TemplateEngine([Grammar? grammar]) : grammar = grammar ?? Grammar.standard();

  /// Parses template [text] and returns its syntax tree and parse errors.
  Future<ParseResult> parseText(String text) =>
      parseTemplate(TextTemplate(text));

  /// Loads and parses [template].
  Future<ParseResult> parseTemplate(Template template) async {
    var text = await template.text;
    var parser = TemplateParser(grammar: grammar, source: template, text: text);
    var result = parser.parse();
    return result;
  }

  /// Parses each [templates] entry in order.
  Future<List<ParseResult>> parseTemplates(List<Template> templates) async {
    var results = <ParseResult>[];
    for (var template in templates) {
      var result = await parseTemplate(template);
      results.add(result);
    }
    return results;
  }

  /// Renders [parseResult] with optional variables and imported-template cache.
  Future<RenderResult> render(
    ParseResult parseResult, {
    Set<ParseResult>? parsedImportedTemplates,
    Map<String, dynamic>? variables,
  }) async {
    parsedImportedTemplates ??= {};
    final context = RenderContext(
      grammar: grammar,
      parseResult: parseResult,
      parsedImportedTemplates: parsedImportedTemplates,
      variables: variables,
    );
    return await renderFromContext(context);
  }

  /// Renders each parse result using shared variables and import cache.
  Future<RenderResults> renderAll(
    List<ParseResult> parseResults, {
    Set<ParseResult>? parsedImportedTemplates,
    Map<String, dynamic>? variables,
  }) async {
    var renderResults = <RenderResult>[];
    var clonedVariables = variables ?? {};
    parsedImportedTemplates ??= {};
    for (final parseResult in parseResults) {
      final context = RenderContext(
        grammar: grammar,
        parseResult: parseResult,
        parsedImportedTemplates: parsedImportedTemplates,
        variables: clonedVariables,
      );
      var renderResult = await renderFromContext(context);
      parsedImportedTemplates.addAll(context.parsedImportedTemplates);
      renderResults.add(renderResult);
    }
    return RenderResults(
      renderResults,
      parsedImportedTemplates,
      clonedVariables,
    );
  }
}

/// Renders every node in [context] and returns the collected result.
Future<RenderResult> renderFromContext(RenderContext context) async {
  final buffer = StringBuffer();
  for (final node in context.parseResult.document.nodes) {
    try {
      var outputText = await node.render(context);
      buffer.write(outputText);
    } on RenderError catch (e) {
      context.errors.add(e);
      buffer.write(context.errorPlaceholder);
    }
  }
  return RenderResult(context, buffer.toString());
}
