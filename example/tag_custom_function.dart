// ignore_for_file: avoid_print

import 'package:template_engine/template_engine.dart';

void main() {
  var template = const TextTemplate('{{greeting()}}.');
  var engine = TemplateEngine();
  engine.functionGroups.add(FunctionGroup('Greeting', [Greeting()]));
  var parseResult = engine.parse(template);
  print(engine.render(parseResult)); // should print 'Hello world.';
}

class Greeting extends ExpressionFunction<String> {
  Greeting()
      : super(
          name: 'greeting',
          function: (renderContext, parameters) => 'Hello world',
        );
}
