import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('The importPure function should import a file as is', () async {
    var engine = TemplateEngine();
    var parseResult = engine.parseText(
        "{{importPure('test/src/template_engine_template_example_test.dart')}}");
    var renderResult = await engine.render(parseResult);
    renderResult.errorMessage.should.beNullOrEmpty();
    var expected = "import 'package:shouldly/shouldly.dart';\n"
        "import 'package:template_engine/template_engine.dart';\n"
        "\n"
        "Future<void> main() async {\n"
        "  var engine = TemplateEngine();\n"
        "  var parseResult = engine.parseText('Hello {{name}}.');\n"
        "  var renderResult = await engine.render(parseResult, {'name': 'world'});\n"
        "  renderResult.text.should.be('Hello world.');\n"
        "}\n";
    renderResult.text.should.be(expected);
  });

  test('test importPure with none existing file', () async {
    var engine = TemplateEngine();
    var parseResult = engine.parseText("{{importPure('none_existent.dart')}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('{{ERROR}}');
    renderResult.errorMessage.should
        .contain("Render error in: '{{importPure('none_existent.dart')}}':");
    renderResult.errorMessage.should
        .contain("1:3: Error importing a pure file: Exception: Error reading: "
            "none_existent.dart, PathNotFoundException: Cannot open file, "
            "path = 'none_existent.dart'");
  });
}
