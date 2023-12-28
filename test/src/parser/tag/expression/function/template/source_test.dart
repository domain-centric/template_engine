import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('readSource from relative ProjectFilePath (or URI)', () async {
    var source = 'test/src/parser/tag/expression/function/import/person.yaml';
    var text = await readSource(source);
    text.should.contain('person');
    text.should.contain('name');
    text.should.contain(':');
    text.should.contain('John Doe');
    text.should.contain('age');
    text.should.contain('child');
    text.should.contain('Jane Doe');
  });

  test('readSource from URI with FILE schema', () async {
    var source = ProjectFilePath(
            'test/src/parser/tag/expression/function/import/person.yaml')
        .file
        .absolute
        .uri
        .toString();
    var text = await readSource(source);
    text.should.contain('person');
    text.should.contain('name');
    text.should.contain(':');
    text.should.contain('John Doe');
    text.should.contain('age');
    text.should.contain('child');
    text.should.contain('Jane Doe');
  });

  test('readSource with absolute file path (in style of operating system)',
      () async {
    var source = ProjectFilePath(
            'test/src/parser/tag/expression/function/import/person.yaml')
        .file
        .absolute
        .path;
    var text = await readSource(source);
    text.should.contain('person');
    text.should.contain('name');
    text.should.contain(':');
    text.should.contain('John Doe');
    text.should.contain('age');
    text.should.contain('child');
    text.should.contain('Jane Doe');
  });

  test('readSource with URI with HTTPS schema', () async {
    var source =
        'https://raw.githubusercontent.com/domain-centric/template_engine/'
        'main/test/src/parser/tag/expression/function/import/person.yaml';
    var text = await readSource(source);
    text.should.contain('person');
    text.should.contain('name');
    text.should.contain(':');
    text.should.contain('John Doe');
    text.should.contain('age');
    text.should.contain('child');
    text.should.contain('Jane Doe');
  });

  test('readSource with URI with HTTPS schema to none existing host', () async {
    try {
      await readSource('https://none_existing.com');
      throw Exception('Should have failed');
    } on Exception catch (e) {
      e.toString().should.contain("Failed host lookup: 'none_existing.com'");
    }
  });

  test('readSource with URI with HTTPS schema to a none existing page',
      () async {
    try {
      await readSource('https://your-site.webflow.io/does-not-exist');
      throw Exception('Should have failed');
    } on Exception catch (e) {
      e
          .toString()
          .should
          .contain("Error reading: https://your-site.webflow.io/does-not-exist,"
              " status code: 404");
    }
  });

  test('readSource with of a none existing file path', () async {
    try {
      await readSource('none_existing.file');
      throw Exception('Should have failed');
    } on Exception catch (e) {
      e.toString().should.contain("Error reading: none_existing.file, "
          "PathNotFoundException: Cannot open file");
    }
  });
}
