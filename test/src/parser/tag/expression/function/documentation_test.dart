import 'package:test/test.dart';
import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:http/http.dart' as http;
import 'package:petitparser/petitparser.dart';

void main() {
  group('TemplateEngine Documentation Tags', () {
    final engine = TemplateEngine()
      ..functionGroups.clear()
      ..functionGroups.addAll([DocumentationFunctions(), DummyFunctionGroup()])
      ..dataTypes.clear()
      ..dataTypes.add(Boolean());

    test('should render tagDocumentation() correctly', () async {
      final parseResult = await engine.parseText('{{tagDocumentation()}}');

      Should.satisfyAllConditions([
        () => parseResult.errorMessage.should.beNullOrEmpty(),
      ]);

      final renderResult = await engine.render(parseResult);
      final expected = '# Expression Tag\n'
          '<table>\n'
          '<tr><td>description:</td><td>Evaluates an expression that can contain:<br>* Data Types (e.g. boolean, number or String)<br>* Constants (e.g. pi)<br>* Variables (e.g. person.name )<br>* Operators (e.g. + - * /)<br>* Functions (e.g. cos(7) )<br>* or any combination of the above</td></tr>\n'
          '<tr><td>expression example:</td><td colspan="4">The volume of a sphere = {{ round( (3/4) * pi * (radius ^ 3) )}}.</td></tr>\n'
          '<tr><td>code example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/tag_expression_parser_test.dart">tag_expression_parser_test.dart</a></td></tr>\n'
          '</table>\n';

      renderResult.text.should.be(expected);
    });

    test('should render dataTypeDocumentation() correctly', () async {
      final template = TextTemplate('{{dataTypeDocumentation()}}');
      final parseResult = await engine.parseTemplate(template);

      Should.satisfyAllConditions([
        () => parseResult.errorMessage.should.beNullOrEmpty(),
      ]);

      final renderResult = await engine.render(parseResult);

      Should.satisfyAllConditions([
        () => renderResult.errorMessage.should.beNullOrEmpty(),
        () => renderResult.text.should.contain('## Boolean Data Type\n'),
        () => renderResult.text.should.contain('## String Data Type\n'),
        () => renderResult.text.should.contain('## Number Data Type\n'),
      ]);
    });

    test('should render functionDocumentation() correctly', () async {
      final template = TextTemplate('{{functionDocumentation()}}');
      final parseResult = await engine.parseTemplate(template);

      Should.satisfyAllConditions([
        () => parseResult.errorMessage.should.beNullOrEmpty(),
      ]);

      final renderResult = await engine.render(parseResult);
      final expected = await FunctionDocumentation().function(
        '',
        RenderContext(
          engine: engine,
          templateBeingRendered: template,
          parsedTemplates: [],
        ),
        {'titleLevel': 1},
      );

      renderResult.text.should.be(expected);
    });
  });

  test('example documentation should contain existing urls only', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{exampleDocumentation()}}');
    parseResult.errorMessage.should.beNullOrEmpty();
    var renderResult = await engine.render(parseResult);
    var text = renderResult.text;
    var urls = urlParser().allMatches(text);
    final errors = <String>[];
    for (final url in urls) {
      Uri? uri;
      try {
        uri = Uri.parse(url);
        if (!uri.hasScheme || !uri.hasAuthority) {
          errors.add('Invalid URI structure: $url');
          continue;
        }
      } catch (_) {
        errors.add('Invalid URI format: $url');
        continue;
      }

      try {
        final response = await http.head(uri);
        if (response.statusCode < 200 || response.statusCode >= 400) {
          errors.add('URL "$url" responded with status ${response.statusCode}');
        }
      } catch (e) {
        errors.add('Request to "$url" failed: $e');
      }
    }

    errors.should.beEmpty();
  });
}

Parser<String> urlParser() =>
    ((stringIgnoreCase('https://') | stringIgnoreCase('http://')) &
            (letter() | digit() | char('-') | pattern('\$_.+! *\'(),/&?=: %'))
                .plus())
        .flatten();

class DummyFunctionGroup extends FunctionGroup {
  DummyFunctionGroup() : super('Test Functions', [DummyFunction()]);
}

class DummyFunction extends ExpressionFunction {
  DummyFunction()
      : super(
            name: 'testFunction',
            description: 'TestDescription',
            exampleCode: ProjectFilePath(
                'test/src/parser/tag/expression/function/math/exp_test.dart'),
            parameters: [
              Parameter<String>(
                  name: 'parameter1',
                  presence: Presence.optionalWithDefaultValue('Hello')),
              Parameter<double>(name: 'parameter2'),
              Parameter<bool>(name: 'parameter3')
            ],
            function: (position, renderContext, parameters) =>
                Future.value('Dummy'));
}
