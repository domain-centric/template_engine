import 'package:template_engine/template_engine.dart';

abstract class TemplateEngineException implements Exception {
  /// A human-readable description of the failure.
  String get message;

  /// The location in the template associated with the failure.
  TemplateLocation get location;
}

/// An error encountered while parsing template source.
class ParseError implements TemplateEngineException {
  @override
  /// A description of the parsing failure.
  final String message;

  /// The source location where parsing failed.
  @override
  final TemplateLocation location;

  /// Creates a parse error with a message and source location.
  ParseError(this.message, this.location);

  @override
  /// Formats the location and message as a single line.
  String toString() => '${location.line}:${location.column} - $message';
}

/// An error encountered while rendering a parsed template.
class RenderError implements TemplateEngineException {
  @override
  /// A description of the rendering failure.
  final String message;

  /// The source location where rendering failed.
  @override
  final TemplateLocation location;

  /// Creates a render error with a message and source location.
  RenderError(this.message, this.location);

  @override
  /// Formats the location and message as a single line.
  String toString() => '${location.line}:${location.column} - $message';
}

/// An error raised when rendering an imported template fails.
class ImportError implements RenderError {
  @override
  /// A summary of the errors in the imported template.
  final String message;

  /// The location of the import in the importing template.
  @override
  final TemplateLocation location;

  /// Creates an import error from the import location and render result.
  ImportError(this.location, RenderResult renderResult)
    : message = createMessage(renderResult);

  @override
  /// Formats the import location and nested errors.
  String toString() => '${location.line}:${location.column} - $message';

  /// Builds a message describing errors from an imported template.
  static String createMessage(RenderResult renderResult) {
    if (renderResult.renderErrors.isEmpty) {
      return '';
    }
    var firstLine =
        'Render '
        '${renderResult.renderErrors.length == 1 ? 'error' : 'errors'} '
        'in imported template: ${renderResult.template.source}';
    return [
      firstLine,
      ...renderResult.renderErrors.map(
        (e) => indentedLines('  ', e.toString()),
      ),
    ].join('\n');
  }
}

/// Prefixes each line of [text] with [indentation].
String indentedLines(String indentation, String text) =>
    text.split('\n').map((line) => '$indentation$line').join('\n');

/// A one-based line and column location in template source.
class TemplateLocation {
  /// The one-based line number, or `-1` when unknown.
  final int line;

  /// The one-based column number, or `-1` when unknown.
  final int column;

  /// Creates a location at [line] and [column].
  const TemplateLocation(this.line, this.column);

  /// Creates a location representing an unknown source position.
  const TemplateLocation.unknown() : this(-1, -1);

  /// Creates the location corresponding to [offset] in [text].
  factory TemplateLocation.fromOffset(String text, int offset) {
    final line = _lineForOffset(text, offset);
    final column = _columnForOffset(text, offset);
    return TemplateLocation(line, column);
  }

  static int _lineForOffset(String text, int offset) {
    return '\n'.allMatches(text.substring(0, offset)).length + 1;
  }

  static int _columnForOffset(String text, int offset) {
    final lastNewline = text.substring(0, offset).lastIndexOf('\n');
    return offset - lastNewline;
  }

  @override
  /// Returns a readable representation of this location.
  String toString() => 'Line $line, Column $column';

  @override
  /// Compares locations by line and column.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TemplateLocation &&
        other.line == line &&
        other.column == column;
  }

  @override
  /// Returns a hash code consistent with [operator ==].
  int get hashCode => Object.hash(line, column);

  /// Returns whether [other] has the same line and column.
  bool equals(TemplateLocation other) {
    return line == other.line && column == other.column;
  }
}

/// Formats [errors] as an indented parse-error summary.
String aggregatedParseErrorMessage(List<ParseError> errors) => indentedLines(
  '  ',
  [
    'Parse ${errors.length == 1 ? 'error' : 'errors'}:',
    ...errors.map((e) => indentedLines('  ', e.toString())),
  ].join('\n'),
);

/// Formats [errors] as an indented render-error summary.
String aggregatedRenderErrorMessage(List<RenderError> errors) => indentedLines(
  '  ',
  [
    'Render ${errors.length == 1 ? 'error' : 'errors'}:',
    ...errors.map((e) => indentedLines('  ', e.toString())),
  ].join('\n'),
);

/// Creates a combined parse and render error message for [template].
///
/// When [imported] is true, the message identifies the template as imported.
String createAggregatedErrorMessage(
  Template template,
  List<ParseError> parseErrors,
  List<RenderError> renderErrors, {
  bool imported = false,
}) {
  int nrOfErrors = parseErrors.length + renderErrors.length;
  if (nrOfErrors == 0) return '';
  return [
    '${nrOfErrors == 1 ? 'Error' : 'Errors'} '
        'in${imported ? ' imported' : ''}: ${template.source}',
    if (parseErrors.isNotEmpty) aggregatedParseErrorMessage(parseErrors),
    if (renderErrors.isNotEmpty) aggregatedRenderErrorMessage(renderErrors),
  ].join('\n');
}
