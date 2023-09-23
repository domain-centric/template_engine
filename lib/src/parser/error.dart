import 'package:petitparser/petitparser.dart';
import 'package:template_engine/src/template.dart';

/// Parser or Render error or warnings are collected as [Error]s instead
/// of being thrown so that the parser and rendering process can continue.
/// This way the caller can see and fix all [Error]s without having to fix and
/// recall the [TemplateEngine.parse] and [TemplateEngine.render] methods
/// for each [Error]

abstract class Error {
  final String message;

  /// A cursor position within the [Template.text] in format <row>, <column>
  final String position;

  Error({required this.message, required this.position});

  @override
  String toString() => '$position: $message';
}

class RenderError extends Error {
  RenderError({required super.message, required super.position});
}

class ParseError extends Error {
  ParseError({required super.message, required super.position});

  ParseError.fromFailure(Failure failure)
      : super(message: failure.message, position: failure.toPositionString());
}
