import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test("{{2.00001.truncate()}} should render: 2", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{2.00001.truncate()}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('2');
  });

  test("{{1.99999.truncate()}} should render: 1", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{1.99999.truncate()}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('1');
  });

  test("{{0.5.truncate()}} should render: 0", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{0.5.truncate()}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('0');
  });

  test("{{(-0.5).truncate()}} should render: 0", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{(-0.5).truncate()}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('0');
  });

  test("{{(-1.5).truncate()}} should render: -1", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{(-1.5).truncate()}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('-1');
  });

  test("{{(-2.5).truncate()}} should render: -2", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{(-2.5).truncate()}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('-2');
  });
}
