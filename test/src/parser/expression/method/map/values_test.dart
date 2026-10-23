import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test("{{items.values()}} should render: {4, 5, 7}", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{items.values()}}");
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
    renderResult.text.should.be("[{4, 5, 7}, {apple, banana}]");
  });

  test("{{items.values()}} should render: {}", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{items.values()}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {'items': {}},
    );
    renderResult.text.should.be('[]');
  });
}
