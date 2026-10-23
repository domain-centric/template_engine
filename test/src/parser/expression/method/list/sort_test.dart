import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test("{{numbers.sort()}}{{numbers}} should render: [3, 4, 19]", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{numbers.sort()}}{{numbers}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'numbers': <int>[4, 19, 3],
      },
    );
    renderResult.text.should.be('[3, 4, 19]');
  });

  test("{{words.sort()}}{{words}} should render: [apple, banana]", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{words.sort()}}{{words}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'words': <String>['cherry', 'apple', 'banana'],
      },
    );
    renderResult.text.should.be('[apple, banana, cherry]');
  });

  test("{{empty.sort()}}{{empty}} should render: []", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{empty.sort()}}{{empty}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {'empty': <String>[]},
    );
    renderResult.text.should.be('[]');
  });

  test("{{items.sort()}}{{items}} should render: {{ERROR}}", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{items.sort()}}{{items}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'items': <dynamic>[3, 'apple', 'banana', 4.15],
      },
    );
    Should.satisfyAllConditions([
      () => renderResult.errors.first.message.should.be(
        "Error occurred while sorting the list: type 'String' is not a subtype of type 'num' of 'other'",
      ),
      () =>
          renderResult.errors.first.location.should.be(TemplateLocation(1, 9)),
      () => renderResult.text.should.be('[3, apple, banana, 4.15]'),
    ]);
  });
}
