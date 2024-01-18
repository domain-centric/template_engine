import 'dart:io';

import 'package:template_engine/template_engine.dart';

/// A template is a text that can contain [Tag]s.
/// This text is parsed by the [TemplateEngine] into [Renderer]s.
/// These [Renderer]s render a new text.
/// [TagRenderer]s are replaced with some other text, depending on the
/// implementation of the [TagRenderer]
abstract class Template {
  /// Explains where the template text came from.
  /// A [source] results in a [text].
  /// We use the [source] to identify and cash [Template]s for performance.
  late String source;

  /// Explains where the template text came from.
  /// It is used in [Error]s and can be shorter then [source]
  late String sourceTitle;

  /// The text to be parsed by the [TemplateEngine]
  late Future<String> text;

  /// Assuming that the text is the same for the same source
  /// so we can cash the Templates for performance

  @override
  bool operator ==(Object other) =>
      other is Template && other.source.toLowerCase() == source.toLowerCase();

  @override
  int get hashCode => source.toLowerCase().hashCode ^ text.hashCode;
}

class TextTemplate extends Template {
  TextTemplate(String text) {
    super.source = text;
    super.sourceTitle = createTitle(text);
    super.text = Future.value(text);
  }

  String createTitle(String text) {
    String firstLine = text.trim().split(RegExp('\\n')).first;

    if (firstLine.length > 40) {
      return "'${firstLine.substring(0, 40)}...'";
    } else {
      return "'$firstLine'";
    }
  }
}

class FileTemplate extends Template {
  @override
  FileTemplate(File file) {
    super.source = file.path;
    super.sourceTitle = file.path;
    super.text = readFromFilePath(file.path);
  }

  FileTemplate.fromProjectFilePath(ProjectFilePath projectFilePath) {
    super.source = projectFilePath.toString();
    super.sourceTitle = projectFilePath.toString();
    super.text = readFromFilePath(projectFilePath.file.path);
  }
}

class HttpTemplate extends Template {
  HttpTemplate(Uri url) {
    super.source = url.toString();
    super.sourceTitle = url.toString();
    super.text = readFromHttpUri(url.toString());
  }
}

class ImportedTemplate extends Template {
  ImportedTemplate({required String source, required String text}) {
    super.source = source;
    super.sourceTitle = source;
    super.text = Future.value(text);
  }
}
