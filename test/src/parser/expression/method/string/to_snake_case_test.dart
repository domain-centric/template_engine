import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test(
    "{{\"Hello World\".toSnakeCase()}} should render: hello_world",
    () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText(
        '{{"Hello World".toSnakeCase()}}',
      );
      var renderResult = await engine.render(parseResult);
      renderResult.text.should.be('hello_world');
    },
  );
}
