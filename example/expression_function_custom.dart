import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  var engine = TemplateEngine();
  engine.functionGroups.add(FunctionGroup('Greeting', [Greeting()]));

  var template = const TextTemplate('{{greeting()}}.');
  var parseResult = engine.parse(template);
  var renderResult = engine.render(parseResult);
  renderResult.text.should.be('Hello world.');
}

class Greeting extends ExpressionFunction<String> {
  Greeting()
      : super(
          name: 'greeting',
          function: (renderContext, parameters) => 'Hello world',
        );
}
