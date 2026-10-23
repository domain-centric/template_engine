import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  const path = 'test/src/parser/expression/function/import/person.xml';

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
    Should.satisfyAllConditions([
      () => renderResult.text.should.be('{{ERROR}}{{ERROR}}'),
      () => renderResult.errors.should.haveCount(2),
      () => renderResult.errors.first.message.should.contain(
        "Error importing a XML file: "
        "Error reading: none_existing.xml, "
        "PathNotFoundException: Cannot open file, path = 'none_existing.xml'",
      ),
      () =>
          renderResult.errors.first.location.should.be(TemplateLocation(1, 7)),
      () => renderResult.errors.last.message.should.be(
        'Variable `xml` does not exist',
      ),
      () =>
          renderResult.errors.last.location.should.be(TemplateLocation(1, 41)),
    ]);
  });
}
