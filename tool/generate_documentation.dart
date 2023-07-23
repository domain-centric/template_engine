import 'package:template_engine/template_engine.dart';

const documentation = [
  '\n# Tags',
  '{{engine.tag.documentation(2)}}'
      '\n# Base types in tag expressions',
  '{{engine.baseType.documentation(2)}}'
      '\n# Functions in tag expressions',
  '{{engine.function.documentation(2)}}'
];

void main(List<String> args) {
  var engine = TemplateEngine();
  var parseResult = engine.parse(TextTemplate(documentation.join('\n')));
  var renderResult = engine.render(parseResult);
  // ignore: avoid_print
  print(renderResult.text);
}
