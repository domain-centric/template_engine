import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test(
    "{{items.removeAt(0)}}{{items}} should render: [apple, banana]",
    () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText(
        "{{items.removeAt(0)}}{{items}}",
      );
      var renderResult = await engine.render(
        parseResult,
        variables: {
          'items': [3, 'apple', 'banana'],
        },
      );
      renderResult.text.should.be('[apple, banana]');
    },
  );

  test("{{items.removeAt(1)}}{{items}} should render: [3, banana]", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{items.removeAt(1)}}{{items}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'items': [3, 'apple', 'banana'],
      },
    );
    renderResult.text.should.be('[3, banana]');
  });

  test("{{items.removeAt(2)}}{{items}} should render: [3, apple]", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{items.removeAt(2)}}{{items}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'items': [3, 'apple', 'banana'],
      },
    );
    renderResult.text.should.be('[3, apple]');
  });

  test(
    "{{items.removeAt(-1)}}{{items}} should render: null and have an error",
    () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText(
        "{{items.removeAt(-1)}}{{items}}",
      );
      var renderResult = await engine.render(
        parseResult,
        variables: {
          'items': [3, 'apple', 'banana'],
        },
      );

      Should.satisfyAllConditions([
        () => renderResult.text.should.be('[3, apple, banana]'),
        () => renderResult.errors.should.haveCount(1),
        () => renderResult.errors.first.message.should.be(
          'Index out of bounds: -1 (min:0 max:2)',
        ),
        () => renderResult.errors.first.location.should.be(
          TemplateLocation(1, 18),
        ),
      ]);
    },
  );

  test(
    "{{items.removeAt(3)}}{{items}} should render: null and have an error",
    () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText(
        "{{items.removeAt(3)}}{{items}}",
      );
      var renderResult = await engine.render(
        parseResult,
        variables: {
          'items': [3, 'apple', 'banana'],
        },
      );

      Should.satisfyAllConditions([
        () => renderResult.text.should.be('[3, apple, banana]'),
        () => renderResult.errors.should.haveCount(1),
        () => renderResult.errors.first.message.should.be(
          'Index out of bounds: 3 (min:0 max:2)',
        ),
        () => renderResult.errors.first.location.should.be(
          TemplateLocation(1, 18),
        ),
      ]);
    },
  );
}
