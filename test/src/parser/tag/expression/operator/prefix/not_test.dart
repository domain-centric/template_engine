import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{!FALSE}} should render: true', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(const TextTemplate("{{!FALSE}}"));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('true');
  });

  test('{{  !  true  }} should render: false', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(const TextTemplate("{{  !  true  }}"));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('false');
  });

  test('{{false | !FAlse}} should render: true', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(const TextTemplate("{{false | !FAlse}}"));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('true');
  });

  test('{{!"text"}} should throw in an error', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(const TextTemplate('{{!"text"}}'));
    Should.throwException<RenderException>(() => engine.render(parseResult))!
        .error
        .message
        .should
        .be('boolean expected after the ! operator');
  });
}
