import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test("{{items.clear()}} should render: []", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{items.clear()}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'items': [3, null, 'apple', 'banana'],
      },
    );
    var items = renderResult.variables['items'] as List;
    items.should.beEmpty();
  });

  test("{{numbers.clear()}} should render: []", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{numbers.clear()}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'numbers': [1, 2, 3],
      },
    );
    var numbers = renderResult.variables['numbers'] as List;
    numbers.should.beEmpty();
  });

  test("{{words.clear()}} should render: []", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{words.clear()}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'words': ['apple', 'banana'],
      },
    );
    var words = renderResult.variables['words'] as List;
    words.should.beEmpty();
  });

  test("{{items.clear()}} on a empty set should render: []", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{items.clear()}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {'items': []},
    );
    var items = renderResult.variables['items'] as List;
    items.should.beEmpty();
  });
}
