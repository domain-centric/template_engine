import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  given('unknownTagOrVariableParser', () {
    given('object: Template with none defined tag', () {
      var template = TextTemplate('Hello {{notDefined attribute="1"}}.');
      var engine = TemplateEngine();

      when('call: parse(template)', () {
        var result = engine.parse(template);

        then('expect: no 1 error', () => result.errors.length.should.be(1));
        var expected = '1:20: invalid tag syntax';
        then('expect: errorMessage to be "$expected"',
            () => result.errorMessage.should.be(expected));
      });
    });

    given('object: Template with 2 none defined tags', () {
      var template = TextTemplate(
          'Hello {{notDefined1 attribute="1"}} {{notDefined2 attribute="1"}}.');
      var engine = TemplateEngine();

      when('call: parse(template)', () {
        var result = engine.parse(template);

        then('expect: no 2 error', () => result.errors.length.should.be(2));
        var expected = '1:21: invalid tag syntax\n'
            '1:51: invalid tag syntax';
        then('expect: errorMessage to be "$expected"',
            () => result.errorMessage.should.be(expected));
      });
    });
  });

  given('missingTagStartParser', () {
    given('object: Template("Hello {{ world.")', () {
      var template = TextTemplate('Hello {{ world.');
      var engine = TemplateEngine();

      when('call: parse(template)', () {
        var result = engine.parse(template);

        then('expect: 1 error', () => result.errors.length.should.be(1));

        var expected = '1:7: Found tag start: {{, '
            'but it was not followed with a tag end: }}';
        then('expect: errorMessage to be "$expected"', () {
          return result.errorMessage.should.be(expected);
        });
      });
    });

    given('object: Template("Hello \\{{ {{ world.")', () {
      var template = TextTemplate('Hello \\{{ {{ world.');
      var engine = TemplateEngine();

      when('call: parse(template)', () {
        var result = engine.parse(template);

        then('expect: 1 error', () => result.errors.length.should.be(1));

        var expected = '1:11: Found tag start: {{, '
            'but it was not followed with a tag end: }}';
        then('expect: errorMessage to be "$expected"', () {
          return result.errorMessage.should.be(expected);
        });
      });
    });

    given('object: Template("Hello {{name}} {{.")', () {
      var template = TextTemplate('Hello {{name}} {{.');
      var engine = TemplateEngine();

      when('call: parse(template)', () {
        var result = engine.parse(template);

        then('expect: 1 error', () => result.errors.length.should.be(1));

        var expected = '1:16: Found tag start: {{, '
            'but it was not followed with a tag end: }}';
        then('expect: errorMessage to be "$expected"', () {
          return result.errorMessage.should.be(expected);
        });
      });
    });
  });

  given('missingTagEndParser', () {
    given('object: Template("Hello }} world.")', () {
      var template = TextTemplate('Hello }} world.');
      var engine = TemplateEngine();

      when('call: parse(template)', () {
        var result = engine.parse(template);

        then('expect: 1 error', () => result.errors.length.should.be(1));

        var expected = '1:7: Found tag end: }}, '
            'but it was not preceded with a tag start: {{';
        then('expect: errorMessage to be "$expected"', () {
          return result.errorMessage.should.be(expected);
        });
      });
    });

    given('object: Template("Hello \\}} }} world.")', () {
      var template = TextTemplate('Hello \\}} }} world.');
      var engine = TemplateEngine();

      when('call: parse(template)', () {
        var result = engine.parse(template);
        then('expect: 1 error', () => result.errors.length.should.be(1));

        var expected = '1:11: Found tag end: }}, '
            'but it was not preceded with a tag start: {{';
        then('expect: errorMessage to be "$expected"', () {
          return result.errorMessage.should.be(expected);
        });
      });
    });

    given('object: Template("Hello {{name}} }}.")', () {
      var template = TextTemplate('Hello {{name}} }}.');
      var engine = TemplateEngine();

      when('call: parse(template)', () {
        var result = engine.parse(template);
        then('expect: 1 error', () => result.errors.length.should.be(1));

        var expected = '1:16: Found tag end: }}, '
            'but it was not preceded with a tag start: {{';
        then('expect: errorMessage to be "$expected"', () {
          return result.errorMessage.should.be(expected);
        });
      });
    });
  });
}
