import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  given('escapedTagStartParser and escapedTagEndParser', () {
    given('object: Template("Hello \\{{ world.")', () {
      var template = TextTemplate('Hello \\{{ world.');
      var engine = TemplateEngine();

      when('call: parse(template)', () {
        then('expect: 3 child nodes', () async {
          var parseResult = await engine.parseTemplate(template);
          var templateParseResult = parseResult.children.first;
          templateParseResult.children.length.should.be(3);
        });
        then('expect: first child node to be a String with text "Hallo "',
            () async {
          var parseResult = await engine.parseTemplate(template);
          var templateParseResult = parseResult.children.first;
          templateParseResult.children.first.should
              .beOfType<String>()!
              .should
              .be('Hello ');
        });

        then('expect: second child node to be a String with text "{{"',
            () async {
          var parseResult = await engine.parseTemplate(template);
          var templateParseResult = parseResult.children.first;
          templateParseResult.children[1].should
              .beOfType<String>()!
              .should
              .be('{{');
        });

        then('expect: last child node to be a String with text " world."',
            () async {
          var parseResult = await engine.parseTemplate(template);
          var templateParseResult = parseResult.children.first;
          templateParseResult.children.last.should
              .beOfType<String>()!
              .should
              .be(' world.');
        });
      });

      when('call: render(parseResult)', () {
        then('return: "Hello {{ world."', () async {
          var parseResult = await engine.parseTemplate(template);
          var variables = {'name': 'world'};
          var result = await engine.render(parseResult, variables);
          result.text.should.be('Hello {{ world.');
        });
      });
    });

    given('object: Template("Hello \\}} world.")', () {
      var template = TextTemplate('Hello \\}} world.');
      var engine = TemplateEngine();

      when('call: parse(template)', () {
        then('expect: 3 child nodes', () async {
          var parseResult = await engine.parseTemplate(template);
          var templateParseResult = parseResult.children.first;
          templateParseResult.children.length.should.be(3);
        });
        then('expect: first child node to be a String with text "Hallo "',
            () async {
          var parseResult = await engine.parseTemplate(template);
          var templateParseResult = parseResult.children.first;
          templateParseResult.children.first.should
              .beOfType<String>()!
              .should
              .be('Hello ');
        });

        then('expect: second child node to be a String with text "}}"',
            () async {
          var parseResult = await engine.parseTemplate(template);
          var templateParseResult = parseResult.children.first;
          templateParseResult.children[1].should
              .beOfType<String>()!
              .should
              .be('}}');
        });

        then('expect: last child node to be a String with text " world. "',
            () async {
          var parseResult = await engine.parseTemplate(template);
          var templateParseResult = parseResult.children.first;
          templateParseResult.children.last.should
              .beOfType<String>()!
              .should
              .be(' world.');
        });
      });

      when('call: render(parseResult)', () {
        then('return text: "Hello }} world."', () async {
          var parseResult = await engine.parseTemplate(template);
          var variables = {'name': 'world'};
          var result = await engine.render(parseResult, variables);
          result.text.should.be('Hello }} world.');
        });
      });
    });

    given('object: Template("\\{{ this is not a tag or variable \\}}")', () {
      var template = TextTemplate('\\{{ this is not a tag or variable \\}}');
      var engine = TemplateEngine();

      when('call: parse(template)', () {
        then('expect: 3 child nodes', () async {
          var parseResult = await engine.parseTemplate(template);
          var templateParseResult = parseResult.children.first;
          return templateParseResult.children.length.should.be(3);
        });
        then('expect: first child node to be a String with text "{{"',
            () async {
          var parseResult = await engine.parseTemplate(template);
          var templateParseResult = parseResult.children.first;
          templateParseResult.children.first.should
              .beOfType<String>()!
              .should
              .be('{{');
        });

        then(
            'expect: second child node to be a String '
            'with text " this is not a tag or variable "', () async {
          var parseResult = await engine.parseTemplate(template);
          var templateParseResult = parseResult.children.first;
          templateParseResult.children[1].should
              .beOfType<String>()!
              .should
              .be(' this is not a tag or variable ');
        });

        then('expect: last child node to be a String with text "}}"', () async {
          var parseResult = await engine.parseTemplate(template);
          var templateParseResult = parseResult.children.first;
          templateParseResult.children.last.should
              .beOfType<String>()!
              .should
              .be('}}');
        });
      });

      when('call: render(parseResult)', () {
        then('expect: result.text "{{ this is not a tag or variable }}"',
            () async {
          var parseResult = await engine.parseTemplate(template);
          var variables = {'name': 'world'};
          var result = await engine.render(parseResult, variables);
          result.text.should.be('{{ this is not a tag or variable }}');
        });
      });
    });
  });
}
