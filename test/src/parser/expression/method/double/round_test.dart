import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test("{{3.0.round()}} should render: 3", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{3.0.round()}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('3');
  });

  test("{{3.25.round()}} should render: 3", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{3.25.round()}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('3');
  });

  test("{{3.5.round()}} should render: 4", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{3.5.round()}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('4');
  });

  test("{{3.75.round()}} should render: 4", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{3.75.round()}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('4');
  });

  test("{{-3.5.round()}} should render: -4", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{-3.5.round()}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('-4');
  });
}
