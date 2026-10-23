import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test(
    "{{items.toSet()}} should render: {3, null, 'apple', 'banana'}",
    () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText("{{items.toSet()}}");
      var renderResult = await engine.render(
        parseResult,
        variables: {
          'items': [3, 3, null, 'apple', 'banana'],
        },
      );
      renderResult.errors.should.beEmpty();
      renderResult.text.should.be('{3, null, apple, banana}');
    },
  );

  test("{{numbers.toSet()}} should render: {1, 2, 3}", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{numbers.toSet()}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'numbers': [1, 2, 2, 3],
      },
    );
    renderResult.text.should.be('{1, 2, 3}');
  });

  test("{{words.toSet()}} should render: {apple, banana}", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{words.toSet()}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'words': ['apple', 'banana', 'banana'],
      },
    );
    renderResult.text.should.be('{apple, banana}');
  });
}
