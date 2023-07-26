import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test("{{'Hello}} should return a correct error message", () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(const TextTemplate("{{'Hello}}"));
    parseResult.errorMessage.should
        .be('Parse Error: invalid tag syntax, position: 1:3, source: Text');
  });

  test('{{Hello"}} should return a correct error message', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(const TextTemplate('{{Hello"}}'));
    parseResult.errorMessage.should
        .be('Parse Error: invalid tag syntax, position: 1:8, source: Text');
  });

  test("{{'Hello'}} should render: 'Hello'", () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(const TextTemplate("{{'Hello'}}"));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('Hello');
  });

  test('{{"Hello"}} should render: \'Hello\'', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(const TextTemplate('{{"Hello"}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('Hello');
  });

  test("{{'Hello'   }} should render: 'Hello'", () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(const TextTemplate("{{'Hello'   }}"));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('Hello');
  });

  test('{{   "Hello"}} should render: \'Hello\'', () {
    var engine = TemplateEngine();
    var parseResult = engine.parse(const TextTemplate('{{   "Hello"}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('Hello');
  });

  test('{{\'Hel\' + \'l\' & "o"}} should render: \'Hello\'', () {
    var engine = TemplateEngine();
    var parseResult =
        engine.parse(const TextTemplate('{{\'Hel\' + \'l\' & "o"}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('Hello');
  });
}
