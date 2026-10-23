import 'dart:io';

import 'package:template_engine/template_engine.dart';

/// A [Template] is a text that can be parsed by the [TemplateEngine].
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
  FileTemplate(File file) {
    super.source = file.path;
    super.sourceTitle = file.path;
    super.text = readFromFilePath(file.path);
  }

  FileTemplate.fromFilePath(String projectFilePath) {
    super.source = projectFilePath;
    super.sourceTitle = projectFilePath;
    super.text = readFromFilePath(projectFilePath);
  }
}

class UriTemplate extends Template {
  UriTemplate(Uri uri) {
    super.source = uri.toString();
    super.sourceTitle = uri.toString();
    super.text = readFromUri(uri);
  }
}

class ImportedTemplate extends Template {
  ImportedTemplate({required String source, required String text}) {
    super.source = source;
    super.sourceTitle = source;
    super.text = Future.value(text);
  }
}
