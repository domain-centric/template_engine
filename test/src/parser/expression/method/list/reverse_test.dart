import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test("{{numbers.reverse()}}{{numbers}} should render: [3, 2, 1]", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText(
      "{{numbers.reverse()}}{{numbers}}",
    );
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'numbers': <int>[1, 2, 3],
      },
    );
    renderResult.text.should.be('[3, 2, 1]');
  });

  test(
    "{{words.reverse()}}{{words}} should render: [cherry, banana, apple]",
    () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText("{{words.reverse()}}{{words}}");
      var renderResult = await engine.render(
        parseResult,
        variables: {
          'words': <String>['apple', 'banana', 'cherry'],
        },
      );
      renderResult.text.should.be('[cherry, banana, apple]');
    },
  );

  test("{{empty.reverse()}}{{empty}} should render: []", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{empty.reverse()}}{{empty}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {'empty': <String>[]},
    );
    renderResult.text.should.be('[]');
  });

  test(
    "{{items.reverse()}}{{items}} should render: [4.15, banana, null, apple, 3]",
    () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText("{{items.reverse()}}{{items}}");
      var renderResult = await engine.render(
        parseResult,
        variables: {
          'items': <dynamic>[3, 'apple', null, 'banana', 4.15],
        },
      );
      renderResult.text.should.be('[4.15, banana, null, apple, 3]');
    },
  );
}
