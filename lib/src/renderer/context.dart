import 'package:template_engine/template_engine.dart';

/// Converts a template value to the truthiness used by conditional nodes.
///
/// Null, false, zero, empty strings, and empty iterables or maps are false;
/// other values are true.
bool isTruthy(dynamic value) {
  if (value == null) return false;
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) return value.isNotEmpty;
  if (value is Iterable || value is Map) return value.isNotEmpty;
  return true;
}

/// Holds mutable state shared while rendering a parsed template.
class RenderContext {
  /// The grammar whose definitions are available during rendering.
  final Grammar grammar;

  /// The variables currently available to template expressions.
  final Map<String, dynamic> variables;

  /// Errors accumulated while rendering.
  final List<TemplateEngineException> errors = [];

  /// Text emitted when an [AstNode] cannot be rendered.
  final String errorPlaceholder;

  /// The parse result currently being rendered.
  final ParseResult parseResult;

  /// Parsed imported templates cached during rendering.
  final Set<ParseResult> parsedImportedTemplates;

  /// Creates a rendering context, copying [variables] into a mutable map.
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
