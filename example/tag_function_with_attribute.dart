// ignore_for_file: avoid_print

import 'package:template_engine/template_engine.dart';

void main() {
  var template = TextTemplate('{{greeting name="world"}}.');
  // See also FileTemplate and WebTemplate
  var engine = TemplateEngine(tags: [GreetingTag()]);
  var parseResult = engine.parse(template);
  // Here you could additionally mutate or validate the parseResult if needed.
  print(engine.render(parseResult)); // should print 'Hello world.';
}

class GreetingTag extends TagFunction<String> {
  GreetingTag()
      : super(
          name: 'greeting',
          description: 'A tag that shows a greeting using attribute: name',
        );

  @override
  String createParserResult(TemplateSource source, String attributes) =>
      'Hello $attributes';
}
