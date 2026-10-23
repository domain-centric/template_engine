import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test("{{items.length()}} should render: 4", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{items.length()}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'items': [3, null, 'apple', 'banana'],
      },
    );
    renderResult.errors.should.beEmpty();
    renderResult.text.should.be('4');
  });

  test("{{numbers.length()}} should render: 3", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{numbers.length()}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'numbers': <int>[1, 2, 3],
      },
    );
    renderResult.text.should.be('3');
  });

  test("{{words.length()}} should render: 2", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{words.length()}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'words': <String>['apple', 'banana'],
      },
    );
    renderResult.text.should.be('2');
  });
}
