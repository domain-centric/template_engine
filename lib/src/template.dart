import 'dart:io';

import 'package:petitparser/petitparser.dart';
import 'package:template_engine/template_engine.dart';

/// A template is a text that can contain [Tag]s.
/// This text is parsed by the [TemplateEngine] into [Renderer]s.
/// These [Renderer]s render a new text.
/// [TagRenderer]s are replaced with some other text, depending on the
/// implementation of the [TagRenderer]
abstract class Template {
  /// Explains where the template text came form.
  final String source;

  /// The text to be parsed by the [TemplateEngine]
  final String text;

  const Template({
    required this.source,
    required this.text,
  });

  @override
  bool operator ==(Object other) =>
      other is Template && other.source.toLowerCase() == source.toLowerCase();

  @override
  int get hashCode => source.toLowerCase().hashCode;
}

class TextTemplate extends Template {
  const TextTemplate(String text)
      : super(
          source: 'Text',
          text: text,
        );
}

class FileTemplate extends Template {
  FileTemplate(File source)
      : super(source: source.path, text: source.readAsStringSync());

  FileTemplate.fromProjectFilePath(ProjectFilePath path) : this(path.file);
}

//TODO WebTemplate: gets text from a URL

/// A cursor position within the [Template.text]
/// where [RenderContext.errors] or [ParserContext.errors] occurred.
class Source {
  final Template template;

  /// A cursor position within the [Template.text] in format <row>, <column>
  final String position;

  Source.fromContext(this.template, Context context)
      : position = context.toPositionString();

  Source.fromPosition(this.template, this.position);
}
