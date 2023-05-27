import 'package:template_engine/template_engine.dart';
import 'package:petitparser/petitparser.dart';

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

/// A [TemplateSection] to identify where a [Parser] error or warning 
/// has occurred.
class TemplateSection {
  /// The source of the text
  final Template template;

  /// The current [Parser] position within the [Template].
  /// Format: {row}:{column}
  final String parserPosition;

  TemplateSection({required this.template, required this.parserPosition});
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
