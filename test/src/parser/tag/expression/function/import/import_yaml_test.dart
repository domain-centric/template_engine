import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  const path = 'test/src/parser/tag/expression/function/import/person.yaml';

  test('test importYaml on existing yaml file', () {
    DataMap yamlMap = {
      'person': {
        'name': 'John Doe',
        'age': 30,
        'child': {
          'name': 'Jane Doe',
          'age': 5,
        }
      }
    };
    var engine = TemplateEngine();
    var parseResult = engine.parseText("{{importYaml('$path')}}");
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be(yamlMap.toString());
  });

  test('test assigning importYaml to a variable', () {
    var engine = TemplateEngine();
    var parseResult = engine.parseText("{{yaml=importYaml('$path')}}"
        "{{yaml.person.child.name}}");
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('Jane Doe');
  });

  test('test importYaml with none existing file', () {
    var engine = TemplateEngine();
    var parseResult =
        engine.parseText("{{yaml=importYaml('none_existing.yaml')}}"
            "{{yaml.person.child.name}}");
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('{{ERROR}}');
    renderResult.errorMessage.should.contain("Render errors in: "
        "'{{yaml=importYaml('none_existing.yaml')}");
    renderResult.errorMessage.should
        .contain("  1:8: Error importing a YAML file: Exception: "
            "Source could not be read: none_existing.yaml");
    renderResult.errorMessage.should.contain("none_existing.yaml");
    renderResult.errorMessage.should.contain(" 1:44: Variable "
        "does not exist: yaml.person");
  });
}
