import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  const path = 'test/src/parser/expression/function/import/person.yaml';

  test('test importYaml on existing yaml file', () async {
    DataMap yamlMap = {
      'person': {
        'name': 'John Doe',
        'age': 30,
        'child': {'name': 'Jane Doe', 'age': 5},
      },
    };
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{importYaml('$path')}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be(yamlMap.toString());
  });

  test('test assigning importYaml to a variable', () async {
    var engine = TemplateEngine();
    var input =
        "{{yaml=importYaml('$path')}}"
        "{{yaml.person.child.name}}";
    var parseResult = await engine.parseText(input);
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('Jane Doe');
  });

  test('test importYaml with none existing file', () async {
    var engine = TemplateEngine();
    var input =
        "{{yaml=importYaml('none_existing.yaml')}}"
        "{{yaml.person.child.name}}";
    var parseResult = await engine.parseText(input);
    var renderResult = await engine.render(parseResult);
    Should.satisfyAllConditions([
      () => renderResult.text.should.be('{{ERROR}}{{ERROR}}'),
      () => renderResult.errors.should.haveCount(2),
      () => renderResult.errors[0].message.should.contain(
        "Error importing a YAML file: "
        "Error reading: none_existing.yaml, "
        "PathNotFoundException: Cannot open file, path = 'none_existing.yaml'",
      ),
      () => renderResult.errors[0].location.should.be(TemplateLocation(1, 8)),
      () => renderResult.errors[1].message.should.contain(
        'Variable `yaml` does not exist',
      ),
      () => renderResult.errors[1].location.should.be(TemplateLocation(1, 44)),
    ]);
  });
}
