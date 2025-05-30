import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  group('Template types', () {
    final variables = {'name': 'World'};
    final templatePath = ProjectFilePath("test/src/hello_name.template");
    const expected = "Hello World.";

    test('using engine.parseText()', () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText('Hello {{name}}.');
      var renderResult = await engine.render(parseResult, variables);
      renderResult.text.should.be(expected);
    });

    test('using a TextTemplate', () async {
      var template = TextTemplate('Hello {{name}}.');
      var engine = TemplateEngine();
      var parseResult = await engine.parseTemplate(template);
      var renderResult = await engine.render(parseResult, variables);
      renderResult.text.should.be(expected);
    });

    test('using FileTemplate.fromProjectFilePath(filePath)', () async {
      var template = FileTemplate.fromProjectFilePath(templatePath);
      var engine = TemplateEngine();
      var parseResult = await engine.parseTemplate(template);
      var renderResult = await engine.render(parseResult, variables);
      renderResult.text.should.be(expected);
    });

    test('using FileTemplate(file)', () async {
      var template = FileTemplate(templatePath.file);
      var engine = TemplateEngine();
      var parseResult = await engine.parseTemplate(template);
      var renderResult = await engine.render(parseResult, variables);
      renderResult.text.should.be(expected);
    });

    test('using HttpTemplate', () async {
      final url = Uri.parse(
        "https://raw.githubusercontent.com/domain-centric/template_engine/"
        "main/test/src/hello_name.template",
      );
      var template = HttpTemplate(url);
      var engine = TemplateEngine();
      var parseResult = await engine.parseTemplate(template);
      var renderResult = await engine.render(parseResult, variables);
      renderResult.text.should.be(expected);
    });
  });
}
