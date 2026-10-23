import 'package:test/test.dart';
import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  group('TemplateEngine operator type errors', () {
    final engine = TemplateEngine();

    test('should error on "{{false & 3}}"', () async {
      final parseResult = await engine.parseText("{{false & 3}}");
      final renderResult = await engine.render(parseResult);
      Should.satisfyAllConditions([
        () => renderResult.text.should.be('{{ERROR}}'),
        () => renderResult.errors.should.haveCount(1),
        () => renderResult.errors.first.message.should.be(
          'left of the & operator must be a int, '
          'or right of the & operator must be a boolean, '
          'or left and right of the & operator must be a String',
        ),
        () => renderResult.errors.first.location.should.be(
          TemplateLocation(1, 9),
        ),
      ]);
    });

    test('should error on "{{2 & true}}"', () async {
      final parseResult = await engine.parseText("{{2 & true}}");
      final renderResult = await engine.render(parseResult);
      Should.satisfyAllConditions([
        () => renderResult.text.should.be('{{ERROR}}'),
        () => renderResult.errors.should.haveCount(1),
        () => renderResult.errors.first.message.should.be(
          'right of the & operator must be a int, '
          'or left of the & operator must be a boolean, '
          'or left and right of the & operator must be a String',
        ),
        () => renderResult.errors.first.location.should.be(
          TemplateLocation(1, 5),
        ),
      ]);
    });

    test('should error on "{{4 + true}}"', () async {
      final parseResult = await engine.parseText("{{4 + true}}");
      final renderResult = await engine.render(parseResult);
      Should.satisfyAllConditions([
        () => renderResult.text.should.be('{{ERROR}}'),
        () => renderResult.errors.should.haveCount(1),
        () => renderResult.errors.first.message.should.be(
          'right of the + operator must be a number, '
          'or left and right of the + operator must be a String',
        ),
        () => renderResult.errors.first.location.should.be(
          TemplateLocation(1, 5),
        ),
      ]);
    });

    test('should error on "{{false - 4}}"', () async {
      final parseResult = await engine.parseText("{{false - 4}}");
      final renderResult = await engine.render(parseResult);
      Should.satisfyAllConditions([
        () => renderResult.text.should.be('{{ERROR}}'),
        () => renderResult.errors.should.haveCount(1),
        () => renderResult.errors.first.message.should.be(
          'left of the - operator must be a number',
        ),
        () => renderResult.errors.first.location.should.be(
          TemplateLocation(1, 9),
        ),
      ]);
    });

    test('should error on "{{true - \'String\'}}"', () async {
      final parseResult = await engine.parseText("{{true - 'String'}}");
      final renderResult = await engine.render(parseResult);
      Should.satisfyAllConditions([
        () => renderResult.text.should.be('{{ERROR}}'),
        () => renderResult.errors.should.haveCount(1),
        () => renderResult.errors.first.message.should.be(
          'left and right of the - operator must be a number',
        ),
        () => renderResult.errors.first.location.should.be(
          TemplateLocation(1, 8),
        ),
      ]);
    });
  });
}
