// ignore_for_file: avoid_print

import 'package:template_engine/template_engine.dart';

void main() {
  var template = TextTemplate('Hello {{name}}.');
  // See also FileTemplate and WebTemplate
  var engine = TemplateEngine(variables: {'name': 'world'});
  var model = engine.parse(template);
  // Here you could additionally mutate or validate the model if needed.
  print(engine.render(model)); // should print 'Hello world.';
}
