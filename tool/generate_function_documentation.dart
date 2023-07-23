import 'package:template_engine/template_engine.dart';

void main(List<String> args) {
  var engine = TemplateEngine();
  var parseResult =
      engine.parse(const TextTemplate('{{engine.function.documentation()}}'));
  var renderResult = engine.render(parseResult);
  // ignore: avoid_print
  print(renderResult.text);
}
