import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/src/render.dart';
import 'package:template_engine/src/template.dart';
import 'package:template_engine/src/variable/variable.dart';

import '../test_logger.dart';

void main() {
  given('objects: Variables', () {
    var variables = {
      'person': {
        'name': 'John Doe',
        'age': 30,
        'child': {
          'name': 'Jane Doe',
          'age': 5,
        }
      }
    };

    given(
        'objects: TestLogger, ParseContext and '
        'VariableNode with variable name "person"', () {
      var logger = TestLogger();
      var node = VariableNode(
        templateSection: DummyTemplateSection(),
        namePath: 'person',
      );
      var context = RenderContext(
        variables: variables,
        logger: logger.logger,
      );

      when('call: node.render(context)', () {
        logger.logs.clear;
        var result = node.render(context);

        then(
            'expect: result should be '
            '"{name: John Doe, age: 30, child: {name: Jane Doe, age: 5}}"',
            () => result.should.be(
                '{name: John Doe, age: 30, child: {name: Jane Doe, age: 5}}'));
      });
    });

    given(
        'objects: TestLogger, ParseContext and '
        'VariableNode with variable name "person.name"', () {
      var logger = TestLogger();
      var node = VariableNode(
        templateSection: DummyTemplateSection(),
        namePath: 'person.name',
      );
      var context = RenderContext(
        variables: variables,
        logger: logger.logger,
      );

      when('call: node.render(context)', () {
        var result = node.render(context);

        then('expect: result should be "John Doe"',
            () => result.should.be('John Doe'));
      });
    });

    given(
        'objects: TestLogger, ParseContext and '
        'VariableNode with variable name "person.name.child.name"', () {
      var logger = TestLogger();
      var node = VariableNode(
        templateSection: DummyTemplateSection(),
        namePath: 'person.child.name',
      );
      var context = RenderContext(
        variables: variables,
        logger: logger.logger,
      );

      when('call: node.render(context)', () {
        var result = node.render(context);

        then('expect: result should be "Jane Doe"',
            () => result.should.be('Jane Doe'));
      });
    });

    /// none existing variable name

    given(
        'objects: TestLogger, ParseContext and '
        'VariableNode with none existing variable name', () {
      var logger = TestLogger();
      var node = VariableNode(
        templateSection: DummyTemplateSection(),
        namePath: 'invalid',
      );
      var context = RenderContext(
        variables: variables,
        logger: logger.logger,
      );

      when('call: node.render(context)', () {
        var result = node.render(context);

        then(
            'expect: logger.log to contain the correct parser log',
            () => logger.logs.last.should.be(
                '\nParser warning: Variable name path could not be found: invalid\n'
                'Template source: Text\n'
                'Template location: 1:4\n'
                'Template section: {{name}}\n'));

        then('expect: result should be ""', () => result.should.be(''));
      });
    });
  });
}

class DummyTemplateSection extends TemplateSection {
  DummyTemplateSection()
      : super(
            template: TextTemplate('Hello {{name}}.'),
            row: 1,
            column: 4,
            text: '{{name}}');
}
