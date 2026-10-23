import 'package:template_engine/template_engine.dart';
import 'package:shouldly/shouldly.dart';
import 'package:test/test.dart';

void main() {
  group('ForEachStatement', () {
    test('iterates over an iterable collection', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText(
        '{{ for each item in items }}{{ item }}{{ next item }}',
      );

      final renderResult = await engine.render(
        parseResult,
        variables: {
          'items': ['A', 'B', 'C'],
        },
      );
      Should.satisfyAllConditions([
        () => renderResult.text.should.be('ABC'),
        () => parseResult.errors.should.beEmpty(),
      ]);
    });

    test('cleans up loop variable after rendering', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText(
        '{{ for each item in items }}{{ item }}{{ next item }}',
      );

      final renderResult = await engine.render(
        parseResult,
        variables: {
          'items': [1, 2],
        },
      );
      Should.satisfyAllConditions([
        () => renderResult.text.should.be('12'),
        () => renderResult.variables.containsKey('item').should.be(false),
      ]);
    });
  });
}
