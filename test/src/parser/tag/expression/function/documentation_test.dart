import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:petitparser/petitparser.dart';
import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

void main() {
  given('Template engine', () {
    var engine = TemplateEngine();
    // simplifying the engine so we have less documentation to check.
    engine.functionGroups.clear();
    engine.functionGroups
        .addAll([DocumentationFunctions(), DummyFunctionGroup()]);
    engine.dataTypes.clear();
    engine.dataTypes.add(Boolean());

    when(
        "call: engine.parse(const "
        "TextTemplate('{{tagDocumentation()}}'))", () {
      then('parseResult.errorMessage should be empty', () async {
        var parseResult = await engine.parseText('{{tagDocumentation()}}');
        parseResult.errorMessage.should.beNullOrEmpty();
      });
      when('calling: await engine.render(parseResult)', () {
        var expected = '<table id="tag-expression-tag">\n'
            '<tr><th colspan="2">ExpressionTag</th></tr>\n'
            '<tr><td>description:</td><td>Evaluates an expression that can contain:<br>* Data Types (e.g. boolean, number or String)<br>* Constants (e.g. pi)<br>* Variables (e.g. person.name )<br>* Operators (e.g. + - * /)<br>* Functions (e.g. cos(7) )<br>* or any combination of the above</td></tr>\n'
            '<tr><td>expression example:</td><td colspan="4">The volume of a sphere = {{ round( (3/4) * pi * (radius ^ 3) )}}.</td></tr>\n'
            '<tr><td>code example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/tag_expression_parser_test.dart">tag_expression_parser_test.dart</a></td></tr>\n'
            '</table>\n';

        then('renderResult.text be: "$expected"', () async {
          var parseResult = await engine.parseText('{{tagDocumentation()}}');
          var renderResult = await engine.render(parseResult);
          renderResult.text.should.be(expected);
        });
      });
    });

    when(
        "call: engine.parse(const "
        "TextTemplate('{{dataTypeDocumentation()}}'))", () {
      var template = TextTemplate('{{dataTypeDocumentation()}}');
      var expected = '<table id="data-type-boolean">\n'
          '<tr><th colspan="2">Boolean</th></tr>\n'
          '<tr><td>description:</td><td>A form of data with only two possible values: true or false</td></tr>\n'
          '<tr><td>syntax:</td><td>A boolean is declared with the word true or false. The letters are case insensitive.</td></tr>\n'
          '<tr><td>example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/data_type/bool_test.dart">bool_test.dart</a></td></tr>\n'
          '</table>\n';

      then('parseResult.errorMessage should be empty', () async {
        var parseResult = await engine.parseTemplate(template);
        parseResult.errorMessage.should.beNullOrEmpty();
      });

      when('calling: await engine.render(parseResult)', () {
        then('renderResult.errorMessage should be empty', () async {
          var parseResult = await engine.parseTemplate(template);
          var renderResult = await engine.render(parseResult);
          renderResult.errorMessage.should.beNullOrEmpty();
        });
        then('renderResult.text be: "$expected"', () async {
          var parseResult = await engine.parseTemplate(template);
          var renderResult = await engine.render(parseResult);
          renderResult.text.should.be(expected);
        });
      });
    });

    when(
        "call: engine.parse(const "
        "TextTemplate('{{functionDocumentation()}}'))", () {
      var template = TextTemplate('{{functionDocumentation()}}');

      then('parseResult.errorMessage should be empty', () async {
        var parseResult = await engine.parseTemplate(template);
        parseResult.errorMessage.should.beNullOrEmpty();
      });
      when('calling: await engine.render(parseResult)', () {
        then('renderResult.text be the documentation function result',
            () async {
          var parseResult = await engine.parseTemplate(template);
          var renderResult = await engine.render(parseResult);
          var expected = await FunctionDocumentation().function(
              '',
              RenderContext(
                  engine: engine,
                  templateBeingRendered: template,
                  parsedTemplates: []),
              {'titleLevel': 1});
          renderResult.text.should.be(expected);
        });
      });
    });
  });

  test('example documentation should contain existing urls only', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{exampleDocumentation()}}');
    parseResult.errorMessage.should.beNullOrEmpty();
    var renderResult = await engine.render(parseResult);
    var text = renderResult.text;
    var urls = urlParser().allMatches(text);
    urls.should.not.beEmpty();
    final noneExistingUrls = <String>[];
    await Future.forEach(urls, (url) async {
      if (!await urlExists(url)) {
        noneExistingUrls.add(url);
      }
    });
    noneExistingUrls.should.beEmpty();
  });

  group('HtmlElementId class', () {
    group('validate method', () {
      test('should accept valid IDs', () {
        final validIds = [
          'a',
          'header1',
          'main-content',
          'footer_section',
          'nav.menu',
          'A1-b_c.d'
        ];
        Should.satisfyAllConditions([
          for (var id in validIds)
            () => Should.notThrowError(() => HtmlElementId.validate(id)),
        ]);
      });

      test('should reject invalid IDs', () {
        final invalidIds = [
          '',
          '1startWithDigit',
          '-dashStart',
          '_underscoreStart',
          '.dotStart',
          'has space',
          'has@symbol',
          'has#hash',
          'white space'
        ];

        Should.satisfyAllConditions([
          for (var id in invalidIds)
            () => Should.throwError<ArgumentError>(
                () => HtmlElementId.validate(id)),
        ]);
      });
    });

    group('normalize method', () {
      test('should normalize and validate valid input', () {
        final input = 'Main Content';
        final normalized = HtmlElementId.normalize(input);
        normalized.should.be('main-content');
      });

      test('should remove invalid characters and normalize', () {
        final input = 'Header@# !Section';
        final normalized = HtmlElementId.normalize(input);
        normalized.should.be('header-section');
      });

      test('should throw if normalization results in invalid ID', () {
        // Will be stripped to '123', which is invalid
        Should.throwError<ArgumentError>(
            () => HtmlElementId.normalize('123@#'));
      });
    });

    group('constructor', () {
      test('should create instance with normalized ID', () {
        final element = HtmlElementId.fromText('Main Content');
        Should.satisfyAllConditions([
          () => element.id.should.be('main-content'),
          () => element.toString().should.be('main-content'),
        ]);
      });
    });
  });
}

Parser<String> urlParser() =>
    ((stringIgnoreCase('https://') | stringIgnoreCase('http://')) &
            (letter() | digit() | char('-') | pattern('\$_.+! *\'(),/&?=: %'))
                .plus())
        .flatten();

Future<bool> urlExists(String url) async {
  final response = await http.get(Uri.parse(url));
  return response.statusCode == 200;
}

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
