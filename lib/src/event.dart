import 'package:template_engine/src/template.dart';
import 'package:recase/recase.dart';

/// Parser or Render error or warnings are collected as [Event]s instead
/// of being thrown so that the parser and rendering process can continue.
/// This way the caller can see and fix all [Event]s without having to fix and
/// recall the [TemplateEngine.parse] and [TemplateEngine.render] methods
/// for each [Event]

class Event {
  final DateTime occurrence;
  final EventStage stage;
  final EventSeverity severity;
  final String message;
  final TemplateSection source;

  Event({
    required this.stage,
    required this.severity,
    required this.message,
    required this.source,
  }) : occurrence = DateTime.now();

  Event.parseWarning(this.message, this.source)
      : stage = EventStage.parse,
        severity = EventSeverity.warning,
        occurrence = DateTime.now();

  Event.parseError(this.message, this.source)
      : stage = EventStage.parse,
        severity = EventSeverity.error,
        occurrence = DateTime.now();

  Event.renderWarning(this.message, this.source)
      : stage = EventStage.render,
        severity = EventSeverity.error,
        occurrence = DateTime.now();

  Event.renderError(this.message, this.source)
      : stage = EventStage.render,
        severity = EventSeverity.error,
        occurrence = DateTime.now();

  @override
  String toString() =>
      '${stage.name.titleCase} ${severity.name.titleCase}: $message $source';
}

enum EventSeverity {
  warning,
  error,
}

enum EventStage {
  parse,
  render,
}
