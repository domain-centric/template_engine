import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test(
    "{{\"Hello world\".toConstantCase()}} should render: HELLO_WORLD",
    () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText(
        '{{"Hello world".toConstantCase()}}',
      );
      var renderResult = await engine.render(parseResult);
      renderResult.text.should.be('HELLO_WORLD');
    },
  );
}
