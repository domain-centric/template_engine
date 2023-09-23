import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  var engine = TemplateEngine();
  engine.functionGroups
      .add(FunctionGroup('Greeting', [GreetingWithParameter()]));
  test("'{{greeting()}}.' should render: 'Hello world.'", () {
    var parseResult = engine.parse(TextTemplate('{{greeting()}}.'));
    var renderResult = engine.render(parseResult).text;
    renderResult.should.be('Hello world.');
  });

  test("'{{greeting(\"Jane Doe\")}}.' should render: 'Hello Jane Doe.'", () {
    var engine = TemplateEngine();
    engine.functionGroups
        .add(FunctionGroup('Greeting', [GreetingWithParameter()]));
    var parseResult =
        engine.parse(TextTemplate('{{greeting("Jane Doe")}}.'));
    var renderResult = engine.render(parseResult).text;
    renderResult.should.be('Hello Jane Doe.');
  });
}

class GreetingWithParameter extends ExpressionFunction {
  GreetingWithParameter()
      : super(
          name: 'greeting',
          description: 'A tag that shows a greeting using attribute: name',
          parameters: [
            Parameter(
                name: "name",
                presence: Presence.optionalWithDefaultValue('world'))
          ],
          function: (renderContext, parameters) =>
              'Hello ${parameters['name']}',
        );
}
