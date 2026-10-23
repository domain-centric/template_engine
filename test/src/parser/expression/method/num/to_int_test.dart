import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test("{{3.toInt()}} should render: 3", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{3.toInt()}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('3');
  });

  test("{{4.5.toInt()}} should render: 4", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{4.5.toInt()}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('4');
  });

  test("{{5.99999.toInt()}} should render: 5", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{5.99999.toInt()}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('5');
  });
}
