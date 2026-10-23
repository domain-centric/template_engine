import 'package:template_engine/template_engine.dart';

abstract class TemplateEngineException implements Exception {
  String get message;
  TemplateLocation get location;
}

class ParseError implements TemplateEngineException {
  @override
  final String message;
  @override
  final TemplateLocation location;

  ParseError(this.message, this.location);

  @override
  String toString() => '${location.line}:${location.column} - $message';
}

class RenderError implements TemplateEngineException {
  @override
  final String message;
  @override
  final TemplateLocation location;

  RenderError(this.message, this.location);

  @override
  String toString() => '${location.line}:${location.column} - $message';
}

class ImportError implements RenderError {
  @override
  final String message;
  @override
  final TemplateLocation location;

  ImportError(this.location, RenderResult renderResult)
    : message = createMessage(renderResult);

  @override
  String toString() => '${location.line}:${location.column} - $message';

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

String indentedLines(String indentation, String text) =>
    text.split('\n').map((line) => '$indentation$line').join('\n');

class TemplateLocation {
  final int line;
  final int column;

  const TemplateLocation(this.line, this.column);

  const TemplateLocation.unknown() : this(-1, -1);

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
  String toString() => 'Line $line, Column $column';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TemplateLocation &&
        other.line == line &&
        other.column == column;
  }

  @override
  int get hashCode => Object.hash(line, column);

  // Explicit equals method (optional)
  bool equals(TemplateLocation other) {
    return line == other.line && column == other.column;
  }
}

String aggregatedParseErrorMessage(List<ParseError> errors) => indentedLines(
  '  ',
  [
    'Parse ${errors.length == 1 ? 'error' : 'errors'}:',
    ...errors.map((e) => indentedLines('  ', e.toString())),
  ].join('\n'),
);

String aggregatedRenderErrorMessage(List<RenderError> errors) => indentedLines(
  '  ',
  [
    'Render ${errors.length == 1 ? 'error' : 'errors'}:',
    ...errors.map((e) => indentedLines('  ', e.toString())),
  ].join('\n'),
);

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
