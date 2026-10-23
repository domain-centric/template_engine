import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test(
    "{{\"Hello World\".toParamCase()}} should render: hello-world",
    () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText(
        '{{"Hello World".toParamCase()}}',
      );
      var renderResult = await engine.render(parseResult);
      renderResult.text.should.be('hello-world');
    },
  );
}
