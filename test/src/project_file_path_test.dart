import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test(
    'ProjectFilePath starting with a slash should throw an exception',
    () async {
      Should.throwException(
        () => ProjectFilePath('/test'),
      ).toString().should.be(
        'Exception: Invalid project file path: \'/test\': '
        'letter expected OR digit expected OR "(" expected OR ")"'
        ' expected OR "_" expected OR "-" expected OR "." expected'
        ' at position: 1',
      );
    },
  );

  test('ProjectFilePath "test" should not throw an exception', () async {
    Should.notThrowException(() => ProjectFilePath('test'));
  });

  test('ProjectFilePath should contain a valid file name', () async {
    Should.throwException(
      () => ProjectFilePath('f@lder/file'),
    ).toString().should.be(
      'Exception: Invalid project file path: \'f@lder/file\': '
      'letter expected OR digit expected OR "(" expected OR ")" '
      'expected OR "_" expected OR "-" expected OR "." expected '
      'at position: 2',
    );
  });

  test('ProjectFilePath should contain a valid folder name', () async {
    Should.throwException(
      () => ProjectFilePath('folder/f@le'),
    ).toString().should.be(
      'Exception: Invalid project file path: \'folder/f@le\':'
      ' letter expected OR digit expected OR "(" expected OR ")" '
      'expected OR "_" expected OR "-" expected OR "." '
      'expected at position: 9',
    );
  });

  test('ProjectFilePath in root should be fine', () async {
    Should.notThrowException(() => ProjectFilePath('README.md'));
  });

  test('ProjectFilePath in a folder should be fine', () async {
    Should.notThrowException(
      () => ProjectFilePath('lib/src/template_engine.dart'),
    );
  });

  test('ProjectFilePath.file should be the correct file', () async {
    ProjectFilePath('README.md').file.path.should.contain('README.md');
  });

  test('ProjectFilePath.fileName should be the correct file', () async {
    ProjectFilePath('README.md').fileName.should.be('README.md');
  });

  test('ProjectFilePath.githubUri should be the correct URI', () async {
    ProjectFilePath('README.md').githubUri.toString().should.be(
      'https://github.com/domain-centric/template_engine/blob/main/README.md',
    );
  });

  test(
    'ProjectFilePath.githubMarkdownLink should be the correct URI',
    () async {
      ProjectFilePath('README.md').githubMarkdownLink.should.be(
        '<a href="https://github.com/domain-centric/'
        'template_engine/blob/main/README.md">README.md</a>',
      );
    },
  );
}
