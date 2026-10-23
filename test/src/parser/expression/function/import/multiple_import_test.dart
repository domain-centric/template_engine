import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Multiple imports of the same file, should only parse it once',
    () async {
      var engine = TemplateEngine();
      var path =
          'test/src/parser/expression/function/import/to_import.md.template';
      var input =
          "{{importTemplate('$path')}}\n"
          "{{importTemplate('$path')}}\n"
          "Hello World.\n"
          "{{importTemplate('$path')}}";
      var parseResult = await engine.parseText(input);
      var renderResult = await engine.render(parseResult);
      renderResult.errors.should.beEmpty();
      renderResult.text.should.be(
        'Line to import.\n'
        'Line to import.\n'
        'Hello World.\n'
        'Line to import.',
      );
    },
  );
}
