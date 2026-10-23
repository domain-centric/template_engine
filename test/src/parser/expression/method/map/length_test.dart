import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test("{{items.length()}} should render: 2", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{items.length()}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'items': {
          'numbers': {4, 5, 7},
          'words': {'apple', 'banana'},
        },
      },
    );
    renderResult.errors.should.beEmpty();
    renderResult.text.should.be('2');
  });

  test("{{items.length()}} should render: 0", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{items.length()}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {'items': {}},
    );
    renderResult.text.should.be('0');
  });
}
