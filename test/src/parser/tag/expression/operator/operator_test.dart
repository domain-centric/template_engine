import 'package:test/test.dart';
import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  group('TemplateEngine operator type errors', () {
    final engine = TemplateEngine();

    test('should error on "{{false & 3}}"', () async {
      final parseResult = await engine.parseText("{{false & 3}}");
      final renderResult = await engine.render(parseResult);

      renderResult.errorMessage.should.be(
        'Render error in: \'{{false & 3}}\':\n'
        '  1:9: right of the & operator must be a boolean, '
        'or left and right of the & operator must be a String',
      );
    });

    test('should error on "{{2 & true}}"', () async {
      final parseResult = await engine.parseText("{{2 & true}}");
      final renderResult = await engine.render(parseResult);

      renderResult.errorMessage.should.be(
        'Render error in: \'{{2 & true}}\':\n'
        '  1:5: left of the & operator must be a boolean, '
        'or left and right of the & operator must be a String',
      );
    });

    test('should error on "{{2 & 3}}"', () async {
      final parseResult = await engine.parseText("{{2 & 3}}");
      final renderResult = await engine.render(parseResult);

      renderResult.errorMessage.should.be(
        'Render error in: \'{{2 & 3}}\':\n'
        '  1:5: left and right of the & operator must be a boolean, '
        'or left and right of the & operator must be a String',
      );
    });

    test('should error on "{{4 + true}}"', () async {
      final parseResult = await engine.parseText("{{4 + true}}");
      final renderResult = await engine.render(parseResult);

      renderResult.errorMessage.should.be(
        'Render error in: \'{{4 + true}}\':\n'
        '  1:5: right of the + operator must be a number, '
        'or left and right of the + operator must be a String',
      );
    });

    test('should error on "{{false - 4}}"', () async {
      final parseResult = await engine.parseText("{{false - 4}}");
      final renderResult = await engine.render(parseResult);

      renderResult.errorMessage.should.be(
        'Render error in: \'{{false - 4}}\':\n'
        '  1:9: left of the - operator must be a number',
      );
    });

    test('should error on "{{true - \'String\'}}"', () async {
      final parseResult = await engine.parseText("{{true - 'String'}}");
      final renderResult = await engine.render(parseResult);

      renderResult.errorMessage.should.be(
        'Render error in: \'{{true - \'String\'}}\':\n'
        '  1:8: left and right of the - operator must be a number',
      );
    });
  });
}
