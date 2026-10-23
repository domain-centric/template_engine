import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test("{{items.clear()}}{{items}} should render: {}", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{items.clear()}}{{items}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'items': {3, null, 'apple', 'banana'},
      },
    );
    renderResult.errors.should.beEmpty();
    renderResult.text.should.be('{}');
  });

  test("{{numbers.clear()}}{{numbers}} should render: {}", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{numbers.clear()}}{{numbers}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'numbers': {1, 2, 3},
      },
    );
    renderResult.text.should.be('{}');
  });

  test("{{words.clear()}}{{words}} should render: {}", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{words.clear()}}{{words}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'words': {'apple', 'banana'},
      },
    );
    renderResult.text.should.be('{}');
  });

  test("{{items.clear()}}{{items}} on a empty set should render: {}", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{items.clear()}}{{items}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {'items': <Object>{}},
    );
    renderResult.text.should.be('{}');
  });
}
