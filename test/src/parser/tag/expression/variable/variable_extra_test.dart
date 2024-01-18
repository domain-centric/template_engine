import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

/// Variable tests that are not suited as an example

void main() {
  test(
      '"Hello {{name}}." should render a an error '
      'if the variable does not exist', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('Hello {{name}}.');
    var renderResult = await engine.render(parseResult);
    renderResult.errorMessage.should
        .be('Render error in: \'Hello {{name}}.\':\n'
            '  1:9: Variable does not exist: name');
  });

  test('"Hello {{  \t name}}." should render a proper greeting', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('Hello {{  \t name}}.');
    var renderResult = await engine.render(parseResult, {'name': 'world'});
    renderResult.text.should.be('Hello world.');
  });

  test('"Hello {{name  \t\n }}." should render a proper greeting', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('Hello {{name  \t\n }}.');
    var renderResult = await engine.render(parseResult, {'name': 'world'});
    renderResult.text.should.be('Hello world.');
  });

  test('"Hello {{   name  \t\n }}." should render a proper greeting', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('Hello {{   name  \t\n }}.');
    var renderResult = await engine.render(parseResult, {'name': 'world'});
    renderResult.text.should.be('Hello world.');
  });
}
