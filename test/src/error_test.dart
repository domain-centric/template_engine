import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/src/error.dart';
import 'package:template_engine/src/render.dart';
import 'package:template_engine/src/template.dart';
import 'package:template_engine/src/tag/tag_variable.dart';

void main() {
  given('object: Variables', () {
    var variables = const Variables({'name': 'John Doe'});

    given(
        'objects: ParseContext and '
        'VariableRenderer with variable name "person"', () {
      var node = VariableRenderer(
        source: DummySource(),
        namePath: 'name',
      );
      var context = RenderContext(variables);

      when('call: node.render(context)', () {
        node.render(context);

        then('expect: context.errors to be empty',
            () => context.errors.should.beEmpty());
      });
    });

    given(
        'objects: ParseContext and '
        'VariableRenderer with none existing variable name "age"', () {
      var node = VariableRenderer(
        source: DummySource(),
        namePath: 'age',
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
            'expect: first error message tp be correct',
            () => context.errors[0].message.should
                .be('Variable name path could not be found: age'));

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
              .be('Render Error: Variable name path could not be found: age '
                  'position: 1:4 source: Text'),
        );
      });
    });
  });
}

class DummySource extends TemplateSource {
  DummySource()
      : super(template: TextTemplate('Hello {{name}}.'), parserPosition: '1:4');
}
