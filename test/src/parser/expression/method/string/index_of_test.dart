import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test("{{'Hello world'.indexOf('l')}} should render: '2'", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{'Hello world'.indexOf('l')}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be("2");
  });

  test("{{'Hello world'.indexOf('l', 4)}} should render: '9'", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText(
      "{{'Hello world'.indexOf('l', 4)}}",
    );
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be("9");
  });
}
