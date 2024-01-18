import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';

Future<void> main() async {
  var engine = TemplateEngine();
  var parseResult = await engine.parseText('Hello {{name}}.');
  var renderResult = await engine.render(parseResult, {'name': 'world'});
  renderResult.text.should.be('Hello world.');
}
