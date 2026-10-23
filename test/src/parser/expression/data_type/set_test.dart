import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{Set()}} should result in an empty set', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{Set()}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('{}');
  });

  test(
    '{{Set(1, true, "Hello")}} should result in a set with values',
    () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText('{{Set(1, true, "Hello")}}');
      var renderResult = await engine.render(parseResult);
      Should.satisfyAllConditions([
        () => renderResult.errors.should.beEmpty(),
        () => renderResult.text.should.contain('1'),
        () => renderResult.text.should.contain('true'),
        () => renderResult.text.should.contain('Hello'),
      ]);
    },
  );

  test('Adding items to an empty literal set', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText(
      '{{objects=Set()}}'
      '{{objects.add(3)}}'
      '{{objects.add(true)}}'
      '{{objects.add("Hello")}}'
      '{{objects}}',
    );

    var renderResult = await engine.render(parseResult);
    var objects = renderResult.variables['objects']! as Set;

    Should.satisfyAllConditions([
      () => renderResult.errors.should.beEmpty(),
      () => objects.should.haveCount(3),
      () => objects.contains(3).should.be(true),
      () => objects.contains(true).should.be(true),
      () => objects.contains('Hello').should.be(true),
    ]);
  });

  test('Adding duplicate items to a set should not increase size', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText(
      '{{objects=Set()}}'
      '{{objects.add(3)}}'
      '{{objects.add(3)}}'
      '{{objects}}',
    );

    var renderResult = await engine.render(parseResult);
    var objects = renderResult.variables['objects']! as Set;

    Should.satisfyAllConditions([
      () => renderResult.errors.should.beEmpty(),
      () => objects.should.haveCount(1),
      () => objects.contains(3).should.be(true),
    ]);
  });

  test('Adding items to a literal set', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText(
      '{{objects=Set(3, true)}}'
      '{{objects.add("Hello")}}'
      '{{objects}}',
    );

    var renderResult = await engine.render(parseResult);
    var objects = renderResult.variables['objects']! as Set;

    Should.satisfyAllConditions([
      () => renderResult.errors.should.beEmpty(),
      () => objects.should.haveCount(3),
      () => objects.contains(3).should.be(true),
      () => objects.contains(true).should.be(true),
      () => objects.contains('Hello').should.be(true),
    ]);
  });

  test('Adding items to a set from a variable', () async {
    var engine = TemplateEngine();

    var parseResult = await engine.parseText(
      '{{objects.add("Hello")}}'
      '{{objects}}',
    );

    var renderResult = await engine.render(
      parseResult,
      variables: {
        'objects': {3, true},
      },
    );

    var objects = renderResult.variables['objects']! as Set;

    Should.satisfyAllConditions([
      () => renderResult.errors.should.beEmpty(),
      () => objects.should.haveCount(3),
      () => objects.contains(3).should.be(true),
      () => objects.contains(true).should.be(true),
      () => objects.contains('Hello').should.be(true),
    ]);
  });

  test('Get length of a set', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText(
      '{{objects=Set(3, true, "Hello")}}'
      '{{objects.length()}}',
    );

    var renderResult = await engine.render(parseResult);
    var objects = renderResult.variables['objects']! as Set;

    Should.satisfyAllConditions([
      () => renderResult.errors.should.beEmpty(),
      () => renderResult.text.should.be('3'),
      () => objects.should.haveCount(3),
    ]);
  });

  test('Removing a value from a set', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText(
      '{{objects=Set(3, true, "Hello")}}'
      '{{objects.remove(true)}}'
      '{{objects}}',
    );

    var renderResult = await engine.render(parseResult);
    var objects = renderResult.variables['objects']! as Set;

    Should.satisfyAllConditions([
      () => renderResult.errors.should.beEmpty(),
      () => objects.should.haveCount(2),
      () => objects.contains(3).should.be(true),
      () => objects.contains('Hello').should.be(true),
      () => objects.contains(true).should.be(false),
    ]);
  });

  test('{{Set(}} should return a correct error message', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{Set(}}');
    var renderResult = await engine.render(parseResult);

    Should.satisfyAllConditions([
      () => parseResult.document.nodes.first.should.beOfType<ErrorNode>(),
      () => parseResult.errors.should.haveCount(1),
      () => parseResult.errors.first.message.should.be(
        "Unable to parse expression block: Missing closing parenthesis `)` in Set constructor",
      ),
      () => parseResult.errors.first.location.should.be(TemplateLocation(1, 7)),
      () => renderResult.text.should.be(''),
    ]);
  });

  test('{{Set(1, true "Hello")}} should result in an error', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{Set(1, true "Hello")}}');
    var renderResult = await engine.render(parseResult);

    Should.satisfyAllConditions([
      () => parseResult.document.nodes.first.should.beOfType<ErrorNode>(),
      () => parseResult.errors.should.haveCount(1),
      () => parseResult.errors.first.message.should.be(
        'Unable to parse expression block: Expected `,` or `)` in Set constructor',
      ),
      () =>
          renderResult.errors.first.location.should.be(TemplateLocation(1, 15)),
      () => renderResult.text.should.be(''),
    ]);
  });

  test('{{Set(1, true, "Hello )}} should result in an error', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{Set(1, true, "Hello )}}');
    var renderResult = await engine.render(parseResult);

    Should.satisfyAllConditions([
      () => parseResult.document.nodes.first.should.beOfType<ErrorNode>(),
      () => parseResult.errors.should.haveCount(1),
      () => parseResult.errors.first.message.should.be(
        'Unable to parse expression block: Unsupported `"Hello )` in expression',
      ),
      () =>
          renderResult.errors.first.location.should.be(TemplateLocation(1, 24)),
      () => renderResult.text.should.be(''),
    ]);
  });

  test('{{Set}} should return a correct error message', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{Set}}');

    Should.satisfyAllConditions([
      () => parseResult.errors.should.haveCount(1),
      () => parseResult.errors.first.message.should.be(
        'Unable to parse expression block: Unexpected reserved keyword `set`',
      ),
      () => parseResult.errors.first.location.should.be(TemplateLocation(1, 3)),
    ]);
  });
}
