import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test("{{'Hello world'.endsWith('world')}} should render: 'true'", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText(
      "{{'Hello world'.endsWith('world')}}",
    );
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be("true");
  });
}
