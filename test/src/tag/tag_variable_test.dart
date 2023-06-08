import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/src/error.dart';
import 'package:template_engine/src/tag/tag_variable.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  var variables = {'name': 'world'};
  var engine = TemplateEngine();
  given('object: TemplateEngine with variables and a template', () {
    var template = TextTemplate('Hello {{name}}.');

    when('call: parse(template)', () {
      var parseResult = engine.parse(template);

      then(
          'expect: 3 child nodes', () => parseResult.nodes.length.should.be(3));
      then(
          'expect: first child node to be a String with text "Hallo "',
          () => parseResult.nodes.first.should
              .beOfType<String>()!
              .should
              .be('Hello '));

      then(
          'expect: second child node to be a VariableNode with namePath "name"',
          () => parseResult.nodes[1].should
              .beOfType<VariableRenderer>()!
              .namePath
              .should
              .be('name'));

      then(
          'expect: last child node to be a String with text "."',
          () =>
              parseResult.nodes.last.should.beOfType<String>()!.should.be('.'));
    });

    when('call: render(parseResult)', () {
      var parseResult = engine.parse(template);
      var result = engine.render(parseResult, variables);
      then('return text: "Hello world."',
          () => result.text.should.be('Hello world.'));
    });
  });

  given(
      'object: TemplateEngine with variable and a '
      'template with spaces before variable name', () {
    var template = TextTemplate('Hello {{  \t name}}.');
    var engine = TemplateEngine();

    when('call: parse(template)', () {
      var parseResult = engine.parse(template);

      then(
          'expect: 3 child nodes', () => parseResult.nodes.length.should.be(3));
      then(
          'expect: first child node to be a String with text "Hallo "',
          () => parseResult.nodes.first.should
              .beOfType<String>()!
              .should
              .be('Hello '));

      then(
          'expect: second child node to be a VariableNode with namePath "name"',
          () => parseResult.nodes[1].should
              .beOfType<VariableRenderer>()!
              .namePath
              .should
              .be('name'));

      then(
          'expect: last child node to be a String with text "."',
          () =>
              parseResult.nodes.last.should.beOfType<String>()!.should.be('.'));
    });

    when('call: render(parseResult)', () {
      var parseResult = engine.parse(template);
      var result = engine.render(parseResult, variables);
      then('expect: result.text "Hello world."',
          () => result.text.should.be('Hello world.'));
    });
  });

  given(
      'object: TemplateEngine with variable and a '
      'template with spaces after variable name', () {
    var template = TextTemplate('Hello {{name  \t }}.');

    when('call: parse(template)', () {
      var parseResult = engine.parse(template);

      then(
          'expect: 3 child nodes', () => parseResult.nodes.length.should.be(3));
      then(
          'expect: first child node to be a String with text "Hallo "',
          () => parseResult.nodes.first.should
              .beOfType<String>()!
              .should
              .be('Hello '));

      then(
          'expect: second child node to be a VariableNode with namePath "name"',
          () => parseResult.nodes[1].should
              .beOfType<VariableRenderer>()!
              .namePath
              .should
              .be('name'));

      then(
          'expect: last child node to be a String with text "."',
          () =>
              parseResult.nodes.last.should.beOfType<String>()!.should.be('.'));
    });

    when('call: render(parseResult)', () {
      var parseResult = engine.parse(template);
      var result = engine.render(parseResult, variables);
      then('expect: result.text "Hello world."',
          () => result.text.should.be('Hello world.'));
    });
  });

  given(
      'object: TemplateEngine with variable and a '
      'template with spaces after variable name', () {
    var template = TextTemplate('Hello {{\t\tname  \t }}.');
    var engine = TemplateEngine();

    when('call: parse(template)', () {
      var parseResult = engine.parse(template);

      then(
          'expect: 3 child nodes', () => parseResult.nodes.length.should.be(3));
      then(
          'expect: first child node to be a String with text "Hallo "',
          () => parseResult.nodes.first.should
              .beOfType<String>()!
              .should
              .be('Hello '));

      then(
          'expect: second child node to be a VariableNode with namePath "name"',
          () => parseResult.nodes[1].should
              .beOfType<VariableRenderer>()!
              .namePath
              .should
              .be('name'));

      then(
          'expect: last child node to be a String with text "."',
          () =>
              parseResult.nodes.last.should.beOfType<String>()!.should.be('.'));
    });

    when('call: render(parseResult)', () {
      var parseResult = engine.parse(template);
      var result = engine.render(parseResult, variables);
      then('expect: result.text "Hello world."',
          () => result.text.should.be('Hello world.'));
    });
  });

  given('object: TemplateEngine without variables and a template', () {
    var template = TextTemplate('Hello {{name}}.');
    var engine = TemplateEngine();

    when('call: parse(template)', () {
      var parseResult = engine.parse(template);

      then(
          'expect: 3 child nodes', () => parseResult.nodes.length.should.be(3));
      then(
          'expect: first child node to be a String with text "Hallo "',
          () => parseResult.nodes.first.should
              .beOfType<String>()!
              .should
              .be('Hello '));

      then(
          'expect: second child node to be a VariableRenderer '
          'with namePath "name"',
          () => parseResult.nodes[1].should
              .beOfType<VariableRenderer>()!
              .namePath
              .should
              .be('name'));

      then(
          'expect: last child node to be a String with text "."',
          () =>
              parseResult.nodes.last.should.beOfType<String>()!.should.be('.'));

      then('expect: no errors', () => parseResult.errors.should.beEmpty());
    });
  });
  given('objects: Variables', () {
    var variables = const Variables({
      'person': {
        'name': 'John Doe',
        'age': 30,
        'child': {
          'name': 'Jane Doe',
          'age': 5,
        }
      }
    });

    given(
        'objects: ParseContext and '
        'VariableNode with variable name "person"', () {
      var node = VariableRenderer(
        source: DummyTemplateSection(),
        namePath: 'person',
      );
      var context = RenderContext(variables);

      when('call: node.render(context)', () {
        var result = node.render(context).toString();

        then('expect: context.errors to be empty',
            () => context.errors.should.beEmpty());

        then(
            'expect: result should be '
            '"{name: John Doe, age: 30, child: {name: Jane Doe, age: 5}}"',
            () => result.should.be(
                '{name: John Doe, age: 30, child: {name: Jane Doe, age: 5}}'));
      });
    });

    given(
        'objects: ParseContext and '
        'VariableNode with variable name "person.name"', () {
      var node = VariableRenderer(
        source: DummyTemplateSection(),
        namePath: 'person.name',
      );
      var context = RenderContext(variables);

      when('call: node.render(context)', () {
        var result = node.render(context);
        then('expect: context.errors to be empty',
            () => context.errors.should.beEmpty());

        then('expect: result should be "John Doe"',
            () => result.should.be('John Doe'));
      });
    });

    given(
        'objects: ParseContext and '
        'VariableNode with variable name "person.name.child.name"', () {
      var node = VariableRenderer(
        source: DummyTemplateSection(),
        namePath: 'person.child.name',
      );
      var context = RenderContext(variables);

      when('call: node.render(context)', () {
        var result = node.render(context);
        then('expect: context.errors to be empty',
            () => context.errors.should.beEmpty());

        then('expect: result should be "Jane Doe"',
            () => result.should.be('Jane Doe'));
      });
    });

    /// none existing variable name

    given(
        'objects: ParseContext and '
        'VariableNode with none existing variable name', () {
      var node = VariableRenderer(
        source: DummyTemplateSection(),
        namePath: 'invalid',
      );
      var context = RenderContext(variables);

      when('call: node.render(context)', () {
        var result = node.render(context);

        then('expect: empty result', () => result.should.be(''));

        then('expect: context.errors to contain 1 error',
            () => context.errors.length.should.be(1));

        then('expect: context.errors[0].stage == errorStage.render',
            () => context.errors[0].stage.should.be(ErrorStage.render));

        then(
            'expect: context.errors[0].severity == errorSeverity.error',
            () => context.errors[0].message.should
                .be('Variable name path could not be found: invalid'));

        then(
            'expect: context.errors[0].source == "position: 1:4 source: Text"',
            () => context.errors[0].source
                .toString()
                .should
                .be('position: 1:4 source: Text'));

        then(
          'expect: context.errors[0].occurrence == no older than 1 minute',
          () => context.errors[0].occurrence.should
              .beCloseTo(DateTime.now(), delta: const Duration(minutes: 1)),
        );

        then(
          'expect: context.errors[0].toString is correct',
          () => context.errors[0]
              .toString()
              .should
              .be('Render Error: Variable name path could not be found: '
                  'invalid position: 1:4 source: Text'),
        );
      });
    });
  });
}

class DummyTemplateSection extends TemplateSource {
  DummyTemplateSection()
      : super(template: TextTemplate('Hello {{name}}.'), parserPosition: '1:4');
}
