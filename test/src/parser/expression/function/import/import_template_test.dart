import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('The import function should import an template file', () async {
    var engine = TemplateEngine();
    var templatePath =
        'test/src/parser/expression/function/import/import.md.template';
    var template = FileTemplate.fromFilePath(templatePath);
    var parseResult = await engine.parseTemplate(template);
    var renderResult = await engine.render(parseResult);
    renderResult.errors.should.beEmpty();
    renderResult.text.should.be(
      'Line to import.\r\n'
      'Hello World.',
    );
  });
}
