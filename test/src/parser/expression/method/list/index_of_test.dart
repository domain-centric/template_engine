import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test("{{items.indexOf('apple')}} should render: 1", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{items.indexOf('apple')}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'items': [3, 'apple', 'banana'],
      },
    );
    renderResult.text.should.be('1');
  });

  test("{{items.indexOf('cherry')}} should render: -1", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{items.indexOf('cherry')}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'items': [3, null, 'apple', 'banana'],
      },
    );
    renderResult.text.should.be('-1');
  });

  test("{{numbers.indexOf(4)}} should render: -1", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{numbers.indexOf(4)}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {'numbers': <int>[]},
    );
    renderResult.text.should.be('-1');
  });

  test("{{numbers.indexOf(3)}} should render: 2", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{numbers.indexOf(3)}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'numbers': <int>[1, 2, 3, 4, 3],
      },
    );
    renderResult.text.should.be('2');
  });
  test("{{numbers.indexOf(4,2)}} should render: 2", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{numbers.indexOf(4,2)}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'numbers': <int>[1, 4, 4, 5],
      },
    );
    renderResult.text.should.be('2');
  });

  test("{{numbers.indexOf(1,3)}} should fail", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{numbers.indexOf(4,3)}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'numbers': <int>[1, 2, 3],
      },
    );
    Should.satisfyAllConditions([
      () => renderResult.errors.should.beEmpty(),
      () => renderResult.text.should.be('-1'),
    ]);
  });
}
