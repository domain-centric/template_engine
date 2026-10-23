import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  const path = 'test/src/parser/expression/function/import/person.json';

  test('test importJson on existing json file', () async {
    DataMap jsonMap = {
      'person': {
        'name': 'John Doe',
        'age': 30,
        'child': {'name': 'Jane Doe', 'age': 5},
      },
    };
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{importJson('$path')}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be(jsonMap.toString());
  });

  test('test assigning importJson to a variable', () async {
    var engine = TemplateEngine();
    var input =
        "{{json=importJson('$path')}}"
        "{{json.person.child.name}}";
    var parseResult = await engine.parseText(input);
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('Jane Doe');
  });

  test('test importJson with none existing file', () async {
    var engine = TemplateEngine();
    var input =
        "{{json=importJson('none_existing.json')}}"
        "{{json.person.child.name}}";
    var parseResult = await engine.parseText(input);
    var renderResult = await engine.render(parseResult);
    Should.satisfyAllConditions([
      () => renderResult.text.should.be('{{ERROR}}{{ERROR}}'),
      () => renderResult.errors.should.haveCount(2),
      () => renderResult.errors.first.message.should.contain(
        "Error importing a Json file: "
        "Error reading: none_existing.json, "
        "PathNotFoundException: Cannot open file, path = 'none_existing.json'",
      ),
      () =>
          renderResult.errors.first.location.should.be(TemplateLocation(1, 8)),
      () => renderResult.errors.last.message.should.be(
        'Variable `json` does not exist',
      ),
      () =>
          renderResult.errors.last.location.should.be(TemplateLocation(1, 44)),
    ]);
  });
}
