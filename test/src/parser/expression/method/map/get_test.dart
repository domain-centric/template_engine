import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test("{{properties.get('age')}} should render: 30", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{properties.get('age')}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'properties': {'name': 'James', 'age': 30, 'city': 'New York'},
      },
    );
    renderResult.text.should.be('30');
  });

  test("{{properties.get('name')}} should render: James", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{properties.get('name')}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'properties': {'name': 'James', 'age': 30, 'city': 'New York'},
      },
    );
    renderResult.text.should.be('James');
  });

  test("{{properties.get('invalidKey')}} should render: "
      " and have an error", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText(
      "{{properties.get('invalidKey')}}",
    );
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'properties': {'name': 'James', 'age': 30, 'city': 'New York'},
      },
    );
    Should.satisfyAllConditions([
      () => renderResult.text.should.be(''),
      () => renderResult.errors.should.haveCount(1),
      () => renderResult.errors.first.message.should.be(
        'Key not found: `invalidKey`',
      ),
      () =>
          renderResult.errors.first.location.should.be(TemplateLocation(1, 18)),
    ]);
  });
}
