import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test("{{'  Hello  '.trimLeft()}} should render: 'Hello  '", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{'  Hello  '.trimLeft()}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('Hello  ');
  });
}
