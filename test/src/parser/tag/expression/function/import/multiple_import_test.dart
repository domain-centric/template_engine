import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('Multiple imports of the same file, should only parse it once',
      () async {
    var engine = TemplateEngine();
    var input =
        "{{importTemplate('doc/template/common/generated_comment.template')}}\n"
        "{{importTemplate('doc/template/common/generated_comment.template')}}\n"
        "Hello World.\n"
        "{{importTemplate('doc/template/common/generated_comment.template')}}";
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

    var commentLine = "[//]: # (This document was generated "
        "by template_engine/tool/generate_documentation.dart "
        "from '{{importTemplate('doc/template/common/ge...')";
    var expectedText = "$commentLine\n"
        "$commentLine\n"
        'Hello World.\n'
        "$commentLine";
    result.text.should.be(expectedText);
  });
}
