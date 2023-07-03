// ignore_for_file: avoid_print

import 'package:template_engine/template_engine.dart';

void main() {
  var functions = DefaultFunctions();
  functions.add(GreetingWithParameter());
  var engine = TemplateEngine(tags: DefaultTags(functions: functions));
  var parseResult = engine.parse(TextTemplate('{{greeting()}}.'));
  print(engine.render(parseResult)); // should print 'Hello world.';
  parseResult = engine.parse(TextTemplate('{{greeting("Jane Doe")}}.'));
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
