// ignore_for_file: avoid_print

import 'package:template_engine/template_engine.dart';

void main() {
  var engine = TemplateEngine(tags: [GreetingTag()]);
  var parseResult = engine.parse(TextTemplate('{{greeting}}.'));
  print(engine.render(parseResult)); // should print 'Hello world.';
  parseResult = engine.parse(TextTemplate('{{greeting name="Jane Doe"}}.'));
  print(engine.render(parseResult)); // should print 'Hello Jane Doe.';
}

class GreetingTag extends TagFunction<String> {
  GreetingTag()
      : super(
            name: 'greeting',
            description: 'A tag that shows a greeting using attribute: name',
            attributeDefinitions: [
              Attribute<String>(
                  name: 'name', optional: true, defaultValue: 'world')
            ]);

  @override
  String createParserResult(
          TemplateSource source, Map<String, Object> attributes) =>
      'Hello ${attributes['name']}';
}
