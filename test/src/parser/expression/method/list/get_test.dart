import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test("{{items.get(-1)}} should render: null and have an error", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{items.get(-1)}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'items': [3, 'apple', 'banana'],
      },
    );
    Should.satisfyAllConditions([
      () => renderResult.text.should.be('{{ERROR}}'),
      () => renderResult.errors.should.haveCount(1),
      () => renderResult.errors.first.message.should.be(
        'Index out of bounds: -1 (min:0 max:2)',
      ),
      () =>
          renderResult.errors.first.location.should.be(TemplateLocation(1, 13)),
    ]);
  });

  test("{{items.get(0)}} should render: 3", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{items.get(0)}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'items': [3, 'apple', 'banana'],
      },
    );
    renderResult.text.should.be('3');
  });

  test("{{items.get(1)}} should render: apple", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{items.get(1)}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'items': [3, 'apple', 'banana'],
      },
    );
    renderResult.text.should.be('apple');
  });

  test("{{items.get(2)}} should render: banana", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{items.get(2)}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'items': [3, 'apple', 'banana'],
      },
    );
    renderResult.text.should.be('banana');
  });

  test("{{items.get(3)}} should render: null and have an error", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{items.get(3)}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'items': [3, 'apple', 'banana'],
      },
    );
    Should.satisfyAllConditions([
      () => renderResult.text.should.be('{{ERROR}}'),
      () => renderResult.errors.should.haveCount(1),
      () => renderResult.errors.first.message.should.be(
        'Index out of bounds: 3 (min:0 max:2)',
      ),
      () =>
          renderResult.errors.first.location.should.be(TemplateLocation(1, 13)),
    ]);
  });
}
