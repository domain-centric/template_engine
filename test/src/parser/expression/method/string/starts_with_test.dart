import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test("{{'Hello world'.startsWith('Hello')}} should render: 'true'", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText(
      "{{'Hello world'.startsWith('Hello')}}",
    );
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be("true");
  });

  test(
    "{{'Hello world'.startsWith('world', 6)}} should render: 'true'",
    () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText(
        "{{'Hello world'.startsWith('world', 6)}}",
      );
      var renderResult = await engine.render(parseResult);
      renderResult.text.should.be("true");
    },
  );
}
