import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  var engine = TemplateEngine();
  engine.functionGroups.add(FunctionGroup('Greeting', [Greeting()]));

  var parseResult = engine.parse(const TextTemplate('{{greeting()}}.'));
  var renderResult = engine.render(parseResult);
  renderResult.text.should.be('Hello world.');

  parseResult = engine.parse(const TextTemplate('{{greeting("Jane Doe")}}.'));
  renderResult = engine.render(parseResult);
  renderResult.text.should.be('Hello Jane Doe.');
}

class Greeting extends ExpressionFunction {
  Greeting()
      : super(
          name: 'greeting',
          description: 'A tag that shows a greeting using parameter: name',
          parameters: [
            Parameter(
                name: 'name',
                presence: Presence.optionalWithDefaultValue('world'))
          ],
          function: (renderContext, parameters) =>
              'Hello ${parameters['name']}',
        );
}
