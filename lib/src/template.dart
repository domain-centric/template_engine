import 'package:template_engine/template_engine.dart';

/// A template is a text that can contain [Tag]s.
/// This text is parsed by the [TemplateEngine] into [RenderNode]s.
/// These [RenderNode]s render a new text.
/// [TagNode]s are replaced with some other text, depending on the
/// implementation of the [TagNode]
abstract class Template {
  /// Explains where the template text came form.
  String source;

  /// The text to be parsed by the [TemplateEngine]
  String text;

  Template({
    required this.source,
    required this.text,
  });
}

/// A part of a template that was identified by the [TemplateParserOld].
/// A [TemplateSection] is used for [Error]s
/// to identify which template has an error and where.
class TemplateSection {
  /// The source of the text
  final Template template;

  ///  The [row] for the start position within the template
  final int row;

  ///  The [column] for the start position within the template
  final int column;

  /// A part of a template text that was identified by the [TemplateParserOld].
  final String text;

  TemplateSection({
    required this.template,
    required this.row,
    required this.column,
    required this.text,
  });
}

class TextTemplate extends Template {
  TextTemplate(String text)
      : super(
          source: 'Text',
          text: text,
        );
}

//TODO FileTemplate: gets text from a file on this device
//TODO WebTemplate: gets text from a URL
