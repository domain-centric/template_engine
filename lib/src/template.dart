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

  /// Compares templates by their case-insensitive [source].
  @override
  bool operator ==(Object other) =>
      other is Template && other.source.toLowerCase() == source.toLowerCase();

  /// Returns a hash code derived from the source and text future.
  @override
  int get hashCode => source.toLowerCase().hashCode ^ text.hashCode;
}

/// A template whose source and contents are provided as text.
class TextTemplate extends Template {
  /// Creates a template from [text].
  TextTemplate(String text) {
    super.source = text;
    super.sourceTitle = createTitle(text);
    super.text = Future.value(text);
  }

  /// Creates a short display title from the first line of [text].
  String createTitle(String text) {
    String firstLine = text.trim().split(RegExp('\\n')).first;

    if (firstLine.length > 40) {
      return "'${firstLine.substring(0, 40)}...'";
    } else {
      return "'$firstLine'";
    }
  }
}

/// A template loaded from a local file.
class FileTemplate extends Template {
  /// Creates a template backed by [file].
  FileTemplate(File file) {
    super.source = file.path;
    super.sourceTitle = file.path;
    super.text = readFromFilePath(file.path);
  }

  /// Creates a template backed by the file at [projectFilePath].
  FileTemplate.fromFilePath(String projectFilePath) {
    super.source = projectFilePath;
    super.sourceTitle = projectFilePath;
    super.text = readFromFilePath(projectFilePath);
  }
}

/// A template loaded from a URI.
class UriTemplate extends Template {
  /// Creates a template backed by [uri].
  UriTemplate(Uri uri) {
    super.source = uri.toString();
    super.sourceTitle = uri.toString();
    super.text = readFromUri(uri);
  }
}

/// A template created from source and text already loaded by an import.
class ImportedTemplate extends Template {
  /// Creates an imported template with its [source] identifier and [text].
  ImportedTemplate({required String source, required String text}) {
    super.source = source;
    super.sourceTitle = source;
    super.text = Future.value(text);
  }
}
