import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test("{{\"Hello world\".toCamelCase()}} should render: helloWorld", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{"Hello world".toCamelCase()}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('helloWorld');
  });
}
