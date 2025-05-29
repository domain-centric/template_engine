import 'package:documentation_builder/documentation_builder.dart';
import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('Multiple imports of the same file, should only parse it once',
      () async {
    var engine = TemplateEngine();
    var path =
        'test/src/parser/tag/expression/function/import/to_import.md.template';
    var input = "{{importTemplate('$path')}}\n"
        "{{importTemplate('$path')}}\n"
        "Hello World.\n"
        "{{importTemplate('$path')}}";
    var parseResults = await engine.parseText(input);
    var parseResult = parseResults.children.first;
    var template = parseResult.template;
    var renderContext = RenderContext(
        engine: engine,
        templateBeingRendered: template,
        variables: {},
        parsedTemplates: parseResults.children);
    var result = await parseResult.render(renderContext);

    renderContext.parsedTemplates.length.should.be(2);

    result.text.should.be('Line to import.\n'
        'Line to import.\n'
        'Hello World.\n'
        'Line to import.');
  });
}
