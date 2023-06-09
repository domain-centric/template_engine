import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  given('expressionParser(ParserContext())', () {
    var parser = expressionParser(ParserContext());
    var context = RenderContext();
    when('calling: parser.parse("\'Hello ")', () {
      var result = parser.parse("'Hello ");

      then('result.isFailure should be true',
          () => result.isFailure.should.beTrue());

      var expected =
          'quoted string expected OR number expected OR boolean expected OR '
          'function expected OR constant expected OR variable expected';
      then('result.message should be: $expected',
          () => result.message.should.be(expected));
    });

    when('calling: parser.parse(\'"Hello \')', () {
      var result = parser.parse('"Hello ');

      then('result.isFailure should be true',
          () => result.isFailure.should.beTrue());

      var expected =
          'quoted string expected OR number expected OR boolean expected OR '
          'function expected OR constant expected OR variable expected';
      then('result.message should be: $expected',
          () => result.message.should.be(expected));
    });

    when('calling: parser.parse("\'Hello\'  ").value.render(context)', () {
      var result = parser.parse("'Hello'  ").value.render(context);
      var expected = "Hello";
      then('result should be: $expected', () => result.should.be(expected));
    });

    when('calling: parser.parse(' "Hello" ').value.render(context)', () {
      var result = parser.parse('  "Hello"').value.render(context);
      var expected = "Hello";
      then('result should be: $expected', () => result.should.be(expected));
    });

    when('calling: parser.parse("\'Hel\' + \'l\' & "o"").value.render(context)',
        () {
      var result = parser.parse("'Hel' + 'l' & \"o\"").value.render(context);
      var expected = "Hello";
      then('result should be: $expected', () => result.should.be(expected));
    });
  });
}
