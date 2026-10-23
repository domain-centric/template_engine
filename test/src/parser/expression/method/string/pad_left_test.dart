import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test("{{'Hello'.padLeft(3)}} should render: 'Hello'", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{'Hello'.padLeft(3)}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('Hello');
  });

  test("{{'Hello'.padLeft(7)}} should render: '  Hello'", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{'Hello'.padLeft(7)}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('  Hello');
  });

  test("{{'Hello'.padLeft(7,'-')}} should render: '---Hello'", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{'Hello'.padLeft(8,'-')}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('---Hello');
  });
}
