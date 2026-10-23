import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  group('test: true', () {
    test('{{true}} should be rendered as true', () async {
      var engine = TemplateEngine();
      var parserResult = await engine.parseText('{{true}}');
      var renderResult = await engine.render(parserResult);
      renderResult.text.should.be('true');
    });

    test('{{TRUE}} should be rendered as true', () async {
      var engine = TemplateEngine();
      var parserResult = await engine.parseText('{{TRUE}}');
      var renderResult = await engine.render(parserResult);
      renderResult.text.should.be('true');
    });

    test('{{   TRue}} should be rendered as true', () async {
      var engine = TemplateEngine();
      var parserResult = await engine.parseText('{{   TRue}}');
      var renderResult = await engine.render(parserResult);
      renderResult.text.should.be('true');
    });

    test('{{trUE  }} should be rendered as true', () async {
      var engine = TemplateEngine();
      var parserResult = await engine.parseText('{{trUE   }}');
      var renderResult = await engine.render(parserResult);
      renderResult.text.should.be('true');
    });

    test('{{  true  }} should be rendered as true', () async {
      var engine = TemplateEngine();
      var parserResult = await engine.parseText('{{  true  }}');
      var renderResult = await engine.render(parserResult);
      renderResult.text.should.be('true');
    });
  });
  group('test: false', () {
    test('{{false}} should be rendered as false', () async {
      var engine = TemplateEngine();
      var parserResult = await engine.parseText('{{false}}');
      var renderResult = await engine.render(parserResult);
      renderResult.text.should.be('false');
    });

    test('{{FALSE}} should be rendered as false', () async {
      var engine = TemplateEngine();
      var parserResult = await engine.parseText('{{FALSE}}');
      var renderResult = await engine.render(parserResult);
      renderResult.text.should.be('false');
    });

    test('{{   FAlse}} should be rendered as false', () async {
      var engine = TemplateEngine();
      var parserResult = await engine.parseText('{{   FAlse}}');
      var renderResult = await engine.render(parserResult);
      renderResult.text.should.be('false');
    });

    test('{{faLSE  }} should be rendered as false', () async {
      var engine = TemplateEngine();
      var parserResult = await engine.parseText('{{faLSE   }}');
      var renderResult = await engine.render(parserResult);
      renderResult.text.should.be('false');
    });

    test('{{  false  }} should be rendered as false', () async {
      var engine = TemplateEngine();
      var parserResult = await engine.parseText('{{  false  }}');
      var renderResult = await engine.render(parserResult);
      renderResult.text.should.be('false');
    });
  });
}
