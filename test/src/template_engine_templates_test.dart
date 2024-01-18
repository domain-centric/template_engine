import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  given('TemplateEngine', () {
    var engine = TemplateEngine();
    when("calling: engine.parseTemplates();", () {
      var path = ProjectFilePath('test/src/hello.template');

      then('renderResult.errorMessage should be empty', () async {
        var parseResult = await engine.parseTemplates([
          FileTemplate.fromProjectFilePath(path),
          TextTemplate('{{name}}.')
        ]);
        var renderResult = await engine.render(parseResult, {'name': 'world'});
        renderResult.errorMessage.should.beNullOrEmpty();
      });
      var expected = 'Hello world.';
      then('renderResult.text should be "$expected"', () async {
        var parseResult = await engine.parseTemplates([
          FileTemplate.fromProjectFilePath(path),
          TextTemplate('{{name}}.')
        ]);
        var renderResult = await engine.render(parseResult, {'name': 'world'});
        renderResult.text.should.be(expected);
      });
    });
  });
}
