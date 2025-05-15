import 'package:test/test.dart';
import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  group('expressionParser(ParserContext()).end()', () {
    final engine = TemplateEngine();
    final template = TextTemplate('');
    final parser = expressionParser(ParserContext(engine, template));
    final context = RenderContext(
      engine: engine,
      templateBeingRendered: template,
      parsedTemplates: [],
    );

    test('should parse and render string literal', () async {
      final parseResult = parser.parse("'Hello'");
      final renderResult = (await parseResult.value.render(context));
      Should.satisfyAllConditions([
        () => parseResult.value.should.beAssignableTo<Expression<String>>(),
        () => renderResult.should.be('Hello'),
      ]);
    });

    test('should parse and render numeric literal', () async {
      final parseResult = parser.parse("123.45");
      var renderResult = (await parseResult.value.render(context));
      Should.satisfyAllConditions([
        () => renderResult.should.beAssignableTo<double>(),
        () => (renderResult as num).should.beCloseTo(123.45, delta: 0.001),
      ]);
    });

    test('should parse and render function call: length(\'Hello\')', () async {
      final parseResult = parser.parse("length('Hello')");
      var renderResult = await parseResult.value.render(context);
      Should.satisfyAllConditions([
        () => parseResult.value.should.beAssignableTo<Expression>(),
        () => (renderResult as num).should.be(5),
      ]);
    });

    test('should parse and render expression: length(\'Hello\') + 3', () async {
      final parseResult = parser.parse("length('Hello')+3");
      var renderResult = await parseResult.value.render(context);

      Should.satisfyAllConditions([
        () => parseResult.value.should.beAssignableTo<Expression>(),
        () => (renderResult as num).should.be(8),
      ]);
    });
  });
}
