import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('test: true', () {
    test('{{true}} should be rendered as true', () {
      var engine = TemplateEngine();
      var parserResult = engine.parse(TextTemplate('{{true}}'));
      var renderResult = engine.render(parserResult);
      renderResult.text.should.be('true');
    });

    test('{{TRUE}} should be rendered as true', () {
      var engine = TemplateEngine();
      var parserResult = engine.parse(TextTemplate('{{TRUE}}'));
      var renderResult = engine.render(parserResult);
      renderResult.text.should.be('true');
    });

    test('{{   TRue}} should be rendered as true', () {
      var engine = TemplateEngine();
      var parserResult = engine.parse(TextTemplate('{{   TRue}}'));
      var renderResult = engine.render(parserResult);
      renderResult.text.should.be('true');
    });

    test('{{trUE  }} should be rendered as true', () {
      var engine = TemplateEngine();
      var parserResult = engine.parse(TextTemplate('{{trUE   }}'));
      var renderResult = engine.render(parserResult);
      renderResult.text.should.be('true');
    });

    test('{{  true  }} should be rendered as true', () {
      var engine = TemplateEngine();
      var parserResult = engine.parse(TextTemplate('{{  true  }}'));
      var renderResult = engine.render(parserResult);
      renderResult.text.should.be('true');
    });
  });
  group('test: false', () {
    test('{{false}} should be rendered as false', () {
      var engine = TemplateEngine();
      var parserResult = engine.parse(TextTemplate('{{false}}'));
      var renderResult = engine.render(parserResult);
      renderResult.text.should.be('false');
    });

    test('{{FALSE}} should be rendered as false', () {
      var engine = TemplateEngine();
      var parserResult = engine.parse(TextTemplate('{{FALSE}}'));
      var renderResult = engine.render(parserResult);
      renderResult.text.should.be('false');
    });

    test('{{   FAlse}} should be rendered as false', () {
      var engine = TemplateEngine();
      var parserResult = engine.parse(TextTemplate('{{   FAlse}}'));
      var renderResult = engine.render(parserResult);
      renderResult.text.should.be('false');
    });

    test('{{faLSE  }} should be rendered as false', () {
      var engine = TemplateEngine();
      var parserResult = engine.parse(TextTemplate('{{faLSE   }}'));
      var renderResult = engine.render(parserResult);
      renderResult.text.should.be('false');
    });

    test('{{  false  }} should be rendered as false', () {
      var engine = TemplateEngine();
      var parserResult = engine.parse(TextTemplate('{{  false  }}'));
      var renderResult = engine.render(parserResult);
      renderResult.text.should.be('false');
    });
  });
}
