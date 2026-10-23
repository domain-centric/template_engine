import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('The importPure function should import a file as is', () async {
    var engine = TemplateEngine();
    var filePath = 'test/src/template_engine_template_example_test.dart';
    var input = "{{importPure('$filePath')}}";
    var parseResult = await engine.parseText(input);
    var renderResult = await engine.render(parseResult);
    var expected = await readFromFilePath(filePath);
    Should.satisfyAllConditions([
      () => renderResult.errors.should.beEmpty(),
      () => renderResult.text.should.be(expected),
    ]);
  });

  test('test importPure with none existing file', () async {
    var engine = TemplateEngine();
    var input = "{{importPure('none_existent.dart')}}";
    var parseResult = await engine.parseText(input);
    var renderResult = await engine.render(parseResult);
    Should.satisfyAllConditions([
      () => renderResult.text.should.be('{{ERROR}}'),
      () => renderResult.errors.should.haveCount(1),
      () => renderResult.errors.first.message.should.contain(
        "Error importing a pure file: Error reading: "
        "none_existent.dart, PathNotFoundException: Cannot open file, "
        "path = 'none_existent.dart'",
      ),
      () =>
          renderResult.errors.first.location.should.be(TemplateLocation(1, 3)),
    ]);
  });
}
