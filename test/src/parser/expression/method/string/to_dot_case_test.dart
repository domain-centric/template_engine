import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test("{{\"Hello World\".toDotCase()}} should render: hello.world", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{"Hello World".toDotCase()}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('hello.world');
  });
}
