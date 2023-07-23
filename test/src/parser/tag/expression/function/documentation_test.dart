import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  given('Template engine', () {
    var engine = TemplateEngine();
    // simplifying the engine so we have less documentation to check.
    engine.functionGroups.clear();
    engine.functionGroups
        .addAll([DocumentationFunctions(), DummyFunctionGroup()]);
    engine.baseTypes.clear();
    engine.baseTypes.add(Boolean());

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
        "TextTemplate('{{engine.baseType.documentation()}}'))", () {
      var parseResult = engine
          .parse(const TextTemplate('{{engine.baseType.documentation()}}'));
      var expected = '<table>\n'
          '<tr><th colspan="2">Boolean</th></tr>\n'
          '<tr><td>description:</td><td>a form of data with only two possible values :"true" and "false"</td></tr>\n'
          '<tr><td>examples:</td><td>true<br>\n'
          'TRUE<br>\n'
          'TRue<br>\n'
          'false<br>\n'
          'FALSE<br>\n'
          'FAlse</td></tr>\n'
          '</table>\n';

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
      var expected = FunctionDocumentation()
          .function(RenderContext(engine), {'titleLevel': 1});

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
