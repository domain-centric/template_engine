import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/src/generic_parser/parser.dart';
import 'package:template_engine/src/render.dart';
import 'package:template_engine/src/template.dart';
import 'package:template_engine/src/template_engine.dart';

void main() {
  given('escapedTagStartParser and escapedTagEndParser', () {
    given('object: Template("Hello \\{{ world.")', () {
      var template = TextTemplate('Hello \\{{ world.');
      var engine = TemplateEngine(variables: {});

      when('call: parse(template)', () {
        var parseResult = engine.parse(template);

        then('expect: 3 child nodes',
            () => parseResult.children.length.should.be(3));
        then(
            'expect: first child node to be a TextNode with text "Hallo "',
            () => parseResult.children.first.should
                .beOfType<TextNode>()!
                .text
                .should
                .be('Hello '));

        then(
            'expect: second child node to be a TextNode with text "{{"',
            () => parseResult.children[1].should
                .beOfType<TextNode>()!
                .text
                .should
                .be('{{'));

        then(
            'expect: last child node to be a TextNode with text " world."',
            () => parseResult.children.last.should
                .beOfType<TextNode>()!
                .text
                .should
                .be(' world.'));
      });

      when('call: render(parseResult)', () {
        var parseResult = engine.parse(template);
        var result = engine.render(parseResult);
        then('return: "Hello {{ world."',
            () => result.text.should.be('Hello {{ world.'));
      });
    });

    given('object: Template("Hello \\}} world.")', () {
      var template = TextTemplate('Hello \\}} world.');
      var engine = TemplateEngine(variables: {});

      when('call: parse(template)', () {
        var parseResult = engine.parse(template);

        then('expect: 3 child nodes',
            () => parseResult.children.length.should.be(3));
        then(
            'expect: first child node to be a TextNode with text "Hallo "',
            () => parseResult.children.first.should
                .beOfType<TextNode>()!
                .text
                .should
                .be('Hello '));

        then(
            'expect: second child node to be a TextNode with text "}}"',
            () => parseResult.children[1].should
                .beOfType<TextNode>()!
                .text
                .should
                .be('}}'));

        then(
            'expect: last child node to be a TextNode with text " world. "',
            () => parseResult.children.last.should
                .beOfType<TextNode>()!
                .text
                .should
                .be(' world.'));
      });

      when('call: render(parseResult)', () {
        var parseResult = engine.parse(template);
        var result = engine.render(parseResult);
        then('return text: "Hello }} world."',
            () => result.text.should.be('Hello }} world.'));
      });
    });

    given('object: Template("\\{{ this is not a tag or variable \\}}")', () {
      var template = TextTemplate('\\{{ this is not a tag or variable \\}}');
      var engine = TemplateEngine(variables: {});

      when('call: parse(template)', () {
        var parseResult = engine.parse(template);

        then('expect: 3 child nodes',
            () => parseResult.children.length.should.be(3));
        then(
            'expect: first child node to be a TextNode with text "{{"',
            () => parseResult.children.first.should
                .beOfType<TextNode>()!
                .text
                .should
                .be('{{'));

        then(
            'expect: second child node to be a TextNode '
            'with text " this is not a tag or variable "',
            () => parseResult.children[1].should
                .beOfType<TextNode>()!
                .text
                .should
                .be(' this is not a tag or variable '));

        then(
            'expect: last child node to be a TextNode with text "}}"',
            () => parseResult.children.last.should
                .beOfType<TextNode>()!
                .text
                .should
                .be('}}'));
      });

      when('call: render(parseResult)', () {
        var parseResult = engine.parse(template);
        var result = engine.render(parseResult);
        then('expect: result.text "{{ this is not a tag or variable }}"',
            () => result.text.should.be('{{ this is not a tag or variable }}'));
      });
    });
  });

  given('unknownTagOrVariableParser', () {
    given('object: Template("Hello {{world}}.")', () {
      var template = TextTemplate('Hello {{world}}.');
      var engine = TemplateEngine(variables: {});

      when('call: parse(template)', () {
        try {
          engine.parse(template);
        } on Exception catch (e) {
          then('expect: e is  ParseException',
              () => e.should.beOfType<ParseResult>());
          var expected = 'Parse Error: Unknown tag or variable. '
              'position: 1:7 source: Text';
          then('expect: e message to be "$expected"',
              () => e.toString().should.be(expected));
        }
      });
    });
  });

  given('missingTagStartParser', () {
    given('object: Template("Hello {{ world.")', () {
      var template = TextTemplate('Hello {{ world.');
      var engine = TemplateEngine(variables: {});

      when('call: parse(template)', () {
        try {
          engine.parse(template);
        } on Exception catch (e) {
          then('expect: e is  ParseException',
              () => e.should.beOfType<ParseResult>());

          var expected = 'Parse Error: Found tag start: {{, '
              'but it was not followed '
              'with a tag end: }} position: 1:7 source: Text';
          then('expect: e message to be "$expected"', () {
            return e.toString().should.be(expected);
          });
        }
      });
    });

    given('object: Template("Hello \\{{ {{ world.")', () {
      var template = TextTemplate('Hello \\{{ {{ world.');
      var engine = TemplateEngine(variables: {});

      when('call: parse(template)', () {
        try {
          engine.parse(template);
        } on Exception catch (e) {
          then('expect: e is  ParseException',
              () => e.should.beOfType<ParseResult>());

          var expected =
              'Parse Error: Found tag start: {{, but it was not followed '
              'with a tag end: }} position: 1:11 source: Text';
          then('expect: e message to be "$expected"', () {
            return e.toString().should.be(expected);
          });
        }
      });
    });

    given('object: Template("Hello {{name}} {{.")', () {
      var template = TextTemplate('Hello {{name}} {{.');
      var engine = TemplateEngine(variables: {'name': 'world'});

      when('call: parse(template)', () {
        try {
          engine.parse(template);
        } on Exception catch (e) {
          then('expect: e is  ParseException',
              () => e.should.beOfType<ParseResult>());

          var expected =
              'Parse Error: Found tag start: {{, but it was not followed '
              'with a tag end: }} position: 1:16 source: Text';
          then('expect: e message to be "$expected"', () {
            return e.toString().should.be(expected);
          });
        }
      });
    });
  });

  given('missingTagEndParser', () {
    given('object: Template("Hello }} world.")', () {
      var template = TextTemplate('Hello }} world.');
      var engine = TemplateEngine(variables: {});

      when('call: parse(template)', () {
        try {
          engine.parse(template);
        } on Exception catch (e) {
          then('expect: e is  ParseException',
              () => e.should.beOfType<ParseResult>());

          var expected =
              'Parse Error: Found tag end: }}, but it was not preceded '
              'with a tag start: {{ position: 1:7 source: Text';
          then('expect: e message to be "$expected"', () {
            return e.toString().should.be(expected);
          });
        }
      });
    });

    given('object: Template("Hello \\}} }} world.")', () {
      var template = TextTemplate('Hello \\}} }} world.');
      var engine = TemplateEngine(variables: {});

      when('call: parse(template)', () {
        try {
          engine.parse(template);
        } on Exception catch (e) {
          then('expect: e is  ParseException',
              () => e.should.beOfType<ParseResult>());

          var expected =
              'Parse Error: Found tag end: }}, but it was not preceded '
              'with a tag start: {{ position: 1:11 source: Text';
          then('expect: e message to be "$expected"', () {
            return e.toString().should.be(expected);
          });
        }
      });
    });

    given('object: Template("Hello {{name}} }}.")', () {
      var template = TextTemplate('Hello {{name}} }}.');
      var engine = TemplateEngine(variables: {'name': 'world'});

      when('call: parse(template)', () {
        try {
          engine.parse(template);
        } on Exception catch (e) {
          then('expect: e is  ParseException',
              () => e.should.beOfType<ParseResult>());

          var expected =
              'Parse Error: Found tag end: }}, but it was not preceded '
              'with a tag start: {{ position: 1:16 source: Text';
          then('expect: e message to be "$expected"', () {
            return e.toString().should.be(expected);
          });
        }
      });
    });
  });
}
