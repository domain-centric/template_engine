import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test(
    "{{items.insert(-1,9)}}{{items}} should render: [3, null, apple]",
    () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText(
        "{{items.insert(-1,9)}}{{items}}",
      );
      var renderResult = await engine.render(
        parseResult,
        variables: {
          'items': [3, null, 'apple'],
        },
      );
      Should.satisfyAllConditions([
        () => renderResult.text.should.be('[3, null, apple]'),
        () => renderResult.errors.should.haveCount(1),
        () => renderResult.errors.first.message.should.be(
          'Index out of bounds: -1 (min:0 max:3)',
        ),
        () => renderResult.errors.first.location.should.be(
          TemplateLocation(1, 16),
        ),
      ]);
    },
  );

  test(
    "{{items.insert(0,9)}}{{items}} should render: [9, 3, null, apple]",
    () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText(
        "{{items.insert(0,9)}}{{items}}",
      );
      var renderResult = await engine.render(
        parseResult,
        variables: {
          'items': [3, null, 'apple'],
        },
      );
      renderResult.text.should.be('[9, 3, null, apple]');
    },
  );

  test(
    "{{items.insert(1,9)}}{{items}} should render: [3, 9, null, apple]",
    () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText(
        "{{items.insert(1,9)}}{{items}}",
      );
      var renderResult = await engine.render(
        parseResult,
        variables: {
          'items': [3, null, 'apple'],
        },
      );
      renderResult.text.should.be('[3, 9, null, apple]');
    },
  );

  test(
    "{{items.insert(2,9)}}{{items}} should render: [3, null, 9, apple]",
    () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText(
        "{{items.insert(2,9)}}{{items}}",
      );
      var renderResult = await engine.render(
        parseResult,
        variables: {
          'items': [3, null, 'apple'],
        },
      );
      renderResult.text.should.be('[3, null, 9, apple]');
    },
  );

  test(
    "{{items.insert(3,9)}}{{items}} should render: [3, null, apple, 9]",
    () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText(
        "{{items.insert(3,9)}}{{items}}",
      );
      var renderResult = await engine.render(
        parseResult,
        variables: {
          'items': [3, null, 'apple'],
        },
      );
      renderResult.text.should.be('[3, null, apple, 9]');
    },
  );

  test(
    "{{items.insert(4,9)}}{{items}} should render: [3, null, apple]",
    () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText(
        "{{items.insert(4,9)}}{{items}}",
      );
      var renderResult = await engine.render(
        parseResult,
        variables: {
          'items': [3, null, 'apple'],
        },
      );
      Should.satisfyAllConditions([
        () => renderResult.text.should.be('[3, null, apple]'),
        () => renderResult.errors.should.haveCount(1),
        () => renderResult.errors.first.message.should.be(
          'Index out of bounds: 4 (min:0 max:3)',
        ),
        () => renderResult.errors.first.location.should.be(
          TemplateLocation(1, 16),
        ),
      ]);
    },
  );
}
