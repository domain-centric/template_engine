import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('Multiple imports of the same file, should only parse it once', () {
    var engine = TemplateEngine();
    var parseResults = engine.parseText(
        "{{import('doc/template/common/generated_comment.template')}}\n"
        "{{import('doc/template/common/generated_comment.template')}}\n"
        "Hello World.\n"
        "{{import('doc/template/common/generated_comment.template')}}");

    var parseResult = parseResults.children.first;
    var template = parseResult.template;
    var renderContext = RenderContext(
        engine: engine,
        templateBeingRendered: template,
        variables: {},
        parsedTemplates: parseResults.children);
    var text = parseResult.render(renderContext);

    renderContext.parsedTemplates.length.should.be(2);

    renderContext.errors.should.beEmpty();

    var commentLine = "[//]: # (This document was generated "
        "by template_engine/tool/generate_documentation.dart "
        "from '{{import('doc/template/common/generated_...')";
    var expectedText = "$commentLine\n"
        "$commentLine\n"
        'Hello World.\n'
        "$commentLine";
    text.should.be(expectedText);
  });
}
