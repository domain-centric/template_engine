import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('readSource from relative ProjectFilePath', () {
    var source = 'test/src/parser/tag/expression/function/import/person.yaml';
    var text = readSource(source);
    text.should.contain('person');
    text.should.contain('name');
    text.should.contain(':');
    text.should.contain('John Doe');
    text.should.contain('age');
    text.should.contain('child');
    text.should.contain('Jane Doe');
  });

  test('readSource from absolute file path (in style of operating system)', () {
    var source = ProjectFilePath(
            'test/src/parser/tag/expression/function/import/person.yaml')
        .file
        .absolute
        .path;
    var text = readSource(source);
    text.should.contain('person');
    text.should.contain('name');
    text.should.contain(':');
    text.should.contain('John Doe');
    text.should.contain('age');
    text.should.contain('child');
    text.should.contain('Jane Doe');
  });

  test('readSource with Uri', () {
    var source = ProjectFilePath(
            'test/src/parser/tag/expression/function/import/person.yaml')
        .file
        .absolute
        .uri
        .toString();
    var text = readSource(source);
    text.should.contain('person');
    text.should.contain('name');
    text.should.contain(':');
    text.should.contain('John Doe');
    text.should.contain('age');
    text.should.contain('child');
    text.should.contain('Jane Doe');
  });

  test('readSource with file Uri', () {
    var source = ProjectFilePath(
            'test/src/parser/tag/expression/function/import/person.yaml')
        .file
        .absolute
        .uri
        .toString();
    var text = readSource(source);
    text.should.contain('person');
    text.should.contain('name');
    text.should.contain(':');
    text.should.contain('John Doe');
    text.should.contain('age');
    text.should.contain('child');
    text.should.contain('Jane Doe');
  });

  test('readSource with http Uri', () {
    var source =
        'https://raw.githubusercontent.com/domain-centric/template_engine/main/test/src/parser/tag/expression/function/import/person.yaml';
    var text = readSource(source);
    text.should.contain('TODO');
    // text.should.contain('person');
    // text.should.contain('name');
    // text.should.contain(':');
    // text.should.contain('John Doe');
    // text.should.contain('age');
    // text.should.contain('child');
    // text.should.contain('Jane Doe');
  });
}
