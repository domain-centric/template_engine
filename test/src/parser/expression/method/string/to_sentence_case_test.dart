import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test(
    "{{\"hello_world\".toSentenceCase()}} should render: Hello world",
    () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText(
        '{{"hello_world".toSentenceCase()}}',
      );
      var renderResult = await engine.render(parseResult);
      renderResult.text.should.be('Hello world');
    },
  );
}
