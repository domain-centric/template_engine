import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test(
    "{{items.remove('apple')}}{{items}} should render: {3, null, banana}",
    () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText(
        "{{items.remove('apple')}}{{items}}",
      );
      var renderResult = await engine.render(
        parseResult,
        variables: {
          'items': {3, null, 'apple', 'banana'},
        },
      );
      renderResult.errors.should.beEmpty();
      renderResult.text.should.be('{3, null, banana}');
    },
  );

  test("{{numbers.remove(3)}}{{numbers}} should render: {1, 2}", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText(
      "{{numbers.remove(3)}}{{numbers}}",
    );
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'numbers': {1, 2, 3},
      },
    );
    renderResult.text.should.be('{1, 2}');
  });

  test("{{words.remove('apple')}}{{words}} should render: {banana}", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText(
      "{{words.remove('apple')}}{{words}}",
    );
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'words': {'apple', 'banana'},
      },
    );
    renderResult.text.should.be('{banana}');
  });

  test("{{numbers.remove(4)}}{{numbers}} should fail", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText(
      "{{numbers.remove(4)}}{{numbers}}",
    );
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'numbers': {1, 2, 3},
      },
    );
    Should.satisfyAllConditions([
      () => renderResult.errors.first.message.should.be(
        'Item `4` is not part of the Set and can therefore not be removed',
      ),
      () =>
          renderResult.errors.first.location.should.be(TemplateLocation(1, 18)),
      () => renderResult.text.should.be('{1, 2, 3}'),
    ]);
  });

  test("{{numbers.remove(9)}}{{numbers}} should fail", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText(
      "{{numbers.remove(9)}}{{numbers}}",
    );
    var renderResult = await engine.render(
      parseResult,
      variables: {'numbers': <Object>{}},
    );
    Should.satisfyAllConditions([
      () => renderResult.errors.first.message.should.be(
        'Item `9` is not part of the Set and can therefore not be removed',
      ),
      () =>
          renderResult.errors.first.location.should.be(TemplateLocation(1, 18)),
      () => renderResult.text.should.be('{}'),
    ]);
  });
}
