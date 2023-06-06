import 'package:template_engine/template_engine.dart';

/// A template is a text that can contain [Tag]s.
/// This text is parsed by the [TemplateEngine] into [Renderer]s.
/// These [Renderer]s render a new text.
/// [TagRenderer]s are replaced with some other text, depending on the
/// implementation of the [TagRenderer]
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

class TextTemplate extends Template {
  TextTemplate(String text)
      : super(
          source: 'Text',
          text: text,
        );
}

//TODO FileTemplate: gets text from a file on this device
//TODO WebTemplate: gets text from a URL
