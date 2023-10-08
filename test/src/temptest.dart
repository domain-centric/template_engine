import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  var template = TextTemplate('Hello {{world}}.');
  var engine = TemplateEngine();

  var result = engine.parseTemplate(template);

  var expected = 'Parse Error: Unknown tag or variable. '
      'position: 1:7 source: Text';
  result.errorMessage.should.be(expected);
}
