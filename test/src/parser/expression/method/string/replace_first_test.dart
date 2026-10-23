import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test(
    "{{'Hello world'.replaceFirst('world', 'universe')}} should render: 'Hello universe'",
    () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText(
        "{{'Hello world'.replaceFirst('world', 'universe')}}",
      );
      var renderResult = await engine.render(parseResult);
      renderResult.text.should.be("Hello universe");
    },
  );

  test("{{'Hello ! !'.replaceFirst('!','world')}} should render: ''", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText(
      "{{'Hello ! !'.replaceFirst('!','world')}}",
    );
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be("Hello world !");
  });
}
