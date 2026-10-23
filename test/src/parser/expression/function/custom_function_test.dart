import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  var grammar = Grammar.standard().withAdditionalFunctionGroups([
    FunctionGroup('Greeting', [greetingWithParameter]),
  ]);
  var engine = TemplateEngine(grammar);
  test("'{{greeting()}}.' should render: 'Hello world.'", () async {
    var parseResult = await engine.parseText('{{greeting()}}.');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('Hello world.');
  });

  test(
    "'{{greeting(\"Jane Doe\")}}.' should render: 'Hello Jane Doe.'",
    () async {
      var parseResult = await engine.parseText('{{greeting("Jane Doe")}}.');
      var renderResult = await engine.render(parseResult);
      renderResult.text.should.be('Hello Jane Doe.');
    },
  );
}

final greetingWithParameter = FunctionDefinition<String>(
  name: 'greeting',
  documentation: FunctionDefinitionDocumentation(
    description: 'Shows a greeting using attribute: name',
    examples: [],
  ),
  parameters: [
    Parameter(
      name: "name",
      presence: PresenceOptionalWithDefaultValue('world'),
    ),
  ],
  function: (context) {
    var value = context.argumentValues['name'];
    return Future.value('Hello $value');
  },
);
