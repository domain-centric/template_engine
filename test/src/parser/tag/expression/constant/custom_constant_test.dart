import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('Custom constant', () async {
    var engine = TemplateEngine();
    engine.constants.add(TemplateEngineUrl());
    var template = TextTemplate('{{templateEngineUrl}}');
    var parseResult = await engine.parseTemplate(template);
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('https://pub.dev/packages/template_engine');
  });
}

class TemplateEngineUrl extends Constant<String> {
  TemplateEngineUrl()
      : super(
            name: 'templateEngineUrl',
            description: 'A URL to the template_engine dart package on pub.dev',
            value: 'https://pub.dev/packages/template_engine');
}
