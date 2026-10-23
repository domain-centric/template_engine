import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test("{{'  Hello  '.trim()}} should render: 'Hello'", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{'  Hello  \t'.trim()}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('Hello');
  });
}
