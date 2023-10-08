import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{person}} should render the person variable', () {
    var engine = TemplateEngine();
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
    var parseResult = engine.parseTemplate(TextTemplate('{{person}}'));
    var renderResult = engine.render(parseResult, variables);
    renderResult.text.should
        .be('{name: John Doe, age: 30, child: {name: Jane Doe, age: 5}}');
  });

  test('{{person.name}} should render the nested person.name variable', () {
    var engine = TemplateEngine();
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
    var parseResult = engine.parseTemplate(TextTemplate('{{person.name}}'));
    var renderResult = engine.render(parseResult, variables);
    renderResult.text.should.be('John Doe');
  });

  test(
      '{{person.child.name}} should render the nested person.child.name variable',
      () {
    var engine = TemplateEngine();
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
    var parseResult =
        engine.parseTemplate(TextTemplate('{{person.child.name}}'));
    var renderResult = engine.render(parseResult, variables);
    renderResult.text.should.be('Jane Doe');
  });

  test(
      '{{person.child.age}} should render the nested person.child.age variable',
      () {
    var engine = TemplateEngine();
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
    var parseResult =
        engine.parseTemplate(TextTemplate('{{person.child.age}}'));
    var renderResult = engine.render(parseResult, variables);
    renderResult.text.should.be('5');
  });

  test('"Hello {{person.child.name}}." should render a greeting', () {
    var engine = TemplateEngine();
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
    var parseResult =
        engine.parseTemplate(TextTemplate('Hello {{person.child.name}}.'));
    var renderResult = engine.render(parseResult, variables);
    renderResult.text.should.be('Hello Jane Doe.');
  });
}
