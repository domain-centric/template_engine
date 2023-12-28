import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{length(\'Hello\'}} should render: 5', () async {
    var engine = TemplateEngine();
    var parseResult =
        engine.parseTemplate(TextTemplate('{{length(\'Hello\')}}'));
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('5');
  });

  test('{{length(\'Hello\' + " world"}} should render: 5', () async {
    var engine = TemplateEngine();
    var parseResult =
        engine.parseTemplate(TextTemplate('{{length(\'Hello\' + " world")}}'));
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('11');
  });
}
