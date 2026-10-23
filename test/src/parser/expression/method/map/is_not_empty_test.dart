import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test("{{items.isNotEmpty()}} should render: true", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{items.isNotEmpty()}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'items': {'number': 3},
      },
    );
    renderResult.errors.should.beEmpty();
    renderResult.text.should.be('true');
  });
  test("{{items.isNotEmpty()}} should render: false", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{items.isNotEmpty()}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {'items': <String, int>{}},
    );
    renderResult.errors.should.beEmpty();
    renderResult.text.should.be('false');
  });
}
