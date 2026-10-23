import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test("{{'123'.toNumber()}} should render: 123", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{"123".toNumber()}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('123');
  });

  test("{{'12.3'.toNumber()}} should render: 12.3", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{"12.3".toNumber()}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('12.3');
  });

  test("{{'123456e-3'.toNumber()}} should render: 12.3e10", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{"123456e-3".toNumber()}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('123.456');
  });
}
