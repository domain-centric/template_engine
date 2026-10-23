import 'package:template_engine/template_engine.dart';

bool isTruthy(dynamic value) {
  if (value == null) return false;
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) return value.isNotEmpty;
  if (value is Iterable || value is Map) return value.isNotEmpty;
  return true;
}

class RenderContext {
  final Grammar grammar;
  final Map<String, dynamic> variables;
  final List<TemplateEngineException> errors = [];

  /// The text that will be rendered in case the [AstNode] could not render
  final String errorPlaceholder;

  final ParseResult parseResult;

  /// cached parsed imported templates
  final Set<ParseResult> parsedImportedTemplates;

  RenderContext({
    required this.grammar,
    required this.parseResult,
    Set<ParseResult>? parsedImportedTemplates,
    Map<String, dynamic>? variables,
    this.errorPlaceholder = '{{ERROR}}',
  }) : // modifiable variable map
       variables = Map<String, dynamic>.from(variables ?? {}),
       parsedImportedTemplates = parsedImportedTemplates ?? {} {
    errors.addAll(parseResult.errors);
  }
}
