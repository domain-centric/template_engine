// ignore_for_file: avoid_print

import 'package:template_engine/template_engine.dart';

void main() {
  var template = TextTemplate('{{greeting()}}.');
  var functions = DefaultFunctions();
  functions.add(Greeting());
  var engine = TemplateEngine(tags: DefaultTags(functions: functions));
  var parseResult = engine.parse(template);
  print(engine.render(parseResult)); // should print 'Hello world.';
}

class Greeting extends TagFunction<String> {
  Greeting()
      : super(
          name: 'greeting',
          function: (_) => 'Hello world',
        );
}
