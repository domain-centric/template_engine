import 'package:test/test.dart';
import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  group('TemplateEngine', () {
    final engine = TemplateEngine();

    test(
      'should render correctly using FileTemplate and TextTemplate',
      () async {
        final parseResults = await engine.parseTemplates([
          FileTemplate.fromFilePath('test/src/hello.template'),
          TextTemplate('{{name}}.'),
        ]);
        final renderResults = await engine.renderAll(
          parseResults,
          variables: {'name': 'world'},
        );

        Should.satisfyAllConditions([
          () => renderResults
              .map((r) => r.aggregatedErrorMessage)
              .join()
              .should
              .beNullOrEmpty(),
          () =>
              renderResults.map((r) => r.text).join().should.be('Hello world.'),
        ]);
      },
    );
  });
}
