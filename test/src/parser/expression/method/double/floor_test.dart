import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test("{{1.99999.floor()}} should render: 1", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{1.99999.floor()}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('1');
  });

  test("{{2.0.floor())}} should render: 2", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{2.0.floor())}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('2');
  });

  test("{{2.99999.floor()}} should render: 2", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{2.99999.floor()}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('2');
  });

  test("{{(-1.99999).floor()}} should render: -2", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{(-1.99999).floor()}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('-2');
  });

  test("{{-2.0.floor()}} should render: -2", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{-2.0.floor()}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('-2');
  });

  test("{{(-2.00001).floor()}} should render: -3", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{(-2.00001).floor()}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('-3');
  });
}
