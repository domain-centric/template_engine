// ignore_for_file: avoid_print

import 'dart:io';

import 'package:template_engine/template_engine.dart';

void main(List<String> args) {
  try {
    var engine = TemplateEngine();
    var readMeTemplate = ReadMeTemplate();
    var parseResult = engine.parse(readMeTemplate);
    var renderResult = engine.render(parseResult);
    var readMeFile = _createRelativeFile(['README.md']);
    readMeFile.writeAsStringSync(renderResult.text);
    print('Generated $readMeFile');
  } on Exception catch (e, stackTrace) {
    print(e);
    print(stackTrace);
  }
}

/// creates a file relative to the current path
File _createRelativeFile(List<String> relativePath) {
  var currentPath = Directory.current.path;
  var filePath = [
    ...currentPath.split(Platform.pathSeparator),
    ...relativePath,
  ].join(Platform.pathSeparator);
  return File(filePath);
}

class ReadMeTemplate extends FileTemplate {
  ReadMeTemplate()
      : super(_createRelativeFile(['doc', 'template', 'README.md.template']));
}

class FileTemplate extends Template {
  FileTemplate(File source)
      : super(source: source.path, text: source.readAsStringSync());
}
