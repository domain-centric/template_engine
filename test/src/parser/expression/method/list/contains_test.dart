import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test("{{items.contains(3)}} should render: true", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{items.contains(3)}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'items': [3, 'apple'],
      },
    );
    renderResult.text.should.be('true');
  });

  test("{{items.contains('apple')}} should render: true", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{items.contains('apple')}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'items': [3, 'apple'],
      },
    );
    renderResult.text.should.be('true');
  });

  test("{{items.contains('cherry')}} should render: false", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{items.contains('cherry')}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'items': [3, 'apple'],
      },
    );
    renderResult.text.should.be('false');
  });
}
