import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test(
    "{{\"hello_world\".toTitleCase()}} should render: Hello World",
    () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText(
        '{{"hello_world".toTitleCase()}}',
      );
      var renderResult = await engine.render(parseResult);
      renderResult.text.should.be('Hello World');
    },
  );
}
