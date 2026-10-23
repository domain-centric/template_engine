import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{List()}} should result in an empty list', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{List()}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('[]');
  });

  test(
    '{{List(1, true, "Hello")}} should result in a list with values',
    () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText('{{List(1, true, "Hello")}}');
      var renderResult = await engine.render(parseResult);
      renderResult.text.should.be('[1, true, Hello]');
    },
  );

  test('Adding items to an empty literal list', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText(
      '{{objects=List()}}'
      '{{objects.add(3)}}'
      '{{objects.add(true)}}'
      '{{objects.add("Hello")}}'
      '{{objects}}',
    );
    var renderResult = await engine.render(parseResult);
    var objects = renderResult.variables['objects']! as List;
    Should.satisfyAllConditions([
      () => renderResult.errors.should.beEmpty(),
      () => renderResult.text.should.be('[3, true, Hello]'),
      () => objects.should.haveCount(3),
      () => (objects[0] as num).should.be(3),
      () => (objects[1] as bool).should.be(true),
      () => (objects[2] as String).should.be('Hello'),
    ]);
  });

  test('Adding items to an literal list', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText(
      '{{objects=List(3, true)}}'
      '{{objects.add("Hello")}}'
      '{{objects}}',
    );
    var renderResult = await engine.render(parseResult);
    var objects = renderResult.variables['objects']! as List;
    Should.satisfyAllConditions([
      () => renderResult.errors.should.beEmpty(),
      () => renderResult.text.should.be('[3, true, Hello]'),
      () => objects.should.haveCount(3),
      () => (objects[0] as num).should.be(3),
      () => (objects[1] as bool).should.be(true),
      () => (objects[2] as String).should.be('Hello'),
    ]);
  });

  test('Adding items to a list from a variable', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText(
      '{{objects.add("Hello")}}'
      '{{objects}}',
    );
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'objects': [3, true],
      },
    );
    var objects = renderResult.variables['objects']! as List;
    Should.satisfyAllConditions([
      () => renderResult.errors.should.beEmpty(),
      () => renderResult.text.should.be('[3, true, Hello]'),
      () => objects.should.haveCount(3),
      () => (objects[0] as num).should.be(3),
      () => (objects[1] as bool).should.be(true),
      () => (objects[2] as String).should.be('Hello'),
    ]);
  });

  test('Get length of a list', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText(
      '{{objects=List(3, true, "Hello")}}'
      '{{objects.length()}}',
    );
    var renderResult = await engine.render(parseResult);
    var objects = renderResult.variables['objects']! as List;
    Should.satisfyAllConditions([
      () => renderResult.errors.should.beEmpty(),
      () => renderResult.text.should.be('3'),
      () => objects.should.haveCount(3),
      () => (objects[0] as num).should.be(3),
      () => (objects[1] as bool).should.be(true),
      () => (objects[2] as String).should.be('Hello'),
    ]);
  });

  test('Get the value of a given index in a list', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText(
      '{{objects=List(3, true, "Hello")}}'
      '{{objects.get(0)}}',
    );
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('3');
  });

  test('Removing a value from a list', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText(
      '{{objects=List(3, true, "Hello")}}'
      '{{objects.remove(true)}}'
      '{{objects}}',
    );
    var renderResult = await engine.render(parseResult);
    var objects = renderResult.variables['objects']! as List;
    Should.satisfyAllConditions([
      () => renderResult.errors.should.beEmpty(),
      () => renderResult.text.should.be('[3, Hello]'),
      () => objects.should.haveCount(2),
      () => (objects[0] as num).should.be(3),
      () => (objects[1] as String).should.be('Hello'),
    ]);
  });

  test('removing an indexed value from a list', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText(
      '{{objects=List(3, true, "Hello")}}'
      '{{objects.removeAt(0)}}'
      '{{objects}}',
    );
    var renderResult = await engine.render(parseResult);
    var objects = renderResult.variables['objects']! as List;
    Should.satisfyAllConditions([
      () => renderResult.errors.should.beEmpty(),
      () => renderResult.text.should.be('[true, Hello]'),
      () => objects.should.haveCount(2),
      () => (objects[0] as bool).should.be(true),
      () => (objects[1] as String).should.be('Hello'),
    ]);
  });

  test('{{List(}} should return a correct error message', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{List(}}');
    var renderResult = await engine.render(parseResult);
    Should.satisfyAllConditions([
      () => parseResult.document.nodes.first.should.beOfType<ErrorNode>(),
      () => parseResult.errors.should.haveCount(1),
      () => parseResult.errors.first.message.should.be(
        "Unable to parse expression block: Missing closing parenthesis `)` in List constructor",
      ),
      () => parseResult.errors.first.location.should.be(TemplateLocation(1, 8)),
      () => renderResult.text.should.be(''),
    ]);
  });

  test('{{List(1, true "Hello")}} should result in an error', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{List(1, true "Hello")}}');
    var renderResult = await engine.render(parseResult);
    Should.satisfyAllConditions([
      () => parseResult.document.nodes.first.should.beOfType<ErrorNode>(),
      () => parseResult.errors.should.haveCount(1),
      () => parseResult.errors.first.message.should.be(
        'Unable to parse expression block: Expected `,` or `)` in List constructor',
      ),
      () =>
          renderResult.errors.first.location.should.be(TemplateLocation(1, 16)),
      () => renderResult.text.should.be(''),
    ]);
  });

  test('{{List(1, true, "Hello )}} should result in an error', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{List(1, true, "Hello )}}');
    var renderResult = await engine.render(parseResult);
    Should.satisfyAllConditions([
      () => parseResult.document.nodes.first.should.beOfType<ErrorNode>(),
      () => parseResult.errors.should.haveCount(1),
      () => parseResult.errors.first.message.should.be(
        'Unable to parse expression block: Unsupported `"Hello )` in expression',
      ),
      () =>
          renderResult.errors.first.location.should.be(TemplateLocation(1, 25)),
      () => renderResult.text.should.be(''),
    ]);
  });

  test('{{List}} should return a correct error message', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{List}}');
    Should.satisfyAllConditions([
      () => parseResult.errors.should.haveCount(1),
      () => parseResult.errors.first.message.should.be(
        'Unable to parse expression block: Unexpected reserved keyword `list`',
      ),
      () => parseResult.errors.first.location.should.be(TemplateLocation(1, 3)),
    ]);
  });
}
