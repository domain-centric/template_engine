// ignore_for_file: avoid_print

import 'package:template_engine/template_engine.dart';

void main() {
  var engine = TemplateEngine();
  engine.functions.add(Greetings());
  var parseResult = engine.parse(TextTemplate('{{greeting()}}.'));
  print(engine.render(parseResult)); // should print 'Hello world.';
  parseResult = engine.parse(TextTemplate('{{greeting("Jane Doe")}}.'));
  print(engine.render(parseResult)); // should print 'Hello Jane Doe.';
}

class Greetings extends TagFunction {
  Greetings()
      : super(
          name: 'greeting',
          description: 'A tag that shows a greeting using parameter: name',
          parameters: [
            Parameter(
                name: 'name',
                presence: Presence.optionalWithDefaultValue('world'))
          ],
          function: (parameters) => 'Hello ${parameters['name']}',
        );
}
