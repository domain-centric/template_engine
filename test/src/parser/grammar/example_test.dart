import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  group('ExpressionBlockExample', () {
    test('expression block example formats expected output', () {
      final example = ExpressionBlockExample(
        (delimiter) => '${delimiter.start} 42 ${delimiter.end}',
        shouldRender: '42',
      );
      example
          .toMarkdown(CodeBlockDelimiter.standard())
          .should
          .be("{{ 42 }} should render: '42'");
    });

    test('expression block example with variables formats expected output', () {
      final example = ExpressionBlockExample(
        (delimiter) => '${delimiter.start} x.y ${delimiter.end}',
        variables: {
          'x': {'y': '12'},
        },
        shouldRender: '12',
      );
      example
          .toMarkdown(CodeBlockDelimiter.standard())
          .should
          .be(
            '{{ x.y }}\n'
            'variables: {x: {y: 12}}\n'
            "should render: '12'",
          );
    });
  });

  group('TestFileExample', () {
    test('normalizes Windows path separators to GitHub paths', () {
      TestFileExample.normalizeRelativePath(
        r'src\file.dart',
      ).should.be('src/file.dart');
    });
  });
}
