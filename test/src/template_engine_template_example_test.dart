import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  var engine = TemplateEngine();
  var parseResult = engine.parseTemplate(TextTemplate('Hello {{name}}.'));
  var renderResult = engine.render(parseResult, {'name': 'world'});
  renderResult.text.should.be('Hello world.');
}
