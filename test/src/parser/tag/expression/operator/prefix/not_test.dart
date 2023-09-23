import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{!FALSE}} should render: true', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(TextTemplate("{{!FALSE}}"));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('true');
  });

  test('{{  !  true  }} should render: false', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(TextTemplate("{{  !  true  }}"));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('false');
  });

  test('{{false | !FAlse}} should render: true', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(TextTemplate("{{false | !FAlse}}"));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('true');
  });

  test('{{!"text"}} should throw in an error', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(TextTemplate('{{!"text"}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('{{ERROR}}');
    renderResult.errorMessage.should
        .be(
          'Render error in: \'{{!"text"}}\':\n'
          '  1:3: boolean expected after the ! operator');
  });
}
