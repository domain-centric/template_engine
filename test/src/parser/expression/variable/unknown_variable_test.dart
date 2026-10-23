import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

Future<void> main() async {
  test('Unknown variable should produce an error', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('Hello {{world}}.');
    var renderResult = await engine.render(parseResult);
    Should.satisfyAllConditions([
      () => renderResult.text.should.be('Hello {{ERROR}}.'),
      () => renderResult.errors.should.haveCount(1),
      () => renderResult.errors.first.message.should.be(
        'Variable `world` does not exist',
      ),
      () =>
          renderResult.errors.first.location.should.be(TemplateLocation(1, 9)),
    ]);
  });
}
