import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test("{{items.last()}} should render: 3", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{items.last()}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'items': [3, null, 'apple', 'banana'],
      },
    );
    renderResult.errors.should.beEmpty();
    renderResult.text.should.be('banana');
  });

  test("{{numbers.last()}} should render: 3", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{numbers.last()}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'numbers': <int>[1, 2, 3],
      },
    );
    renderResult.text.should.be('3');
  });

  test("{{words.last()}} should render: {{ERROR}}", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{words.last()}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {'words': []},
    );
    Should.satisfyAllConditions([
      () => renderResult.text.should.be('{{ERROR}}'),
      () => renderResult.errors.first.message.should.be(
        'Cannot call last() on an empty list',
      ),
      () =>
          renderResult.errors.first.location.should.be(TemplateLocation(1, 9)),
      () => renderResult.text.should.be('{{ERROR}}'),
    ]);
  });
}
