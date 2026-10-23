import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  var grammar = Grammar.standard().withAdditionalMethods([
    MethodDefinition<int, bool>(
      name: 'isEven',
      description: 'Checks if a number is even',
      parameters: [],
      examples: [],
      method: (context) {
        var intValue = context.owner;
        return Future.value(intValue % 2 == 0);
      },
    ),
    MethodDefinition<int, bool>(
      name: 'isEqual',
      description: 'Checks if a number is equal to another number',
      parameters: [
        Parameter<int>(name: 'other', presence: PresenceMandatory()),
      ],
      examples: [],
      method: (context) =>
          Future.value(context.owner == context.argumentValues['other']),
    ),
  ]);
  var engine = TemplateEngine(grammar);
  test("{{3.isEven()}} should render: false", () async {
    var parseResult = await engine.parseText('{{3.isEven()}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('false');
  });

  test("{{4.isEven()}} should render: false", () async {
    var parseResult = await engine.parseText('{{4.isEven()}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('true');
  });

  test("{{4.IsEven()}} should render: true", () async {
    var parseResult = await engine.parseText('{{4.IsEven()}}');
    var renderResult = await engine.render(parseResult);
    renderResult.text.should.be('true');
  });

  test('invalid method arguments should produce a render error', () async {
    var parseResult = await engine.parseText('{{3.isEqual(unknown: 1)}}');
    var renderResult = await engine.render(parseResult);

    Should.satisfyAllConditions([
      () => renderResult.parserErrors.length.should.be(1),
      () => renderResult.parserErrors.first.message.should.be(
        'Invalid argument syntax',
      ),
      () => renderResult.parserErrors.first.location.should.be(
        TemplateLocation(1, 20),
      ),
      () => renderResult.renderErrors.length.should.be(1),
      () => renderResult.renderErrors.first.message.should.be(
        'Variable `unknown` does not exist',
      ),
      () => renderResult.text.should.be('{{ERROR}}'),
    ]);
  });
}
