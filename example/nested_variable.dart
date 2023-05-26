// ignore_for_file: avoid_print

import 'package:template_engine/template_engine.dart';

void main() {
  var template = TextTemplate('Hello {{person.child.name}}.');
  var variables = {
    'person': {
      'name': 'John Doe',
      'age': 30,
      'child': {
        'name': 'Jane Doe',
        'age': 5,
      }
    }
  };
  var engine = TemplateEngine(variables: variables);
  var model = engine.parse(template);
  // Here you could additionally mutate or validate the model if needed.
  print(engine.render(model)); // should print 'Hello Jane Doe.';
}
