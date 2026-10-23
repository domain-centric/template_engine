import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test("{{'Hello'.length()}} should render: 5", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{'Hello'.length()}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('5');
  });

  test("{{('Hello' + ' world').length()}} should render: 11", () async {
    var engine = TemplateEngine();
    var input = "{{('Hello' + ' world').length()}}";
    var parseResult = await engine.parseText(input);
    var renderResult = await engine.render(parseResult);
    renderResult.errors.should.beEmpty();
    renderResult.text.should.be('11');
  });
}
