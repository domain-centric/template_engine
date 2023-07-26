/// a reference to a file in the Dart project
import 'dart:io';

import 'package:petitparser/petitparser.dart';

class ProjectFilePath {
  final String relativePath;

  static Parser<String> _fileOrFolderName() => (letter() |
          digit() |
          char('(') |
          char(')') |
          char('_') |
          char('-') |
          char('.'))
      .plus()
      .flatten();
  static Parser<List<List>> _pathParser() =>
      ((char('/') & _fileOrFolderName()).plus()).end();

  ProjectFilePath(this.relativePath) {
    validate(relativePath);
  }

  void validate(String path) {
    var result = _pathParser().parse(path);
    if (result.isFailure) {
      throw Exception('Invalid project file path: ${result.message} '
          'at position: ${result.position}');
    }
    if (!file.existsSync()) {
      throw Exception('Project file path does not exist: ${file.path}');
    }
  }

  String get fileName => _pathParser().parse(relativePath).value.last.last;

  File get file {
    var projectPath = Directory.current.path;
    var filePath = [
      ...projectPath.split(Platform.pathSeparator),
      ...relativePath.substring(1).split('/'),
    ].join(Platform.pathSeparator);
    return File(filePath);
  }

  Uri get githubUri =>
      Uri.parse('https://github.com/domain-centric/template_engine/blob/main'
          '$relativePath');

  String get githubMarkdownLink => '[$fileName]($githubUri)';
}
