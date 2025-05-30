import 'package:template_engine/src/template.dart';
import 'package:template_engine/src/template_engine.dart';
import 'package:shouldly/shouldly.dart';
import 'package:test/test.dart';

void main() {
  test('"The cos of 2 pi = {{cos(2 * pi)}}." should render : 1', () async {
    var engine = TemplateEngine();
    var template = TextTemplate('The cos of 2 pi = {{cos(2 * pi)}}.');
    var parseResult = await engine.parseTemplate(template);
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('The cos of 2 pi = 1.0.');
  });

  test('"The volume of a sphere = '
      '{{ round( (3/4) * pi * (radius ^ 3) )}}." should render: '
      'The volume of a sphere = 2356.', () async {
    var engine = TemplateEngine();
    var template = TextTemplate(
      'The volume of a sphere = '
      '{{ round( (3/4) * pi * (radius ^ 3) )}}.',
    );
    var parseResult = await engine.parseTemplate(template);
    var renderResult = await engine.render(parseResult, {'radius': 10});
    renderResult.text.should.be('The volume of a sphere = 2356.');
  });
}
