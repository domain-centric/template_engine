import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  var template = const TextTemplate('Hello {{person.child.name}}.');
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
  var engine = TemplateEngine();
  var parseResult = engine.parse(template);
  // Here you could additionally mutate or validate the parseResult if needed.
  var renderResult = engine.render(parseResult, variables);
  renderResult.text.should.be('Hello Jane Doe.');
}
