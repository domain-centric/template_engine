import 'package:petitparser/petitparser.dart';
import 'package:template_engine/src/template.dart';
import 'package:recase/recase.dart';

/// Parser or Render error or warnings are collected as [Error]s instead
/// of being thrown so that the parser and rendering process can continue.
/// This way the caller can see and fix all [Error]s without having to fix and
/// recall the [TemplateEngine.parse] and [TemplateEngine.render] methods
/// for each [Error]

class Error {
  final ErrorStage stage;
  final String message;
  final Source source;

  Error.fromFailure({
    required this.stage,
    required Failure failure,
    required Template template,
  })  : message = failure.message,
        source = Source.fromContext(template, failure);

  Error.fromContext({
    required this.stage,
    required Context context,
    required this.message,
    required Template template,
  }) : source = Source.fromContext(template, context);

  Error.fromSource({
    required this.stage,
    required this.source,
    required this.message,
  });

  @override
  String toString() => '${stage.name.titleCase} Error: $message, '
      'position: ${source.position}, '
      'source: ${source.template.source}';
}

enum ErrorStage {
  parse,
  render,
}
