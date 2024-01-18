import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('Variable "east" to be found and not taken hostage by constant "e"',
      () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{east}}');
    parseResult.errorMessage.should.beBlank();
    var renderResult = await engine
        .render(parseResult, {'east': 'Direction of where the sun rises.'});
    renderResult.text.should.be('Direction of where the sun rises.');
  });
}
