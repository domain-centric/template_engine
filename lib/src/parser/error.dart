import 'package:petitparser/petitparser.dart';
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
  final String position;
  final Template template;

  Error.fromFailure({
    required this.stage,
    required Failure failure,
    required this.template,
  })  : occurrence = DateTime.now(),
        message = failure.message,
        position = failure.toPositionString();

  Error.fromContext({
    required this.stage,
    required Context context,
    required this.message,
    required this.template,
  })  : occurrence = DateTime.now(),
        position = context.toPositionString();

  @override
  String toString() => '${stage.name.titleCase} Error: $message, '
      'position: $position, '
      'source: ${template.source}';
}

enum ErrorStage {
  parse,
  render,
}
