import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  given('TemplateEngine()', () {
    var engine = TemplateEngine();

    when('parsing and rendering: "{{false & 3}}"', () {
      var parseResult = engine.parse(const TextTemplate("{{false & 3}}"));
      var renderResult = engine.render(parseResult);
      var expected = 'Render Error: right of the & operator must be a boolean, '
          'or left and right of the & operator must be a String, '
          'position: 1:9, source: Text';
      then('renderResult.errorMessage should be: $expected',
          () => renderResult.errorMessage.should.be(expected));
    });

    when('parsing and rendering: "{{2 & true}}"', () {
      var parseResult = engine.parse(const TextTemplate("{{2 & true}}"));
      var renderResult = engine.render(parseResult);
      var expected = 'Render Error: left of the & operator must be a boolean, '
          'or left and right of the & operator must be a String, '
          'position: 1:5, source: Text';
      then('renderResult.errorMessage should be: $expected',
          () => renderResult.errorMessage.should.be(expected));
    });

    when('parsing and rendering: "{{2 & 3}}"', () {
      var parseResult = engine.parse(const TextTemplate("{{2 & 3}}"));
      var renderResult = engine.render(parseResult);
      var expected = 'Render Error: left and right of the & operator must be '
          'a boolean, or left and right of the & operator must be a String, '
          'position: 1:5, source: Text';
      then('renderResult.errorMessage should be: $expected',
          () => renderResult.errorMessage.should.be(expected));
    });

    when('parsing and rendering: "{{4 + true}}"', () {
      var parseResult = engine.parse(const TextTemplate("{{4 + true}}"));
      var renderResult = engine.render(parseResult);
      var expected = 'Render Error: right of the + operator must be a number, '
          'or left and right of the + operator must be a String, '
          'position: 1:5, source: Text';
      then('renderResult.errorMessage should be: $expected',
          () => renderResult.errorMessage.should.be(expected));
    });

    when('parsing and rendering: "{{false - 4}}"', () {
      var parseResult = engine.parse(const TextTemplate("{{false - 4}}"));
      var renderResult = engine.render(parseResult);
      var expected = 'Render Error: left of the - operator must be a number, '
          'position: 1:9, source: Text';
      then('renderResult.errorMessage should be: $expected',
          () => renderResult.errorMessage.should.be(expected));
    });

    when('parsing and rendering: "{{true - \'String\'"}}', () {
      var parseResult = engine.parse(const TextTemplate("{{true - 'String'}}"));
      var renderResult = engine.render(parseResult);
      var expected = 'Render Error: left and right of the - operator '
          'must be a number, position: 1:8, source: Text';
      then('renderResult.errorMessage should be: $expected',
          () => renderResult.errorMessage.should.be(expected));
    });
  });
}
