import 'dart:io';

import 'package:test/test.dart';
import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  group('Documentation functions', () {
    final engine = TemplateEngine();

    test('should render codeBlockDocumentation() correctly', () async {
      final parseResult = await engine.parseText(
        '{{codeBlockDocumentation()}}',
      );
      final renderResult = await engine.render(parseResult);
      Should.satisfyAllConditions([
        () => parseResult.errors.should.beEmpty(),
        () => renderResult.text.should.contain('# Statements'),
        () => renderResult.text.should.contain('## Comment statement'),
        () => renderResult.text.should.contain('# Expressions'),
        () => renderResult.text.should.contain('<table>'),
      ]);
    });

    test('should render dataTypeDocumentation() correctly', () async {
      final template = TextTemplate('{{dataTypeDocumentation()}}');
      final parseResult = await engine.parseTemplate(template);

      Should.satisfyAllConditions([() => parseResult.errors.should.beEmpty()]);

      final renderResult = await engine.render(parseResult);

      Should.satisfyAllConditions([
        () => renderResult.errors.should.beEmpty(),
        () => renderResult.text.should.contain(
          '[data type](https://en.wikipedia.org/wiki/Data_type)',
        ),
        () => renderResult.text.should.contain('## Boolean\n'),
        () => renderResult.text.should.contain('## String\n'),
        () => renderResult.text.should.contain('## Number\n'),
      ]);
    });

    test('should render functionDocumentation() correctly', () async {
      final template = TextTemplate('{{functionDocumentation()}}');
      final parseResult = await engine.parseTemplate(template);

      final renderResult = await engine.render(parseResult);

      Should.satisfyAllConditions([
        () => renderResult.errors.should.beEmpty(),
        () => renderResult.text.should.contain(
          '[function](https://en.wikipedia.org/wiki/Function_(computer_programming))',
        ),
        () => renderResult.text.should.contain('# Parameters and Arguments'),
        () => renderResult.text.should.contain('# Math Functions'),
        () => renderResult.text.should.contain('## exp Function'),
        () => renderResult.text.should.contain('<table>'),
        () => renderResult.text.should.contain('# Custom Functions'),
      ]);
    });
  });

  test('example documentation should contain existing urls only', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('{{exampleDocumentation()}}');
    parseResult.errors.should.beEmpty();
    var renderResult = await engine.render(parseResult);
    var text = renderResult.text;
    var urlMatches = urlParser().allMatches(text);
    final errors = <String>[];
    for (final urlMatch in urlMatches) {
      Uri? uri;
      try {
        uri = Uri.parse(urlMatch.group(0)!);
        if (!uri.hasScheme || !uri.hasAuthority) {
          errors.add('Invalid URI structure: $urlMatch');
          continue;
        }
      } catch (_) {
        errors.add('Invalid URI format: $urlMatch');
        continue;
      }
      var filePath = uri
          .toString()
          .replaceAll('$templateEngineGitHubBlobMainUri/', '')
          .replaceAll(RegExp('%22.*'), '');
      var exists = File(filePath).existsSync();
      if (!exists) {
        errors.add(
          'File does not exist: $templateEngineGitHubBlobMainUri/$filePath',
        );
      }
    }
    errors.should.beEmpty();
  });
}

Pattern urlParser() => RegExp(r'https?://[^\s)]+', caseSensitive: false);

// Parser<String> urlParser() =>
//     ((string('https://', ignoreCase: true) |
//                 string('http://', ignoreCase: true)) &
//             (letter() | digit() | char('-') | pattern('\$_.+! *\'(),/&?=: %'))
//                 .plus())
//         .flatten();

// class DummyFunctionGroup extends FunctionGroup {
//   DummyFunctionGroup() : super('Test Functions', [DummyFunction()]);
// }

// class DummyFunction extends ExpressionFunction {
//   DummyFunction()
//     : super(
//         name: 'testFunction',
//         description: 'TestDescription',
//         exampleCode: ProjectFilePath(
//           'test/src/parser/expression/function/math/exp_test.dart',
//         ),
//         parameters: [
//           Parameter<String>(
//             name: 'parameter1',
//             presence: PresenceOptionalWithDefaultValue('Hello'),
//           ),
//           Parameter<double>(name: 'parameter2'),
//           Parameter<bool>(name: 'parameter3'),
//         ],
//         function: (position, renderContext, parameters) =>
//             Future.value('Dummy'),
//       );
// }
