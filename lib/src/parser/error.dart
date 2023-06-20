import 'package:template_engine/src/template.dart';
import 'package:recase/recase.dart';

/// Parser or Render error or warnings are collected as [Error]s instead
/// of being thrown so that the parser and rendering process can continue.
/// This way the caller can see and fix all [Error]s without having to fix and
/// recall the [TemplateEngine.parse] and [TemplateEngine.render] methods
/// for each [Error]

class Error {
  final DateTime occurrence;
  final ErrorStage stage;
  final String message;
  final TemplateSource source;

  Error({
    required this.stage,
    required this.message,
    required this.source,
  }) : occurrence = DateTime.now();

  @override
  String toString() => '${stage.name.titleCase} Error: $message $source';
}

enum ErrorStage {
  parse,
  render,
}

/// A [TemplateSource] to identify where a [Parser] error or warning
/// has occurred.
class TemplateSource {
  /// The source of the text
  final Template template;

  /// The current [Parser] position within the [Template].
  /// Format: {row}:{column}
  final String parserPosition;

  TemplateSource({required this.template, required this.parserPosition});

  @override
  String toString() => 'position: $parserPosition source: ${template.source}';
}
