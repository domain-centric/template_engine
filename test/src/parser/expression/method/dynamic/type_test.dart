import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test("{{true.type()}} should render: bool", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{true.type()}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('bool');
  });

  test("{{12.5.type()}} should render: double", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{12.5.type()}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('double');
  });

  test("{{12.type()}} should render: int", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{12.type()}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('int');
  });

  test("{{'String'.type()}} should render: String", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{'String'.type()}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('String');
  });

  test("{{listWithNumbers.type()}} should render: List<int>", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{listWithNumbers.type()}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'listWithNumbers': [1, 2, 3],
      },
    );
    renderResult.text.should.be('List<int>');
  });

  test("{{mapCollection.type()}} should render: Map<String, String>", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{mapCollection.type()}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'mapCollection': {'key': 'value'},
      },
    );
    renderResult.text.should.be('Map<String, String>');
  });
}
