import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  var engine = TemplateEngine();

  // string

  var template = const TextTemplate('{{"Hello"}}');
  var parseResult = engine.parse(template);
  var renderResult = engine.render(parseResult);
  renderResult.text.should.be('Hello');

  template = const TextTemplate("{{'world'}}");
  parseResult = engine.parse(template);
  renderResult = engine.render(parseResult);
  renderResult.text.should.be('world');

  // numbers

  template = const TextTemplate('{{3.14159265359}}');
  parseResult = engine.parse(template);
  renderResult = engine.render(parseResult);
  renderResult.text.should.be('3.14159265359');

  template = const TextTemplate('{{-3.4e-1}}');
  parseResult = engine.parse(template);
  renderResult = engine.render(parseResult);
  renderResult.text.should.be('-0.34');

  // boolean

  template = const TextTemplate('{{true}}');
  parseResult = engine.parse(template);
  renderResult = engine.render(parseResult);
  renderResult.text.should.be('true');

  template = const TextTemplate('{{faLSe}}');
  parseResult = engine.parse(template);
  renderResult = engine.render(parseResult);
  renderResult.text.should.be('false');
}
