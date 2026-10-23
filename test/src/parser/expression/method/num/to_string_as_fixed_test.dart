import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

/// ;  //
/// ;  //
/// 10000000000000000.toStringAsFixed(4); // 10000000000000000.0000
/// 5.25.toStringAsFixed(0); // 5

void main() {
  test("{{1.toStringAsFixed(3)}} should render: 1.000", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{1.toStringAsFixed(3)}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('1.000');
  });

  test(
    "{{(4321.12345678).toStringAsFixed(3)}} should render: 4321.123",
    () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText(
        "{{(4321.12345678).toStringAsFixed(3)}}",
      );
      var renderResult = await engine.render(parseResult);
      renderResult.text.should.be('4321.123');
    },
  );

  test(
    "{{(4321.12345678).toStringAsFixed(5)}} should render: 4321.12346",
    () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText(
        "{{(4321.12345678).toStringAsFixed(5)}}",
      );
      var renderResult = await engine.render(parseResult);
      renderResult.text.should.be('4321.12346');
    },
  );

  test(
    "{{123456789012345.toStringAsFixed(3)}} should render: 123456789012345.000",
    () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText(
        "{{123456789012345.toStringAsFixed(3)}}",
      );
      var renderResult = await engine.render(parseResult);
      renderResult.text.should.be('123456789012345.000');
    },
  );

  test(
    "{{10000000000000000.toStringAsFixed(4)}} should render: 10000000000000000.0000",
    () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText(
        "{{10000000000000000.toStringAsFixed(4)}}",
      );
      var renderResult = await engine.render(parseResult);
      renderResult.text.should.be('10000000000000000.0000');
    },
  );

  test("{{5.25.toStringAsFixed(0)}} should render: 5", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{5.25.toStringAsFixed(0)}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('5');
  });

  test("{{5.25.toStringAsFixed(-2)}} should render: 5 with an error", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{5.25.toStringAsFixed(-2)}}");
    var renderResult = await engine.render(parseResult);
    Should.satisfyAllConditions([
      () => renderResult.text.should.be('5'),
      () => renderResult.errors.should.haveCount(1),
      () => renderResult.errors.first.message.should.be(
        'Parameter fractionDigits must be >=0',
      ),
      () =>
          renderResult.errors.first.location.should.be(TemplateLocation(1, 24)),
    ]);
  });

  test("{{5.25.toStringAsFixed(2.5)}} should render: 5 with an error", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{5.25.toStringAsFixed(2.5)}}");
    var renderResult = await engine.render(parseResult);
    Should.satisfyAllConditions([
      () => renderResult.text.should.be('{{ERROR}}'),
      () => renderResult.errors.should.haveCount(1),
      () => renderResult.errors.first.message.should.be(
        'Argument for parameter `fractionDigits` must be type int but was double',
      ),
      () =>
          renderResult.errors.first.location.should.be(TemplateLocation(1, 24)),
    ]);
  });
}
