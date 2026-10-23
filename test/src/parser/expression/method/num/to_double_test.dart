import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test("{{3.toDouble()}} should render: 3.0", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{3.toDouble()}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('3.0');
  });

  test("{{4.5.toDouble()}} should render: 4.5", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{4.5.toDouble()}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('4.5');
  });
}
