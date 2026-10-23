import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test("{{'12345'.subString(0,2)}} should render: '12'", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{'12345'.subString(0,2)}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('12');
  });

  test("{{'12345'.subString(1,4)}} should render: '234'", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{'12345'.subString(1,4)}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('234');
  });

  test("{{'12345'.subString(3)}} should render: '45'", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{'12345'.subString(3)}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('45');
  });
}
