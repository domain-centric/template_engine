import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test("{{'Hello}} should return a correct error message", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{'Hello}}");
    parseResult.errorMessage.should.be('Parse error in: \'{{\'Hello}}\':\n'
        '  1:3: invalid tag syntax');
  });

  test('{{Hello"}} should return a correct error message', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{Hello"}}');
    parseResult.errorMessage.should.be('Parse error in: \'{{Hello"}}\':\n'
        '  1:3: invalid tag syntax');
  });

  test("{{'Hello'}} should render: 'Hello'", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{'Hello'}}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('Hello');
  });

  test('{{"Hello"}} should render: \'Hello\'', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{"Hello"}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('Hello');
  });

  test("{{'Hello'   }} should render: 'Hello'", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{'Hello'   }}");
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('Hello');
  });

  test('{{   "Hello"}} should render: \'Hello\'', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{   "Hello"}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('Hello');
  });

  test('{{\'Hel\' + \'l\' & "o"}} should render: \'Hello\'', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{\'Hel\' + \'l\' & "o"}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('Hello');
  });
}
