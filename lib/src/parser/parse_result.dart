import 'package:template_engine/template_engine.dart';

class ParseResult {
  final TemplateDocument document;
  final List<ParseError> errors;

  ParseResult({required this.document, required this.errors});
}
