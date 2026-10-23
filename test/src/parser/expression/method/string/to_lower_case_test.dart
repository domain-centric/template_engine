import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test("{{'HELLO'.toLowerCase()}} should render: hello", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{'HELLO'.toLowerCase()}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('hello');
  });
}
