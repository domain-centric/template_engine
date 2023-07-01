// ignore_for_file: avoid_print

import 'package:template_engine/template_engine.dart';

void main() {
  var engine = TemplateEngine();
  var functions = DefaultFunctions();
  functions.add(GreetingWithParameter());
  var parseResult =
      engine.parse(TextTemplate('{{greeting()}}.'), functions: functions);
  print(engine.render(parseResult)); // should print 'Hello world.';
  parseResult = engine.parse(TextTemplate('{{greeting("Jane Doe")}}.'),
      functions: functions);
  print(engine.render(parseResult)); // should print 'Hello Jane Doe.';
}

class GreetingWithParameter extends TagFunction {
  GreetingWithParameter()
      : super(
          name: 'greeting',
          description: 'A tag that shows a greeting using attribute: name',
          // attributeDefinitions: [
          //   Attribute<String>(
          //       name: 'name', optional: true, defaultValue: 'world')
          // ]);
          function: (parameters) => 'Hello ${parameters['name']}',
        );
}
