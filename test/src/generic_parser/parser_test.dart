import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/src/generic_parser/parser.dart';
import 'package:template_engine/src/render.dart';
import 'package:template_engine/src/template.dart';
import 'package:template_engine/src/template_engine.dart';
import 'package:template_engine/src/variable/variable_renderer.dart';

void main() {
  given('object: Template("Hello \\{{ world.")', () {
    var template = TextTemplate('Hello \\{{ world.');
    var engine = TemplateEngine(variables: {});

    when('call: parse(template)', () {
      var model = engine.parse(template);

      then('expect: 3 child nodes', () => model.children.length.should.be(3));
      then(
          'expect: first child node to be a TextNode with text "Hallo "',
          () => model.children.first.should
              .beOfType<TextNode>()!
              .text
              .should
              .be('Hello '));

      then(
          'expect: second child node to be a TextNode with text "{{"',
          () => model.children[1].should
              .beOfType<TextNode>()!
              .text
              .should
              .be('{{'));

      then(
          'expect: last child node to be a TextNode with text " world."',
          () => model.children.last.should
              .beOfType<TextNode>()!
              .text
              .should
              .be(' world.'));
    });

    when('call: render(model)', () {
      var model = engine.parse(template);
      var result = engine.render(model);
      then('return: "Hello {{ world."',
          () => result.should.be('Hello {{ world.'));
    });
  });

  given('object: Template("Hello \\}} world.")', () {
    var template = TextTemplate('Hello \\}} world.');
    var engine = TemplateEngine(variables: {});

    when('call: parse(template)', () {
      var model = engine.parse(template);

      then('expect: 3 child nodes', () => model.children.length.should.be(3));
      then(
          'expect: first child node to be a TextNode with text "Hallo "',
          () => model.children.first.should
              .beOfType<TextNode>()!
              .text
              .should
              .be('Hello '));

      then(
          'expect: second child node to be a TextNode with text "}}"',
          () => model.children[1].should
              .beOfType<TextNode>()!
              .text
              .should
              .be('}}'));

      then(
          'expect: last child node to be a TextNode with text " world. "',
          () => model.children.last.should
              .beOfType<TextNode>()!
              .text
              .should
              .be(' world.'));
    });

    when('call: render(model)', () {
      var model = engine.parse(template);
      var result = engine.render(model);
      then('return: "Hello }} world."',
          () => result.should.be('Hello }} world.'));
    });
  });

  
  given('object: Template("\\{{ this is not a tag or variable \\}}")', () {
    var template = TextTemplate('\\{{ this is not a tag or variable \\}}');
    var engine = TemplateEngine(variables: {});

    when('call: parse(template)', () {
      var model = engine.parse(template);

      then('expect: 3 child nodes', () => model.children.length.should.be(3));
      then(
          'expect: first child node to be a TextNode with text "{{"',
          () => model.children.first.should
              .beOfType<TextNode>()!
              .text
              .should
              .be('{{'));

      then(
          'expect: second child node to be a TextNode with text " this is not a tag or variable "',
          () => model.children[1].should
              .beOfType<TextNode>()!
              .text
              .should
              .be(' this is not a tag or variable '));

      then(
          'expect: last child node to be a TextNode with text "}}"',
          () => model.children.last.should
              .beOfType<TextNode>()!
              .text
              .should
              .be('}}'));
    });

    when('call: render(model)', () {
      var model = engine.parse(template);
      var result = engine.render(model);
      then('return: "{{ this is not a tag or variable }}"',
          () => result.should.be('{{ this is not a tag or variable }}'));
    });
  });
}
