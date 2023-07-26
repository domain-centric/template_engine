import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  var template = const TextTemplate('Hello {{name}}.');
  // See also FileTemplate and WebTemplate
  var engine = TemplateEngine();
  var parseResult = engine.parse(template);
  // Here you could additionally mutate or validate the parseResult if needed.
  var renderResult = engine.render(parseResult, {'name': 'world'});
  renderResult.text.should.be('Hello world.');
}
