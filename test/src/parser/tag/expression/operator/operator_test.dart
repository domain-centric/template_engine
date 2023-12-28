import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  given('TemplateEngine()', () {
    var engine = TemplateEngine();

    when('parsing and rendering: "{{false & 3}}"', () async {
      var parseResult = engine.parseTemplate(TextTemplate("{{false & 3}}"));
      var renderResult = await engine.render(parseResult);
      var expected = 'Render error in: \'{{false & 3}}\':\n'
          '  1:9: right of the & operator must be a boolean, '
          'or left and right of the & operator must be a String';
      then('renderResult.errorMessage should be: $expected',
          () => renderResult.errorMessage.should.be(expected));
    });

    when('parsing and rendering: "{{2 & true}}"', () async {
      var parseResult = engine.parseTemplate(TextTemplate("{{2 & true}}"));
      var renderResult = await engine.render(parseResult);
      var expected = 'Render error in: \'{{2 & true}}\':\n'
          '  1:5: left of the & operator must be a boolean, '
          'or left and right of the & operator must be a String';
      then('renderResult.errorMessage should be: $expected',
          () => renderResult.errorMessage.should.be(expected));
    });

    when('parsing and rendering: "{{2 & 3}}"', () async {
      var parseResult = engine.parseTemplate(TextTemplate("{{2 & 3}}"));
      var renderResult = await engine.render(parseResult);
      var expected = 'Render error in: \'{{2 & 3}}\':\n'
          '  1:5: left and right of the & operator must be a boolean, '
          'or left and right of the & operator must be a String';
      then('renderResult.errorMessage should be: $expected',
          () => renderResult.errorMessage.should.be(expected));
    });

    when('parsing and rendering: "{{4 + true}}"', () async {
      var parseResult = engine.parseTemplate(TextTemplate("{{4 + true}}"));
      var renderResult = await engine.render(parseResult);
      var expected = 'Render error in: \'{{4 + true}}\':\n'
          '  1:5: right of the + operator must be a number, '
          'or left and right of the + operator must be a String';
      then('renderResult.errorMessage should be: $expected',
          () => renderResult.errorMessage.should.be(expected));
    });

    when('parsing and rendering: "{{false - 4}}"', () async {
      var parseResult = engine.parseTemplate(TextTemplate("{{false - 4}}"));
      var renderResult = await engine.render(parseResult);
      var expected = 'Render error in: \'{{false - 4}}\':\n'
          '  1:9: left of the - operator must be a number';
      then('renderResult.errorMessage should be: $expected',
          () => renderResult.errorMessage.should.be(expected));
    });

    when('parsing and rendering: "{{true - \'String\'"}}', () async {
      var parseResult =
          engine.parseTemplate(TextTemplate("{{true - 'String'}}"));
      var renderResult = await engine.render(parseResult);
      var expected = 'Render error in: \'{{true - \'String\'}}\':\n'
          '  1:8: left and right of the - operator must be a number';
      then('renderResult.errorMessage should be: $expected',
          () => renderResult.errorMessage.should.be(expected));
    });
  });
}
