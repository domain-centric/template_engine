import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{!FALSE}} should render: true', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{!FALSE}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('true');
  });

  test('{{  !  true  }} should render: false', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{  !  true  }}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('false');
  });

  test('{{false | !FAlse}} should render: true', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{false | !FAlse}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('true');
  });

  test('{{!"text"}} should throw in an error', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{!"text"}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('{{ERROR}}');
    renderResult.errorMessage.should.be('Render error in: \'{{!"text"}}\':\n'
        '  1:3: boolean expected after the ! operator');
  });
}
