import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

/// Variable tests that are not suited as an example

void main() {
  test(
      '"Hello {{name}}." should render a an error '
      'if the variable does not exist', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(const TextTemplate('Hello {{name}}.'));
    var renderResult = engine.render(parseResult);
    renderResult.errorMessage.should
        .be('Render Error: Variable does not exist: name,'
            ' position: 1:9, source: Text');
  });

  test('"Hello {{  \t name}}." should render a proper greeting', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(const TextTemplate('Hello {{  \t name}}.'));
    var renderResult = engine.render(parseResult, {'name': 'world'});
    renderResult.text.should.be('Hello world.');
  });

  test('"Hello {{name  \t\n }}." should render a proper greeting', () {
    var engine = TemplateEngine();
    var parseResult =
        engine.parse(const TextTemplate('Hello {{name  \t\n }}.'));
    var renderResult = engine.render(parseResult, {'name': 'world'});
    renderResult.text.should.be('Hello world.');
  });

  test('"Hello {{   name  \t\n }}." should render a proper greeting', () {
    var engine = TemplateEngine();
    var parseResult =
        engine.parse(const TextTemplate('Hello {{   name  \t\n }}.'));
    var renderResult = engine.render(parseResult, {'name': 'world'});
    renderResult.text.should.be('Hello world.');
  });
}
