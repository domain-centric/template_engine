// ignore_for_file: avoid_print

import 'package:template_engine/template_engine.dart';

void main(List<String> args) {
  try {
    var engine = TemplateEngine();
    generate(
        engine: engine,
        templatePath: ProjectFilePath('doc/template/README.md.template'),
        outputPath: ProjectFilePath('README.md'));
    generate(
        engine: engine,
        templatePath: ProjectFilePath('doc/template/example.md.template'),
        outputPath: ProjectFilePath('example/example.md'));
  } on Exception catch (e, stackTrace) {
    print(e);
    print(stackTrace);
  }
}

Future<void> generate(
    {required TemplateEngine engine,
    required ProjectFilePath templatePath,
    required ProjectFilePath outputPath}) async {
  var template = FileTemplate(templatePath.file);
  var parseResult = engine.parseTemplate(template);
  var renderResult = await engine.render(parseResult);
  if (parseResult.errorMessage.isNotEmpty) {
    print(parseResult.errorMessage);
  }
  if (renderResult.errorMessage.isNotEmpty) {
    print(renderResult.errorMessage);
  }
  outputPath.file.writeAsStringSync(renderResult.text);
  print('Generated ${outputPath.file}');
}
