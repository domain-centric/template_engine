import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test(
    "{{'Hello Word'.split(' ')}} should render: '['Hello', 'World']'",
    () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText("{{'Hello World'.split(' ')}}");
      var renderResult = await engine.render(parseResult);
      renderResult.text.should.be("[Hello, World]");
    },
  );

  test(
    "{{'Hello Word'.split('')}} should render: '['H','e', 'l', 'l', 'o', ' ', 'W', 'o', 'r', 'l', 'd']'",
    () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText("{{'Hello World'.split('')}}");
      var renderResult = await engine.render(parseResult);
      renderResult.text.should.be("[H, e, l, l, o,  , W, o, r, l, d]");
    },
  );
}
