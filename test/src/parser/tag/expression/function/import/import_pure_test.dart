import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('The import function should import a file as is', () {
    var engine = TemplateEngine();
    var parseResult = engine.parseText(
        "{{importPure('test/src/template_engine_template_example_test.dart')}}");
    var renderResult = engine.render(parseResult);
    renderResult.errorMessage.should.beNullOrEmpty();
    var expected = "import 'package:shouldly/shouldly.dart';\n"
        "import 'package:template_engine/template_engine.dart';\n"
        "\n"
        "void main() {\n"
        "  var engine = TemplateEngine();\n"
        "  var parseResult = engine.parseText('Hello {{name}}.');\n"
        "  var renderResult = engine.render(parseResult, {'name': 'world'});\n"
        "  renderResult.text.should.be('Hello world.');\n"
        "}\n";
    renderResult.text.should.be(expected);
  });
}
