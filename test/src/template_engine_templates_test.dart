import 'package:test/test.dart';
import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  group('TemplateEngine', () {
    final engine = TemplateEngine();

    test(
      'should render correctly using FileTemplate and TextTemplate',
      () async {
        final parseResult = await engine.parseTemplates([
          FileTemplate.fromProjectFilePath(
            ProjectFilePath('test/src/hello.template'),
          ),
          TextTemplate('{{name}}.'),
        ]);
        final renderResult = await engine.render(parseResult, {
          'name': 'world',
        });

        Should.satisfyAllConditions([
          () => renderResult.errorMessage.should.beNullOrEmpty(),
          () => renderResult.text.should.be('Hello world.'),
        ]);
      },
    );
  });
}
