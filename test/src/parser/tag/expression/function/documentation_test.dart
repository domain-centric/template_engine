import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  given('Template engine', () {
    var engine = TemplateEngine();
    engine.functionGroups.clear();
    engine.functionGroups
        .addAll([DocumentationFunctions(), DummyFunctionGroup()]);
    when(
        "call: engine.parse(const "
        "TextTemplate('{{engine.tag.documentation()}}'))", () {
      var parseResult =
          engine.parse(const TextTemplate('{{engine.tag.documentation()}}'));
      var expected = '# ExpressionTag\n'
          'Evaluates an expression that can contain values (bool, num, string),'
          ' operators, functions, constants and variables.\n'
          'Example: The cos of 2 pi = {{cos(2 * pi)}}. '
          'The volume of a sphere = {{ (3/4) * pi * (radius ^ 3) }}.';
      then('parseResult.errors.length should be 0',
          () => parseResult.errors.length.should.be(0));
      when('calling: engine.render(parseResult)', () {
        var renderResult = engine.render(parseResult);

        then('renderResult.text be: "$expected"',
            () => renderResult.text.should.be(expected));
      });
    });

    when(
        "call: engine.parse(const "
        "TextTemplate('{{engine.function.documentation()}}'))", () {
      var parseResult = engine
          .parse(const TextTemplate('{{engine.function.documentation()}}'));
      var expected = '# Documentation Functions\n'
          '<table>\n'
          '<tr><th colspan="5">engine.tag.documentation</th></tr>\n'
          '<tr><td>description:</td><td colspan="4">Generates markdown documentation of all the tags within a TemplateEngine</td></tr>\n'
          '<tr><td>return type:</td><td colspan="4">String</td></tr>\n'
          '<tr><td>example:</td><td colspan="4">{{ engine.tag.documentation() }}</td><tr>\n'
          '<tr><td>parameter:</td><td>titleLevel</td><td>number</td><td>optional (default=1)</td>\n'
          '<td>The level of the tag title</td></tr>\n'
          '</table>\n'
          '<table>\n'
          '<tr><th colspan="5">engine.function.documentation</th></tr>\n'
          '<tr><td>description:</td><td colspan="4">Generates markdown documentation of all the functions that can be used within a ExpressionTag of a TemplateEngine</td></tr>\n'
          '<tr><td>return type:</td><td colspan="4">String</td></tr>\n'
          '<tr><td>example:</td><td colspan="4">{{ engine.function.documentation() }}</td><tr>\n'
          '<tr><td>parameter:</td><td>titleLevel</td><td>number</td><td>optional (default=1)</td>\n'
          '<td>The level of the tag title</td></tr>\n'
          '</table>\n'
          '# Test Functions\n'
          '<table>\n'
          '<tr><th colspan="5">testFunction</th></tr>\n'
          '<tr><td>description:</td><td colspan="4">TestDescription</td></tr>\n'
          '<tr><td>return type:</td><td colspan="4">Object</td></tr>\n'
          '<tr><td>example:</td><td colspan="4">{{ testFunction(parameter2=12.34, parameter3=true) }}</td><tr>\n'
          '<tr><td>parameter:</td><td>parameter1</td><td>String</td><td colspan="2">optional (default="Hello")</td>\n'
          '<tr><td>parameter:</td><td>parameter2</td><td>double</td><td colspan="2">mandatory</td>\n'
          '<tr><td>parameter:</td><td>parameter3</td><td>boolean</td><td colspan="2">mandatory</td>\n'
          '</table>';

      then('parseResult.errors.length should be 0',
          () => parseResult.errors.length.should.be(0));
      when('calling: engine.render(parseResult)', () {
        var renderResult = engine.render(parseResult);

        then('renderResult.text be: "$expected"',
            () => renderResult.text.should.be(expected));
      });
    });
  });
}

class DummyFunctionGroup extends FunctionGroup {
  DummyFunctionGroup() : super('Test Functions', [DummyFunction()]);
}

class DummyFunction extends ExpressionFunction {
  DummyFunction()
      : super(
            name: 'testFunction',
            description: 'TestDescription',
            parameters: [
              Parameter<String>(
                  name: 'parameter1',
                  presence: Presence.optionalWithDefaultValue('Hello')),
              Parameter<double>(name: 'parameter2'),
              Parameter<bool>(name: 'parameter3')
            ],
            function: (renderContext, parameters) => 'Dummy');
}
