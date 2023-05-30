import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/src/generic_parser/parser.dart';
import 'package:template_engine/src/render.dart';
import 'package:template_engine/src/template.dart';
import 'package:template_engine/src/template_engine.dart';
import 'package:template_engine/src/variable/variable_renderer.dart';

void main() {
  given('object: TemplateEngine with variable and a template', () {
    var template = TextTemplate('Hello {{name}}.');
    var engine = TemplateEngine(variables: {'name': 'world'});

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
          'expect: second child node to be a VariableNode with namePath "name"',
          () => model.children[1].should
              .beOfType<VariableNode>()!
              .namePath
              .should
              .be(['name']));

      then(
          'expect: last child node to be a TextNode with text "."',
          () => model.children.last.should
              .beOfType<TextNode>()!
              .text
              .should
              .be('.'));
    });

    when('call: render(model)', () {
      var model = engine.parse(template);
      var result = engine.render(model);
      then('return: "Hello world."', () => result.should.be('Hello world.'));
    });
  });

  given(
      'object: TemplateEngine with variable and a '
      'template with spaces before variable name', () {
    var template = TextTemplate('Hello {{  \t name}}.');
    var engine = TemplateEngine(variables: {'name': 'world'});

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
          'expect: second child node to be a VariableNode with namePath "name"',
          () => model.children[1].should
              .beOfType<VariableNode>()!
              .namePath
              .should
              .be(['name']));

      then(
          'expect: last child node to be a TextNode with text "."',
          () => model.children.last.should
              .beOfType<TextNode>()!
              .text
              .should
              .be('.'));
    });

    when('call: render(model)', () {
      var model = engine.parse(template);
      var result = engine.render(model);
      then('return: "Hello world."', () => result.should.be('Hello world.'));
    });
  });

  given(
      'object: TemplateEngine with variable and a '
      'template with spaces after variable name', () {
    var template = TextTemplate('Hello {{name  \t }}.');
    var engine = TemplateEngine(variables: {'name': 'world'});

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
          'expect: second child node to be a VariableNode with namePath "name"',
          () => model.children[1].should
              .beOfType<VariableNode>()!
              .namePath
              .should
              .be(['name']));

      then(
          'expect: last child node to be a TextNode with text "."',
          () => model.children.last.should
              .beOfType<TextNode>()!
              .text
              .should
              .be('.'));
    });

    when('call: render(model)', () {
      var model = engine.parse(template);
      var result = engine.render(model);
      then('return: "Hello world."', () => result.should.be('Hello world.'));
    });
  });

  given(
      'object: TemplateEngine with variable and a '
      'template with spaces after variable name', () {
    var template = TextTemplate('Hello {{\t\tname  \t }}.');
    var engine = TemplateEngine(variables: {'name': 'world'});

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
          'expect: second child node to be a VariableNode with namePath "name"',
          () => model.children[1].should
              .beOfType<VariableNode>()!
              .namePath
              .should
              .be(['name']));

      then(
          'expect: last child node to be a TextNode with text "."',
          () => model.children.last.should
              .beOfType<TextNode>()!
              .text
              .should
              .be('.'));
    });

    when('call: render(model)', () {
      var model = engine.parse(template);
      var result = engine.render(model);
      then('return: "Hello world."', () => result.should.be('Hello world.'));
    });
  });

  given('object: TemplateEngine with EMPTY variables and a template', () {
    var template = TextTemplate('Hello {{name}}.');
    var engine = TemplateEngine(variables: {});

    when('call: parse(template)', () {
      then(
          'expect: a ParseException thrown',
          () => Should.throwException<ParseException>(
              () => {engine.parse(template)}));
    });
  });
}
