import 'package:documentation_builder/documentation_builder.dart';
import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('The import function should import an template file', () async {
    var engine = TemplateEngine();
    var templatePath = ProjectFilePath(
        'test/src/parser/tag/expression/function/import/import.md.template');
    var template = FileTemplate.fromProjectFilePath(templatePath);
    var parseResult = await engine.parseTemplate(template);
    var renderResult = await engine.render(parseResult);
    renderResult.errorMessage.should.beNullOrEmpty();
    renderResult.text.should.be('Line to import.$newLine'
        'Hello World.');
  });
}
