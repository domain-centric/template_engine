import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test("{{12.5.toString()}} should render: 12.5", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{12.5.toString()}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('12.5');
  });
}
