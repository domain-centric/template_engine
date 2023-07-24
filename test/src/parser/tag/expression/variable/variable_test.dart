import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/template_engine.dart';

import '../../../../template_engine_test.dart';

void main() {
  given('expressionParser(ParserContext())', () {
    var engine = TemplateEngine();
    var parser = expressionParser(ParserContext(engine));
    when(
        'calling: parser.parse("x").value.'
        'render(RenderContext({"x": 42})', () {
      var result =
          parser.parse("x").value.render(RenderContext(engine, {"x": 42}));
      var expected = 42;
      then('result should be: $expected', () => result.should.be(expected));
    });

    when(
        'calling: parser.parse("x / y").value.'
        'render(RenderContext({"x": 6, "y": 2})', () {
      var result = parser
          .parse("x / y")
          .value
          .render(RenderContext(engine, {"x": 6, "y": 2}));
      var expected = 3;
      then('result should be: $expected', () => result.should.be(expected));
    });
  });
  var variables = {'name': 'world'};
  var engine = TemplateEngine();
  given('object: TemplateEngine with variables and a template', () {
    var template = const TextTemplate('Hello {{name}}.');

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
          'expect: second child node to be a Expression with namePath "name"',
          () => parseResult.nodes[1].should
              .beOfType<VariableExpression>()!
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
    var template = const TextTemplate('Hello {{  \t name}}.');
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
              .beOfType<VariableExpression>()!
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
    var template = const TextTemplate('Hello {{name  \t }}.');

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
              .beOfType<VariableExpression>()!
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
    var template = const TextTemplate('Hello {{\t\tname  \t }}.');
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
          'expect: second child node to be a VariableExpression '
          'with namePath "name"',
          () => parseResult.nodes[1].should
              .beOfType<VariableExpression>()!
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

  given("TextTemplate('Hello {{name}}.')", () {
    var template = const TextTemplate('Hello {{name}}.');
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
          'expect: second child node to be a VariableExpression '
          'with namePath "name"',
          () => parseResult.nodes[1].should
              .beOfType<VariableExpression>()!
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
  given("Nested variables", () {
    Variables variables = {
      'person': {
        'name': 'John Doe',
        'age': 30,
        'child': {
          'name': 'Jane Doe',
          'age': 5,
        }
      }
    };

    var expression = VariableExpression(DummySource(), 'person');

    when(
        'calling: expression'
        '.render(RenderContext(variables)).toString()', () {
      var result =
          expression.render(RenderContext(engine, variables)).toString();

      then(
          'expect: result should be '
          '"{name: John Doe, age: 30, child: {name: Jane Doe, age: 5}}"',
          () => result.should.be(
              '{name: John Doe, age: 30, child: {name: Jane Doe, age: 5}}'));
    });

    given("VariableExpression('person.name')", () {
      var expression = VariableExpression(DummySource(), 'person.name');

      when('calling: expression.render(RenderContext(variables))', () {
        var result = expression.render(RenderContext(engine, variables));

        then('expect: result should be "John Doe"',
            () => result.should.be('John Doe'));
      });
    });

    given("VariableExpression('person.child.name')", () {
      var expression = VariableExpression(DummySource(), 'person.child.name');

      when('call: expression.render(RenderContext(variables))', () {
        var result = expression.render(RenderContext(engine, variables));

        then('expect: result should be "Jane Doe"',
            () => result.should.be('Jane Doe'));
      });
    });

    given("VariableExpression('invalid')", () {
      var expression = VariableExpression(DummySource(), 'invalid');
      var renderContext = RenderContext(engine, variables);

      when('calling: expression.render(renderContext)', () {
        expression.render(renderContext);

        then('renderContext.errors.length should be 1', () {
          renderContext.errors.length.should.be(1);
        });
        var expected = 'Variable does not exist: invalid';
        then('should throw a Variable exception with message: $expected',
            () => renderContext.errors.first.message.should.be(expected));
      });
    });

    given('TextTemplate with a nested variable name', () {
      var template = const TextTemplate('Hello {{person.child.name}}.');
      var engine = TemplateEngine();
      when('calling: engine.parse(template)', () {
        var parseResult = engine.parse(template);

        when('calling: engine.parse(template).text', () {
          var renderResult = engine.render(parseResult, variables).text;
          var expected = 'Hello Jane Doe.';
          then('result should be: $expected', () {
            renderResult.should.be(expected);
          });
        });
      });
    });
  });
}

class DummySource extends Source {
  DummySource() : super.fromPosition(DummyTemplate(), '1,1');
}