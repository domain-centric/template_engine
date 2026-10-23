import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test("{{items.remove(3)}}{{items}} should render: [apple, banana]", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{items.remove(3)}}{{items}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'items': [3, 'apple', 'banana'],
      },
    );
    renderResult.text.should.be('[apple, banana]');
  });

  test(
    "{{items.remove('apple')}}{{items}} should render: [3, banana]",
    () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText(
        "{{items.remove('apple')}}{{items}}",
      );
      var renderResult = await engine.render(
        parseResult,
        variables: {
          'items': [3, 'apple', 'banana'],
        },
      );
      renderResult.text.should.be('[3, banana]');
    },
  );

  test("{{items.remove('cherry')}}{{items}} should render: [3, apple]", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText(
      "{{items.remove('cherry')}}{{items}}",
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
        'Item `cherry` is not part of the List and can therefore not be removed',
      ),
      () =>
          renderResult.errors.first.location.should.be(TemplateLocation(1, 16)),
    ]);
  });
}
