import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test(
    "{{\"hello world\".toPascalCase()}} should render: HelloWorld",
    () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText(
        '{{"hello world".toPascalCase()}}',
      );
      var renderResult = await engine.render(parseResult);
      renderResult.text.should.be('HelloWorld');
    },
  );
}
