import 'dart:math';

import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('Test parse and render errors in imported template', () async {
    var engine = TemplateEngine();
    var templatePath = ProjectFilePath(
        'test/src/parser/tag/expression/function/import/import_template_with_errors1.md.template');
    var template = FileTemplate.fromProjectFilePath(templatePath);
    var parseResult = engine.parseTemplate(template);
    var renderResult = await engine.render(parseResult);
    renderResult.errorMessage.should.contain(
        'Errors in: test/src/parser/tag/expression/function/import/import_template_with_errors1.md.template:\n');
    renderResult.errorMessage.should.contain('  Parse error:\n');
    renderResult.errorMessage.should.contain(
        '    3:35: Found tag end: }}, but it was not preceded with a tag start: {{\n');
    renderResult.errorMessage.should.contain('  Render errors:\n');
    renderResult.errorMessage.should.contain(
        '    1:3: Error importing template: Error reading: test/src/parser/tag/expression/function/import/none_existing.file, PathNotFoundException: Cannot open file, path = ');
    renderResult.errorMessage.should.contain(
        '    2:3: Errors while importing test/src/parser/tag/expression/function/import/import_template_with_errors2.md.template:\n');
    renderResult.errorMessage.should.contain(
        "      1:3: Error importing template: Error reading: test/src/parser/tag/expression/function/import/none_existing.file, PathNotFoundException: Cannot open file, path = ");
    renderResult.errorMessage.should.contain(
        '      2:3: Errors while importing test/src/parser/tag/expression/function/import/import_template_with_errors3.md.template:\n');
    renderResult.errorMessage.should.contain(
        '        1:3: Error importing template: Error reading: /invalid.path, PathNotFoundException: Cannot open file, path = ');
    renderResult.errorMessage.should
        .contain('        2:12: Variable does not exist: name\n');
    renderResult.errorMessage.should
        .contain('      3:12: Variable does not exist: name\n');
    renderResult.errorMessage.should
        .contain('    3:12: Variable does not exist: name\n');
    renderResult.errorMessage.should.contain(
        'Parse error in: test/src/parser/tag/expression/function/import/import_template_with_errors2.md.template:\n');
    renderResult.errorMessage.should.contain(
        '  3:35: Found tag end: }}, but it was not preceded with a tag start: {{\n');
    renderResult.errorMessage.should.contain(
        'Parse error in: test/src/parser/tag/expression/function/import/import_template_with_errors3.md.template:\n');
    renderResult.errorMessage.should.contain(
        '  2:35: Found tag end: }}, but it was not preceded with a tag start: {{');

    const expectedText = '{{ERROR}}\r\n'
        '{{ERROR}}\r\n'
        '{{ERROR}}\r\n'
        '3: Hello {{ERROR}}. This is wrong: }}\r\n'
        '2: Hello {{ERROR}}. This is wrong: }}\r\n'
        '1: Hello {{ERROR}}. This is wrong: }}';
    renderResult.text.should.be(expectedText);
  });
}

stringCompare(String s1, String s2) {
  if (s1 == s2) {
    return 'equal';
  } else {
    int index = 0;
    int line = 1;
    int column = 1;
    int length = min(s1.length, s2.length);
    do {
      if (s1.codeUnitAt(index) != s2.codeUnitAt(index)) {
        return 'Different characters (${s1.codeUnitAt(index)} versus ${s2.codeUnitAt(index)}) at index: $index, line: $line, column: $column';
      } else if (s1.codeUnitAt(index) == 10) {
        line++;
        column = 1;
      }
      index++;
      column++;
    } while (index < length);
    if (s1.length > s2.length) {
      return 's1 has more charters, starting with character: ${s1.codeUnitAt(index)} at index: $index, line: $line, column: $column';
    } else {
      return 's2 has more charters, starting with character: ${s2.codeUnitAt(index)} at index: $index, line: $line, column: $column';
    }
  }
}
