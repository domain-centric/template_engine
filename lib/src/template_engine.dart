import 'dart:async';

import 'package:template_engine/template_engine.dart';

/// The main entry point for parsing and rendering templates.
class TemplateEngine {
  final Grammar grammar;

  TemplateEngine([Grammar? grammar]) : grammar = grammar ?? Grammar.standard();

  Future<ParseResult> parseText(String text) =>
      parseTemplate(TextTemplate(text));

  Future<ParseResult> parseTemplate(Template template) async {
    var text = await template.text;
    var parser = TemplateParser(grammar: grammar, source: template, text: text);
    var result = parser.parse();
    return result;
  }

  Future<List<ParseResult>> parseTemplates(List<Template> templates) async {
    var results = <ParseResult>[];
    for (var template in templates) {
      var result = await parseTemplate(template);
      results.add(result);
    }
    return results;
  }

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
