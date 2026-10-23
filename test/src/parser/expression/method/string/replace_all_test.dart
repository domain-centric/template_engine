import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test(
    "{{'Hello !'.replaceAll('!', 'universe')}} should render: 'Hello universe'",
    () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText(
        "{{'Hello !'.replaceAll('!', 'universe')}}",
      );
      var renderResult = await engine.render(parseResult);
      renderResult.text.should.be("Hello universe");
    },
  );

  test(
    "{{'Hello ??'.replaceAll('?','!')}} should render: 'Hello !!'",
    () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText(
        "{{'Hello ??'.replaceAll('?','!')}}",
      );
      var renderResult = await engine.render(parseResult);
      renderResult.text.should.be("Hello !!");
    },
  );
}
