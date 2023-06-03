import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/src/render.dart';
import 'package:template_engine/src/template.dart';
import 'package:template_engine/src/template_engine.dart';
import 'package:template_engine/src/variable/variable.dart';

void main() {
  given('escapedTagStartParser and escapedTagEndParser', () {
    given('object: Template("Hello \\{{ world.")', () {
      var template = TextTemplate('Hello \\{{ world.');
      var engine = TemplateEngine(variables: <String, Object>{});

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
      var engine = TemplateEngine(variables: <String, Object>{});

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
      var engine = TemplateEngine(variables: <String, Object>{});

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

  given('Variables with correct and incorrect names', () {
    var variables = const {
      'name': 'John Doe',
      '@ge': 30,
      'child': {
        'n@me': 'Jane Doe',
        'age': 5,
      }
    };
    var template = TextTemplate('content not important');
    var engine = TemplateEngine(variables: variables);

    when('calling engine.parse(template)', () {
      then('should throw a correct exception', () {
        Should.throwException<VariableException>(() => engine.parse(template))!
            .message
            .should
            .be('Variable name: "@ge" is invalid: '
                'letter expected at position: 0\n'
                'Variable name: "child.n@me" is invalid: '
                'end of input expected at position: 7');
      });
    });
  });
}
