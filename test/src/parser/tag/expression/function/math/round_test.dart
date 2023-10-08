import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{round(4.5)}} should render as: 5', () {
    var engine = TemplateEngine();
    var parseResult = engine.parseTemplate(TextTemplate('{{round(4.5)}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('5');
  });
}
