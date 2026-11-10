import 'package:collection/collection.dart';
import 'package:template_engine/template_engine.dart';

/// The rendered text and errors shared by single- and multi-template results.
class TemplateRenderResult {
  /// The template that was rendered.
  final Template template;

  /// The rendered text of the template.
  final String text;

  /// All parse and render errors associated with the result.
  final List<TemplateEngineException> errors;

  /// Errors that occurred during parsing.
  final List<ParseError> parserErrors;

  /// Errors that occurred during rendering.
  final List<RenderError> renderErrors;

  /// Creates a result from [context] and rendered [text].
  TemplateRenderResult(RenderContext context, this.text)
    : template = context.parseResult.document.template,
      errors = context.errors,
      parserErrors = context.errors.whereType<ParseError>().toList(),
      renderErrors = context.errors.whereType<RenderError>().toList();
}

/// The result of rendering one template.
class RenderResult extends TemplateRenderResult {
  /// Variables remaining after rendering.
  final Map<String, dynamic> variables;

  /// Parsed templates loaded while rendering imports.
  final Set<ParseResult> parsedImportedTemplates;

  /// A combined summary of parse and render errors.
  final String aggregatedErrorMessage;

  /// Creates a result from the rendering context and output text.
  RenderResult(super.context, super.text)
    : parsedImportedTemplates = context.parsedImportedTemplates,
      variables = context.variables,
      aggregatedErrorMessage = [
        createAggregatedErrorMessage(
          context.parseResult.document.template,
          context.errors.whereType<ParseError>().toList(),
          context.errors.whereType<RenderError>().toList(),
          imported: false,
        ),

        for (final parseResult in context.parsedImportedTemplates)
          if (parseResult.errors.isNotEmpty)
            createAggregatedErrorMessage(
              parseResult.document.template,
              parseResult.errors,
              [],
              imported: true,
            ),
      ].where((e) => e.isNotEmpty).join('\n');
}

/// A class that represents the result of rendering multiple templates.
/// The results of rendering multiple templates with shared state.
class RenderResults extends DelegatingList<RenderResult> {
  /// Variables remaining after all templates have been rendered.
  final Map<String, dynamic> variables;

  /// Parsed templates loaded while rendering imports.
  final Set<ParseResult> parsedImportedTemplates;

  /// A combined summary of errors across all rendered templates.
  late final String aggregatedErrorMessage = <String>[
    for (var renderResult in this)
      createAggregatedErrorMessage(
        renderResult.template,
        renderResult.errors.whereType<ParseError>().toList(),
        renderResult.errors.whereType<RenderError>().toList(),
        imported: false,
      ),

    ...expand((renderResult) => renderResult.parsedImportedTemplates)
        .toSet()
        .map(
          (parseResult) => createAggregatedErrorMessage(
            parseResult.document.template,
            parseResult.errors,
            [],
            imported: true,
          ),
        ),
  ].where((e) => e.isNotEmpty).join('\n');

  /// Creates results from individual render results and shared state.
  RenderResults(
    super.renderResults,
    this.parsedImportedTemplates,
    this.variables,
  );
}
