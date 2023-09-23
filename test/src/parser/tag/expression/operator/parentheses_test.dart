import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{1 + 3 * 2}} should render: 7', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(TextTemplate("{{1 + 3 * 2}}"));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('7');
  });

  test('{{(1 + 3) * 2}} should render: 8', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(TextTemplate("{{(1 + 3) * 2}}"));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('8');
  });

  test('{{true & (false | true)}} should render: true', () {
    var engine = TemplateEngine();
    var parseResult =
        engine.parse(TextTemplate("{{true & (false | true)}}"));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('true');
  });
}
