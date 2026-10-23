import 'package:template_engine/template_engine.dart';
import 'package:shouldly/shouldly.dart';
import 'package:test/test.dart';

void main() {
  group('ForStatement', () {
    test('basic numeric loop', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText(
        '{{ for i = 1 to 3 }}{{ i }}{{ next i }}',
      );

      final renderResult = await engine.render(parseResult);
      Should.satisfyAllConditions([
        () => renderResult.text.should.be('123'),
        () => parseResult.errors.should.beEmpty(),
      ]);
    });

    test('loop variable not leaked after renderResult', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText(
        '{{ for i = 1 to 2 }}{{ i }}{{ next i }}',
      );

      final renderResult = await engine.render(parseResult);
      Should.satisfyAllConditions([
        () => renderResult.text.should.be('12'),
        () => renderResult.variables.containsKey('i').should.be(false),
      ]);
    });

    test('empty loop when start > end', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText(
        '{{ for i = 5 to 2 }}{{ i }}{{ next i }}',
      );
      final renderResult = await engine.render(parseResult);
      Should.satisfyAllConditions([
        () => renderResult.text.should.be('5432'),
        () => parseResult.errors.should.beEmpty(),
      ]);
    });

    test('mismatched next name reports parse error', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText(
        '{{ for i = 1 to 2 }}{{ i }}{{ next j }}',
      );
      final renderResult = await engine.render(parseResult);
      // parsing should record an error about mismatched variable
      Should.satisfyAllConditions([
        () => renderResult.errors.should.haveCount(1),
        () => renderResult.errors.first.message.should.be(
          'Mismatched loop variable in next: expected `i`',
        ),
        () => renderResult.text.should.be('12'),
      ]);
    });
  });
}
