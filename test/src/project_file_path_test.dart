import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('ProjectFilePath should start with a slash', () async {
    Should.throwException(() => ProjectFilePath('test')).toString().should.be(
        'Exception: Invalid project file path: "/" expected at position: 0');
  });

  test('ProjectFilePath should contain a valid file name', () async {
    Should.throwException(() => ProjectFilePath('/f@lder/file'))
        .toString()
        .should
        .be('Exception: Invalid project file path: '
            'end of input expected at position: 2');
  });
  test('ProjectFilePath should contain a valid folder name', () async {
    Should.throwException(() => ProjectFilePath('/folder/f@le'))
        .toString()
        .should
        .be('Exception: Invalid project file path: '
            'end of input expected at position: 9');
  });

  test('ProjectFilePath should exist', () async {
    Should.throwException(() => ProjectFilePath('/folder/file'))
        .toString()
        .should
        .startWith('Exception: Project file path does not exist: ');
  });

  test('ProjectFilePath in root should be fine', () async {
    Should.notThrowException(() => ProjectFilePath('/README.md'));
  });

  test('ProjectFilePath in a folder should be fine', () async {
    Should.notThrowException(
        () => ProjectFilePath('/lib/src/template_engine.dart'));
  });

  test('ProjectFilePath.file should be the correct file', () async {
    ProjectFilePath('/README.md').file.path.should.contain('README.md');
  });

  test('ProjectFilePath.fileName should be the correct file', () async {
    ProjectFilePath('/README.md').fileName.should.be('README.md');
  });

  test('ProjectFilePath.githubUri should be the correct URI', () async {
    ProjectFilePath('/README.md').githubUri.toString().should.be(
        'https://github.com/domain-centric/template_engine/blob/main/README.md');
  });

  test('ProjectFilePath.githubMarkdownLink should be the correct URI',
      () async {
    ProjectFilePath('/README.md').githubMarkdownLink.should.be('[README.md]'
        '(https://github.com/domain-centric/'
        'template_engine/blob/main/README.md)');
  });
}
