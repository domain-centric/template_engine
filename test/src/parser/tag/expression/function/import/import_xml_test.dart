import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  const path = 'test/src/parser/tag/expression/function/import/person.xml';

  test('test importXml on existing xml file', () {
    Variables xmlMap = {
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
    var parseResult = engine.parseText("{{importXml('$path')}}");
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be(xmlMap.toString());
  });

  test('test assigning importXml to a variable', () {
    var engine = TemplateEngine();
    var parseResult = engine.parseText("{{xml=importXml('$path')}}"
        "{{xml.person.child.name}}");
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('Jane Doe');
  });

  test('test importXml with none existing file', () {
    var engine = TemplateEngine();
    var parseResult = engine.parseText("{{xml=importXml('none_existing.xml')}}"
        "{{xml.person.child.name}}");
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('{{ERROR}}');
    renderResult.errorMessage.should.contain("Render errors in: "
        "'{{xml=importXml('none_existing.xml')}");
    renderResult.errorMessage.should.contain("1:7: Error importing a "
        "XML file: PathNotFoundException: Cannot open file, path");
    renderResult.errorMessage.should.contain("none_existing.xml");
    renderResult.errorMessage.should.contain(" 1:41: Variable "
        "does not exist: xml.person");
  });
}
