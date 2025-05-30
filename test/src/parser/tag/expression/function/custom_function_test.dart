import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  var engine = TemplateEngine();
  engine.functionGroups.add(
    FunctionGroup('Greeting', [GreetingWithParameter()]),
  );
  test("'{{greeting()}}.' should render: 'Hello world.'", () async {
    var parseResult = await engine.parseText('{{greeting()}}.');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('Hello world.');
  });

  test(
    "'{{greeting(\"Jane Doe\")}}.' should render: 'Hello Jane Doe.'",
    () async {
      var engine = TemplateEngine();
      engine.functionGroups.add(
        FunctionGroup('Greeting', [GreetingWithParameter()]),
      );
      var parseResult = await engine.parseText('{{greeting("Jane Doe")}}.');
      var renderResult = await engine.render(parseResult);
      renderResult.text.should.be('Hello Jane Doe.');
    },
  );
}

class GreetingWithParameter extends ExpressionFunction<String> {
  GreetingWithParameter()
    : super(
        name: 'greeting',
        description: 'A tag that shows a greeting using attribute: name',
        parameters: [
          Parameter(
            name: "name",
            presence: Presence.optionalWithDefaultValue('world'),
          ),
        ],
        function: (position, renderContext, parameters) =>
            Future.value('Hello ${parameters['name']}'),
      );
}
