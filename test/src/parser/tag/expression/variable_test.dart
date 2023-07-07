import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  given('expressionParser(ParserContext())', () {
    var parser = expressionParser(ParserContext());
    when(
        'calling: parser.parse("x").value.'
        'render(RenderContext({"x": 42})', () {
      var result = parser.parse("x").value.render(RenderContext({"x": 42}));
      var expected = 42;
      then('result should be: $expected', () => result.should.be(expected));
    });

    when(
        'calling: parser.parse("x / y").value.'
        'render(RenderContext({"x": 6, "y": 2})', () {
      var result =
          parser.parse("x / y").value.render(RenderContext({"x": 6, "y": 2}));
      var expected = 3;
      then('result should be: $expected', () => result.should.be(expected));
    });
  });
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

    var expression = VariableExpression('person');

    when(
        'calling: expression'
        '.render(RenderContext(variables)).toString()', () {
      var result = expression.render(RenderContext(variables)).toString();

      then(
          'expect: result should be '
          '"{name: John Doe, age: 30, child: {name: Jane Doe, age: 5}}"',
          () => result.should.be(
              '{name: John Doe, age: 30, child: {name: Jane Doe, age: 5}}'));
    });

    given("VariableExpression('person.name')", () {
      var expression = VariableExpression('person.name');

      when('calling: expression.render(RenderContext(variables))', () {
        var result = expression.render(RenderContext(variables));

        then('expect: result should be "John Doe"',
            () => result.should.be('John Doe'));
      });
    });

    given("VariableExpression('person.child.name')", () {
      var expression = VariableExpression('person.child.name');

      when('call: expression.render(RenderContext(variables))', () {
        var result = expression.render(RenderContext(variables));

        then('expect: result should be "Jane Doe"',
            () => result.should.be('Jane Doe'));
      });
    });

    /// none existing variable name

    given("VariableExpression('invalid')", () {
      var expression = VariableExpression('invalid');

      when('calling: expression.eval(variables)', () {
        var expected = 'Variable name path could not be found: invalid';
        then(
            'should throw a Variable exception with message: $expected',
            () => Should.throwException<VariableException>(
                    () => expression.render(RenderContext(variables)))!
                .message
                .should
                .be(expected));
      });
    });

    given('TextTemplate with a nested variable name', () {
      var template = TextTemplate('Hello {{person.child.name}}.');
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
//TODO
  // then('expect: context.errors to contain 1 error',
  //     () => context.errors.length.should.be(1));

  // then('expect: context.errors[0].stage == errorStage.render',
  //     () => context.errors[0].stage.should.be(ErrorStage.render));

  // then(
  //     'expect: context.errors[0].severity == errorSeverity.error',
  //     () => context.errors[0].message.should
  //         .be('Variable name path could not be found: invalid'));

  // then(
  //     'expect: context.errors[0].source == "position: 1:4 source: Text"',
  //     () => context.errors[0].source
  //         .toString()
  //         .should
  //         .be('position: 1:4 source: Text'));

  // then(
  //   'expect: context.errors[0].occurrence == no older than 1 minute',
  //   () => context.errors[0].occurrence.should
  //       .beCloseTo(DateTime.now(), delta: const Duration(minutes: 1)),
  // );

  // then(
  //   'expect: context.errors[0].toString is correct',
  //   () => context.errors[0]
  //       .toString()
  //       .should
  //       .be('Render Error: Variable name path could not be found: '
  //           'invalid position: 1:4 source: Text'),
  // );
}
