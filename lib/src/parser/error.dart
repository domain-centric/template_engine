import 'package:petitparser/petitparser.dart';
import 'package:template_engine/src/template.dart';

/// Parser or Render error or warnings are collected as [TemplateError]s instead
/// of being thrown so that the parser and rendering process can continue.
/// This way the caller can see and fix all [TemplateError]s without having to fix and
/// recall the [TemplateEngine.parse] and [TemplateEngine.render] methods
/// for each [TemplateError]

abstract class TemplateError implements Exception {
  String toIndentedString(int indent);

  String indentation(int indent) => '  ' * indent;

  @override
  String toString() => toIndentedString(0);
}

class RenderError extends TemplateError {
  final String message;

  /// A cursor position within the [Template.text] in format row, column
  final String position;

  RenderError({required this.message, required this.position});

  @override
  String toIndentedString(int indent) =>
      '${indentation(indent)}$position: $message';
}

class ParseError extends TemplateError {
  final String message;

  /// A cursor position within the [Template.text] in format row, column
  final String position;

  ParseError({required this.message, required this.position});

  ParseError.fromFailure(Failure failure)
    : message = failure.message,
      position = failure.toPositionString();

  @override
  String toIndentedString(int indent) =>
      '${indentation(indent)}$position: $message';
}

class ImportError extends TemplateError {
  final Template template;
  final String positionOfImport;
  final List<TemplateError> importErrors;
  ImportError(this.positionOfImport, this.template, this.importErrors);

  @override
  String toIndentedString(int indent) =>
      '${indentation(indent)}$positionOfImport: '
      'Error${importErrors.length > 1 ? 's' : ''} '
      'while importing ${template.sourceTitle}:\n'
      '${importErrors.map((e) => e.toIndentedString(indent + 1)).join('\n')}';
}
