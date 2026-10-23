import 'package:test/test.dart';
import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  group('TemplateEngine', () {
    final engine = TemplateEngine();

    test('should render correctly with valid input', () async {
      final parseResult = await engine.parseText('Hello {{name}}.');
      final renderResult = await engine.render(
        parseResult,
        variables: {'name': 'world'},
      );

      Should.satisfyAllConditions([
        () => renderResult.aggregatedErrorMessage.should.beNullOrEmpty(),
        () => renderResult.text.should.be('Hello world.'),
      ]);
    });
  });
}
