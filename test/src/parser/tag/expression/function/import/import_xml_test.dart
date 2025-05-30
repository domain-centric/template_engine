import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  const path = 'test/src/parser/tag/expression/function/import/person.xml';

  test('test importXml on existing xml file', () async {
    DataMap xmlMap = {
      'person': {
        'name': 'John Doe',
        'age': 30,
        'child': {'name': 'Jane Doe', 'age': 5},
      },
    };
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{importXml('$path')}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be(xmlMap.toString());
  });

  test('test assigning importXml to a variable', () async {
    var engine = TemplateEngine();
    var input =
        "{{xml=importXml('$path')}}"
        "{{xml.person.child.name}}";
    var parseResult = await engine.parseText(input);
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('Jane Doe');
  });

  test('test importXml with none existing file', () async {
    var engine = TemplateEngine();
    var input =
        "{{xml=importXml('none_existing.xml')}}"
        "{{xml.person.child.name}}";
    var parseResult = await engine.parseText(input);
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('{{ERROR}}{{ERROR}}');
    renderResult.errorMessage.should.contain(
      "Render errors in: "
      "'{{xml=importXml('none_existing.xml')}",
    );
    renderResult.errorMessage.should.contain(
      "  1:7: Error importing a XML file: "
      "Error reading: none_existing.xml, "
      "PathNotFoundException: Cannot open file, path = 'none_existing.xml'",
    );
    renderResult.errorMessage.should.contain("none_existing.xml");
    renderResult.errorMessage.should.contain(
      " 1:41: Variable "
      "does not exist: xml",
    );
  });
}
