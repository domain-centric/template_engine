// ignore_for_file: avoid_print

import 'package:template_engine/template_engine.dart';

void main(List<String> args) {
  try {
    var engine = TemplateEngine();
    var readMeTemplateFile =
        createRelativeFile(['doc', 'template', 'README.md.template']);
    var readMeTemplate = FileTemplate(readMeTemplateFile);
    var parseResult = engine.parse(readMeTemplate);
    var renderResult = engine.render(parseResult);
    var readMeFile = createRelativeFile(['README.md']);
    readMeFile.writeAsStringSync(renderResult.text);
    print('Generated $readMeFile');
  } on Exception catch (e, stackTrace) {
    print(e);
    print(stackTrace);
  }
}
