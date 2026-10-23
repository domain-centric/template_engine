import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test("{{items.first()}} should render: 3", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{items.first()}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'items': [3, null, 'apple', 'banana'],
      },
    );
    renderResult.errors.should.beEmpty();
    renderResult.text.should.be('3');
  });

  test("{{numbers.first()}} should render: 1", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{numbers.first()}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'numbers': <int>[1, 2, 3],
      },
    );
    renderResult.text.should.be('1');
  });

  test("{{words.first()}} should render: apple", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{words.first()}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'words': <String>['apple', 'banana'],
      },
    );
    renderResult.text.should.be('apple');
  });

  test("{{words.first()}} should render: {{ERROR}}", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{words.first()}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {'words': []},
    );
    Should.satisfyAllConditions([
      () => renderResult.errors.first.message.should.be(
        'Cannot call first() on an empty list',
      ),
      () =>
          renderResult.errors.first.location.should.be(TemplateLocation(1, 9)),
      () => renderResult.text.should.be('{{ERROR}}'),
    ]);
  });
}
