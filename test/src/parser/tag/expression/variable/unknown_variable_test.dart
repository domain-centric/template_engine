import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';

Future<void> main() async {
  var template = TextTemplate('Hello {{world}}.');
  var engine = TemplateEngine();

  var parseResult = engine.parseTemplate(template);
  var renderResult = await engine.render(parseResult);
  var expected = "Render error in: 'Hello {{world}}.':\n"
      "  1:9: Variable does not exist: world";
  renderResult.errorMessage.should.be(expected);
}
