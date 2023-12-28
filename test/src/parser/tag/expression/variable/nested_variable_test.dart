import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{person}} should render the person variable', () async {
    var engine = TemplateEngine();
    VariableMap variables = {
      'person': {
        'name': 'John Doe',
        'age': 30,
        'child': {
          'name': 'Jane Doe',
          'age': 5,
        }
      }
    };
    var parseResult = engine.parseTemplate(TextTemplate('{{person}}'));
    var renderResult = await engine.render(parseResult, variables);
    renderResult.text.should
        .be('{name: John Doe, age: 30, child: {name: Jane Doe, age: 5}}');
  });

  test('{{person.name}} should render the nested person.name variable',
      () async {
    var engine = TemplateEngine();
    VariableMap variables = {
      'person': {
        'name': 'John Doe',
        'age': 30,
        'child': {
          'name': 'Jane Doe',
          'age': 5,
        }
      }
    };
    var parseResult = engine.parseTemplate(TextTemplate('{{person.name}}'));
    var renderResult = await engine.render(parseResult, variables);
    renderResult.text.should.be('John Doe');
  });

  test(
      '{{person.child.name}} should render the nested person.child.name variable',
      () async {
    var engine = TemplateEngine();
    VariableMap variables = {
      'person': {
        'name': 'John Doe',
        'age': 30,
        'child': {
          'name': 'Jane Doe',
          'age': 5,
        }
      }
    };
    var parseResult =
        engine.parseTemplate(TextTemplate('{{person.child.name}}'));
    var renderResult = await engine.render(parseResult, variables);
    renderResult.text.should.be('Jane Doe');
  });

  test(
      '{{person.child.age}} should render the nested person.child.age variable',
      () async {
    var engine = TemplateEngine();
    VariableMap variables = {
      'person': {
        'name': 'John Doe',
        'age': 30,
        'child': {
          'name': 'Jane Doe',
          'age': 5,
        }
      }
    };
    var parseResult =
        engine.parseTemplate(TextTemplate('{{person.child.age}}'));
    var renderResult = await engine.render(parseResult, variables);
    renderResult.text.should.be('5');
  });

  test('"Hello {{person.child.name}}." should render a greeting', () async {
    var engine = TemplateEngine();
    VariableMap variables = {
      'person': {
        'name': 'John Doe',
        'age': 30,
        'child': {
          'name': 'Jane Doe',
          'age': 5,
        }
      }
    };
    var parseResult =
        engine.parseTemplate(TextTemplate('Hello {{person.child.name}}.'));
    var renderResult = await engine.render(parseResult, variables);
    renderResult.text.should.be('Hello Jane Doe.');
  });
}
