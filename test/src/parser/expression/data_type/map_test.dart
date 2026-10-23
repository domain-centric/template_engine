import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{Map()}} should result in an empty map', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{Map()}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('{}');
  });

  test(
    '{{Map("name": "Nils", "age": 12)}} should result in a map with values',
    () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText(
        '{{Map("name": "Nils", "age": 12)}}',
      );
      var renderResult = await engine.render(parseResult);
      renderResult.text.should.be('{name: Nils, age: 12}');
    },
  );

  test('Adding items to an empty literal map', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText(
      '{{objects=Map()}}'
      '{{objects.put("count", 3)}}'
      '{{objects.put("enabled", true)}}'
      '{{objects.put("name", "Hello")}}'
      '{{objects}}',
    );

    var renderResult = await engine.render(parseResult);
    var objects = renderResult.variables['objects']! as Map;

    Should.satisfyAllConditions([
      () => renderResult.errors.should.beEmpty(),
      () =>
          renderResult.text.should.be('{count: 3, enabled: true, name: Hello}'),
      () => objects.should.haveCount(3),
      () => (objects['count'] as num).should.be(3),
      () => (objects['enabled'] as bool).should.be(true),
      () => (objects['name'] as String).should.be('Hello'),
    ]);
  });

  test('Adding items to a literal map', () async {
    var engine = TemplateEngine();

    var parseResult = await engine.parseText(
      '{{objects=Map("count": 3, "enabled": true)}}'
      '{{objects.put("name", "Hello")}}'
      '{{objects}}',
    );

    var renderResult = await engine.render(parseResult);
    var objects = renderResult.variables['objects']! as Map;

    Should.satisfyAllConditions([
      () => renderResult.errors.should.beEmpty(),
      () =>
          renderResult.text.should.be('{count: 3, enabled: true, name: Hello}'),
      () => objects.should.haveCount(3),
      () => (objects['count'] as num).should.be(3),
      () => (objects['enabled'] as bool).should.be(true),
      () => (objects['name'] as String).should.be('Hello'),
    ]);
  });

  test('Adding items to a map from a variable', () async {
    var engine = TemplateEngine();

    var parseResult = await engine.parseText(
      '{{objects.put("name", "Hello")}}'
      '{{objects}}',
    );

    var renderResult = await engine.render(
      parseResult,
      variables: {
        'objects': {'count': 3, 'enabled': true},
      },
    );

    var objects = renderResult.variables['objects']! as Map;

    Should.satisfyAllConditions([
      () => renderResult.errors.should.beEmpty(),
      () =>
          renderResult.text.should.be('{count: 3, enabled: true, name: Hello}'),
      () => objects.should.haveCount(3),
      () => (objects['count'] as num).should.be(3),
      () => (objects['enabled'] as bool).should.be(true),
      () => (objects['name'] as String).should.be('Hello'),
    ]);
  });

  test('Get length of a map', () async {
    var engine = TemplateEngine();

    var parseResult = await engine.parseText(
      '{{objects=Map("count": 3, "enabled": true, "name": "Hello")}}'
      '{{objects.length()}}',
    );

    var renderResult = await engine.render(parseResult);
    var objects = renderResult.variables['objects']! as Map;

    Should.satisfyAllConditions([
      () => renderResult.errors.should.beEmpty(),
      () => renderResult.text.should.be('3'),
      () => objects.should.haveCount(3),
      () => (objects['count'] as num).should.be(3),
      () => (objects['enabled'] as bool).should.be(true),
      () => (objects['name'] as String).should.be('Hello'),
    ]);
  });

  test('Get the value of a given key in a map', () async {
    var engine = TemplateEngine();

    var parseResult = await engine.parseText(
      '{{objects=Map("count": 3, "enabled": true, "name": "Hello")}}'
      '{{objects.get("count")}}',
    );

    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('3');
  });

  test('Removing a value from a map', () async {
    var engine = TemplateEngine();

    var parseResult = await engine.parseText(
      '{{objects=Map("count": 3, "enabled": true, "name": "Hello")}}'
      '{{objects.remove("enabled")}}'
      '{{objects}}',
    );

    var renderResult = await engine.render(parseResult);
    var objects = renderResult.variables['objects']! as Map;

    Should.satisfyAllConditions([
      () => renderResult.errors.should.beEmpty(),
      () => renderResult.text.should.be('{count: 3, name: Hello}'),
      () => objects.should.haveCount(2),
      () => (objects['count'] as num).should.be(3),
      () => (objects['name'] as String).should.be('Hello'),
      () => objects.containsKey('enabled').should.be(false),
    ]);
  });

  test('{{Map(}} should return a correct error message', () async {
    var engine = TemplateEngine();

    var parseResult = await engine.parseText('{{Map(}}');
    var renderResult = await engine.render(parseResult);

    Should.satisfyAllConditions([
      () => parseResult.document.nodes.first.should.beOfType<ErrorNode>(),
      () => parseResult.errors.should.haveCount(1),
      () => parseResult.errors.first.message.should.be(
        'Unable to parse expression block: Missing closing parenthesis `)` in Map constructor',
      ),
      () => parseResult.errors.first.location.should.be(TemplateLocation(1, 7)),
      () => renderResult.text.should.be(''),
    ]);
  });

  test('{{Map("name" "Nils")}} should result in an error', () async {
    var engine = TemplateEngine();

    var parseResult = await engine.parseText('{{Map("name" "Nils")}}');

    var renderResult = await engine.render(parseResult);

    Should.satisfyAllConditions([
      () => parseResult.document.nodes.first.should.beOfType<ErrorNode>(),
      () => parseResult.errors.should.haveCount(1),
      () => parseResult.errors.first.message.should.be(
        'Unable to parse expression block: Expected `:` after map key',
      ),
      () => renderResult.text.should.be(''),
    ]);
  });

  test('{{Map("name": "Nils" "age": 12)}} should result in an error', () async {
    var engine = TemplateEngine();

    var parseResult = await engine.parseText(
      '{{Map("name": "Nils" "age": 12)}}',
    );

    var renderResult = await engine.render(parseResult);

    Should.satisfyAllConditions([
      () => parseResult.document.nodes.first.should.beOfType<ErrorNode>(),
      () => parseResult.errors.should.haveCount(1),
      () => parseResult.errors.first.message.should.be(
        'Unable to parse expression block: Expected `,` or `)` in Map constructor',
      ),
      () => renderResult.text.should.be(''),
    ]);
  });

  test('{{Map}} should return a correct error message', () async {
    var engine = TemplateEngine();

    var parseResult = await engine.parseText('{{Map}}');

    Should.satisfyAllConditions([
      () => parseResult.errors.should.haveCount(1),
      () => parseResult.errors.first.message.should.be(
        'Unable to parse expression block: Unexpected reserved keyword `map`',
      ),
      () => parseResult.errors.first.location.should.be(TemplateLocation(1, 3)),
    ]);
  });
}
