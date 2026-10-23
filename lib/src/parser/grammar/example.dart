import 'dart:io';

import 'package:template_engine/template_engine.dart';

abstract class Example {
  String get typeString;
  String toMarkdown(CodeBlockDelimiter delimiter);
}

class TestFileExample implements Example {
  @override
  final String typeString = 'test example';
  final Uri uri;
  final String title;

  static const gitProjectUri =
      'https://github.com/domain-centric/template_engine/blob/main/';

  const TestFileExample({required this.uri, required this.title});

  @override
  String toMarkdown(_) => toMarkdownLink();

  // returning in html so we can use it inside a html table
  String toMarkdownLink() => '<a href="$uri">$title</a>';

  factory TestFileExample.fromProjectFilePath(String relativeProjectPath) {
    var normalizedRelativePath = normalizeRelativePath(relativeProjectPath);
    //validateRelativePath(normalizedRelativePath);
    var uri = Uri.parse(
      'https://github.com/domain-centric/template_engine/blob/main/'
      '$normalizedRelativePath',
    );
    var title = normalizedRelativePath.split('/').last;
    return TestFileExample(uri: uri, title: title);
  }

  static String normalizeRelativePath(String relativePath) =>
      relativePath.replaceAll('\\', '/').replaceFirst(RegExp(r'^/'), '');

  static void validateRelativePath(String normalizedRelativePath) {
    var projectPath = Directory.current.path;
    var filePath = [
      ...projectPath.split(Platform.pathSeparator),
      ...normalizedRelativePath.split('/'),
    ].join(Platform.pathSeparator);
    File file = File(filePath);
    if (!file.existsSync()) {
      throw ArgumentError('File does not exist at path: $filePath');
    }
  }
}

class ExpressionBlockExample implements Example {
  @override
  final String typeString = 'code block example';
  final String Function(CodeBlockDelimiter delimiter) expressionBlockFunction;
  final Map<String, dynamic> variables;
  final String? explanation;
  final String? shouldRender;

  const ExpressionBlockExample(
    this.expressionBlockFunction, {
    this.variables = const {},
    this.explanation,
    this.shouldRender,
  });

  @override
  String toMarkdown(CodeBlockDelimiter delimiter) {
    var markdown = StringBuffer();
    markdown.write(expressionBlockFunction(delimiter));
    if (variables.isNotEmpty) {
      markdown.write('\nvariables: $variables\n');
    } else {
      markdown.write(' ');
    }
    if (shouldRender != null) {
      markdown.write('should render: ');
      if (shouldRender is String) {
        if (shouldRender!.isEmpty) {
          markdown.write('Nothing');
        } else {
          markdown.write("'$shouldRender'");
        }
      } else {
        markdown.write(shouldRender);
      }
    }
    return markdown.toString();
  }
}

abstract class ExampleProvider {
  List<Example> get examples;
}
