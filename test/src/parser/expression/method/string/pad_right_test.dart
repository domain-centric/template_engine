import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test("{{'Hello'.padRight(3)}} should render: 'Hello'", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{'Hello'.padRight(3)}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('Hello');
  });

  test("{{'Hello'.padRight(7)}} should render: 'Hello  '", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{'Hello'.padRight(7)}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('Hello  ');
  });

  test("{{'Hello'.padRight(10,'-')}} should render: 'Hello-----'", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{'Hello'.padRight(10,'-')}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('Hello-----');
  });
}
