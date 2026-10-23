import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test(
    "{{items.clear()}}{{items}} for a non-empty map should render: {}",
    () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText("{{items.clear()}}{{items}}");
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
      renderResult.text.should.be("{}");
    },
  );

  test("{{items.clear()}} for an empty map should render: {}", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{items.clear()}}{{items}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {'items': {}},
    );
    renderResult.text.should.be('{}');
  });
}
