import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test("{{'Hello}} should return a correct error message", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{'Hello}}");
    parseResult.errors.should.haveCount(1);
    parseResult.errors.first.message.should.be(
      'Unable to parse expression block: Unsupported `\'Hello` in expression',
    );
    parseResult.errors.first.location.should.be(TemplateLocation(1, 9));
  });

  test('{{Hello"}} should return a correct error message', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{Hello"}}');
    parseResult.errors.should.haveCount(1);
    parseResult.errors.first.message.should.be('Unexpected `"`');
    parseResult.errors.first.location.should.be(TemplateLocation(1, 8));
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
