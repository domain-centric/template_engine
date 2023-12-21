import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  const path = 'test/src/parser/tag/expression/function/import/person.json';

  test('test importJson on existing json file', () {
    DataMap jsonMap = {
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
    var parseResult = engine.parseText("{{importJson('$path')}}");
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be(jsonMap.toString());
  });

  test('test assigning importJson to a variable', () {
    var engine = TemplateEngine();
    var parseResult = engine.parseText("{{json=importJson('$path')}}"
        "{{json.person.child.name}}");
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('Jane Doe');
  });

  test('test importJson with none existing file', () {
    var engine = TemplateEngine();
    var parseResult =
        engine.parseText("{{json=importJson('none_existing.json')}}"
            "{{json.person.child.name}}");
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('{{ERROR}}');
    renderResult.errorMessage.should.contain("Render errors in: "
        "'{{json=importJson('none_existing.json')}");
    renderResult.errorMessage.should.contain(
        "1:8: Error importing a Json file: Exception: Source could not be read: none_existing.json");
    renderResult.errorMessage.should.contain(" 1:44: Variable "
        "does not exist: json.person");
  });
}
