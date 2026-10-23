import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('Test parse and render errors in imported template', () async {
    var engine = TemplateEngine();
    var templatePath =
        'test/src/parser/expression/function/import/import_template_with_errors1.md.template';

    var template = FileTemplate.fromFilePath(templatePath);
    var parseResult = await engine.parseTemplate(template);
    var renderResult = await engine.render(parseResult);
    Should.satisfyAllConditions([
      () => renderResult.errors.should.haveCount(4),
      () => renderResult.aggregatedErrorMessage.shouldBeLongString(
        'Errors in: test/src/parser/expression/function/import/import_template_with_errors1.md.template\n'
        '  Parse error:\n'
        '    3:35 - Unexpected code block end delimiter `}}` without preceding start delimiter `{{`\n'
        '  Render errors:\n'
        '    1:3 - Error importing template: Error reading: test/src/parser/expression/function/import/none_existing.file, PathNotFoundException: Cannot open file, path = \'test\\src\\parser\\expression\\function\\import\\none_existing.file\' (OS Error: The system cannot find the file specified, errno = 2)\n'
        '    2:3 - Render errors in imported template: test/src/parser/expression/function/import/import_template_with_errors2.md.template\n'
        '      1:3 - Error importing template: Error reading: test/src/parser/expression/function/import/none_existing.file, PathNotFoundException: Cannot open file, path = \'test\\src\\parser\\expression\\function\\import\\none_existing.file\' (OS Error: The system cannot find the file specified, errno = 2)\n'
        '      2:3 - Render errors in imported template: test/src/parser/expression/function/import/import_template_with_errors3.md.template\n'
        '        1:3 - Error importing template: Error reading: /invalid.path, PathNotFoundException: Cannot open file, path = \'\\invalid.path\' (OS Error: The system cannot find the file specified, errno = 2)\n'
        '        2:12 - Variable `name` does not exist\n'
        '      3:12 - Variable `name` does not exist\n'
        '    3:12 - Variable `name` does not exist\n'
        'Error in imported: test/src/parser/expression/function/import/import_template_with_errors2.md.template\n'
        '  Parse error:\n'
        '    3:35 - Unexpected code block end delimiter `}}` without preceding start delimiter `{{`\n'
        'Error in imported: test/src/parser/expression/function/import/import_template_with_errors3.md.template\n'
        '  Parse error:\n'
        '    2:35 - Unexpected code block end delimiter `}}` without preceding start delimiter `{{`',
      ),
      () => renderResult.text.shouldBeLongString(
        '{{ERROR}}\r\n'
        '{{ERROR}}\r\n'
        '{{ERROR}}\r\n'
        '3: Hello {{ERROR}}. This is wrong: }}\r\n'
        '2: Hello {{ERROR}}. This is wrong: }}\r\n'
        '1: Hello {{ERROR}}. This is wrong: }}',
      ),
    ]);
  });
}

extension LongStringExtensions on String {
  void shouldBeLongString(String expected) {
    if (this == expected) {
      return;
    }

    final index = _firstDifference(this, expected);
    final (row, column) = _rowAndColumn(expected, index);

    final expectedChar = index < expected.length ? expected[index] : null;
    final actualChar = index < length ? this[index] : null;

    throw ShouldlyTestFailureError('''
Strings differ at row $row, column $column, character $index.

Expected: ${_formatChar(expectedChar)}
Actual:   ${_formatChar(actualChar)}
''');
  }

  static int _firstDifference(String actual, String expected) {
    final minLength = actual.length < expected.length
        ? actual.length
        : expected.length;

    for (var i = 0; i < minLength; i++) {
      if (actual[i] != expected[i]) {
        return i;
      }
    }

    return minLength;
  }

  static (int, int) _rowAndColumn(String text, int index) {
    var row = 1;
    var column = 1;

    for (var i = 0; i < index && i < text.length; i++) {
      if (text[i] == '\n') {
        row++;
        column = 1;
      } else {
        column++;
      }
    }

    return (row, column);
  }

  static String _formatChar(String? value) {
    if (value == null) {
      return '<end of string>';
    }

    final code = value.codeUnitAt(0);

    if (RegExp(r'^[a-zA-Z0-9]$').hasMatch(value)) {
      return "'$value'";
    }

    return 'ASCII $code';
  }
}
