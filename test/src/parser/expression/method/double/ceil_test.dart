import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test("{{1.99999.ceil()}} should render: 2", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{1.99999.ceil()}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('2');
  });

  test("{{2.0.ceil())}} should render: 2", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{2.0.ceil())}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('2');
  });

  test("{{2.00001.ceil()}} should render: 3", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{2.00001.ceil()}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('3');
  });

  test("{{(-1.99999).ceil()}} should render: -1", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{(-1.99999).ceil()}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('-1');
  });

  test("{{-2.0.ceil()}} should render: -2", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{-2.0.ceil()}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('-2');
  });

  test("{{(-2.00001).ceil()}} should render: -2", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{(-2.00001).ceil()}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('-2');
  });
}
