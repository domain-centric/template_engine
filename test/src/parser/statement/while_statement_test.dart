import 'package:template_engine/template_engine.dart';
import 'package:shouldly/shouldly.dart';
import 'package:test/test.dart';

void main() {
  group('WhileStatement', () {
    test('runs while condition is true', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText(
        '{{ count = 0 }}{{ while count < 3 do }}{{ count = count + 1 }}{{ endwhile }}',
      );

      final renderResult = await engine.render(parseResult);
      renderResult.text.should.be('');
      (renderResult.variables['count'] as int).should.be(3);
      parseResult.errors.should.beEmpty();
    });

    test('supports body rendering during loop', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText(
        '{{ count = 0 }}{{ while count < 3 do }}{{ count = count + 1 }}{{ count }}{{ endwhile }}',
      );

      final renderResult = await engine.render(parseResult);
      renderResult.text.should.be('123');
      (renderResult.variables['count'] as int).should.be(3);
      parseResult.errors.should.beEmpty();
    });

    test('does not loop when condition is false initially', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText(
        '{{ count = 5 }}{{ while count < 3 do }}{{ count = count + 1 }}{{ endwhile }}',
      );

      final renderResult = await engine.render(parseResult);
      renderResult.text.should.be('');
      (renderResult.variables['count'] as int).should.be(5);
      parseResult.errors.should.beEmpty();
    });

    test('missing endwhile reports parse error', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText('{{ while true do }}');
      parseResult.errors.should.haveCount(1);
      parseResult.errors.first.message.should.be(
        'Expected `endwhile` before end of template',
      );
    });
  });
}
