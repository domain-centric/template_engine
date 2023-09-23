import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  given('escapedTagStartParser and escapedTagEndParser', () {
    given('object: Template("Hello \\{{ world.")', () {
      var template = TextTemplate('Hello \\{{ world.');
      var engine = TemplateEngine();

      when('call: parse(template)', () {
        var parseResult = engine.parse(template);

        then('expect: 3 child nodes',
            () => parseResult.nodes.length.should.be(3));
        then(
            'expect: first child node to be a String with text "Hallo "',
            () => parseResult.nodes.first.should
                .beOfType<String>()!
                .should
                .be('Hello '));

        then(
            'expect: second child node to be a String with text "{{"',
            () => parseResult.nodes[1].should
                .beOfType<String>()!
                .should
                .be('{{'));

        then(
            'expect: last child node to be a String with text " world."',
            () => parseResult.nodes.last.should
                .beOfType<String>()!
                .should
                .be(' world.'));
      });

      when('call: render(parseResult)', () {
        var parseResult = engine.parse(template);
        var variables = {'name': 'world'};
        var result = engine.render(parseResult, variables);
        then('return: "Hello {{ world."',
            () => result.text.should.be('Hello {{ world.'));
      });
    });

    given('object: Template("Hello \\}} world.")', () {
      var template = TextTemplate('Hello \\}} world.');
      var engine = TemplateEngine();

      when('call: parse(template)', () {
        var parseResult = engine.parse(template);

        then('expect: 3 child nodes',
            () => parseResult.nodes.length.should.be(3));
        then(
            'expect: first child node to be a String with text "Hallo "',
            () => parseResult.nodes.first.should
                .beOfType<String>()!
                .should
                .be('Hello '));

        then(
            'expect: second child node to be a String with text "}}"',
            () => parseResult.nodes[1].should
                .beOfType<String>()!
                .should
                .be('}}'));

        then(
            'expect: last child node to be a String with text " world. "',
            () => parseResult.nodes.last.should
                .beOfType<String>()!
                .should
                .be(' world.'));
      });

      when('call: render(parseResult)', () {
        var parseResult = engine.parse(template);
        var variables = {'name': 'world'};
        var result = engine.render(parseResult, variables);
        then('return text: "Hello }} world."',
            () => result.text.should.be('Hello }} world.'));
      });
    });

    given('object: Template("\\{{ this is not a tag or variable \\}}")', () {
      var template =
          TextTemplate('\\{{ this is not a tag or variable \\}}');
      var engine = TemplateEngine();

      when('call: parse(template)', () {
        var parseResult = engine.parse(template);

        then('expect: 3 child nodes',
            () => parseResult.nodes.length.should.be(3));
        then(
            'expect: first child node to be a String with text "{{"',
            () => parseResult.nodes.first.should
                .beOfType<String>()!
                .should
                .be('{{'));

        then(
            'expect: second child node to be a String '
            'with text " this is not a tag or variable "',
            () => parseResult.nodes[1].should
                .beOfType<String>()!
                .should
                .be(' this is not a tag or variable '));

        then(
            'expect: last child node to be a String with text "}}"',
            () => parseResult.nodes.last.should
                .beOfType<String>()!
                .should
                .be('}}'));
      });

      when('call: render(parseResult)', () {
        var parseResult = engine.parse(template);
        var variables = {'name': 'world'};
        var result = engine.render(parseResult, variables);
        then('expect: result.text "{{ this is not a tag or variable }}"',
            () => result.text.should.be('{{ this is not a tag or variable }}'));
      });
    });
  });
}
