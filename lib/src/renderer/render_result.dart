import 'package:collection/collection.dart';
import 'package:template_engine/template_engine.dart';

class TemplateRenderResult {
  /// the template that was rendered
  final Template template;

  /// the rendered text of the template
  final String text;

  final List<TemplateEngineException> errors;

  /// the errors that occurred during parsing
  final List<ParseError> parserErrors;

  /// the errors that occurred during parsing
  final List<RenderError> renderErrors;

  TemplateRenderResult(RenderContext context, this.text)
    : template = context.parseResult.document.template,
      errors = context.errors,
      parserErrors = context.errors.whereType<ParseError>().toList(),
      renderErrors = context.errors.whereType<RenderError>().toList();
}

class RenderResult extends TemplateRenderResult {
  final Map<String, dynamic> variables;
  final Set<ParseResult> parsedImportedTemplates;
  final String aggregatedErrorMessage;

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
class RenderResults extends DelegatingList<RenderResult> {
  final Map<String, dynamic> variables;
  final Set<ParseResult> parsedImportedTemplates;
  late final String aggregatedErrorMessage = <String>[
    for (var renderResult in this)
      createAggregatedErrorMessage(
        renderResult.template,
        renderResult.errors.whereType<ParseError>().toList(),
        renderResult.errors.whereType<RenderError>().toList(),
        imported: false,
      ),

    ...expand(
      (renderResult) => renderResult.parsedImportedTemplates,
    ).toSet().map(
      (parseResult) => createAggregatedErrorMessage(
        parseResult.document.template,
        parseResult.errors,
        [],
        imported: true,
      ),
    ),
  ].where((e) => e.isNotEmpty).join('\n');

  RenderResults(
    super.renderResults,
    this.parsedImportedTemplates,
    this.variables,
  );
}
