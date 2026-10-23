import 'package:template_engine/template_engine.dart';
import 'package:shouldly/shouldly.dart';
import 'package:test/test.dart';

void main() {
  group('IfStatement', () {
    test('supports if/else/endif blocks', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText(
        '{{ if active }}Yes{{ else }}No{{ endif }}',
      );
      final renderTrue = await engine.render(
        parseResult,
        variables: {'active': true},
      );
      final renderFalse = await engine.render(
        parseResult,
        variables: {'active': false},
      );

      renderTrue.text.should.be('Yes');
      renderFalse.text.should.be('No');
      parseResult.errors.should.beEmpty();
    });
    test('supports if without else', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText(
        '{{ if active }}Yes{{ endif }}',
      );

      final renderTrue = await engine.render(
        parseResult,
        variables: {'active': true},
      );
      final renderFalse = await engine.render(
        parseResult,
        variables: {'active': false},
      );
      Should.satisfyAllConditions([
        () => renderTrue.text.should.be('Yes'),
        () => renderFalse.text.should.be(''),
        () => parseResult.errors.should.beEmpty(),
      ]);
    });

    test('handles extra spaces in statement', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText(
        '{{   if   active   }}Yes{{   else   }}No{{   endif   }}',
      );

      final renderTrue = await engine.render(
        parseResult,
        variables: {'active': true},
      );
      final renderFalse = await engine.render(
        parseResult,
        variables: {'active': false},
      );
      Should.satisfyAllConditions([
        () => renderTrue.text.should.be('Yes'),
        () => renderFalse.text.should.be('No'),
        () => parseResult.errors.should.beEmpty(),
      ]);
    });

    test('handles uppercase keywords', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText(
        '{{ IF active }}Yes{{ ELSE }}No{{ ENDIF }}',
      );

      final renderTrue = await engine.render(
        parseResult,
        variables: {'active': true},
      );
      final renderFalse = await engine.render(
        parseResult,
        variables: {'active': false},
      );
      Should.satisfyAllConditions([
        () => renderTrue.text.should.be('Yes'),
        () => renderFalse.text.should.be('No'),
        () => parseResult.errors.should.beEmpty(),
      ]);
    });

    test('supports nested if statements', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText(
        '{{ if outer }}Outer{{ if inner }}Inner{{ endif }}{{ endif }}',
      );

      final render = await engine.render(
        parseResult,
        variables: {'outer': true, 'inner': true},
      );
      Should.satisfyAllConditions([
        () => render.text.should.be('OuterInner'),
        () => parseResult.errors.should.beEmpty(),
      ]);
    });

    test('supports elseif chains', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText(
        '{{ if a }}A{{ elseif b }}B{{ else }}C{{ endif }}',
      );

      final renderA = await engine.render(
        parseResult,
        variables: {'a': true, 'b': false},
      );
      final renderB = await engine.render(
        parseResult,
        variables: {'a': false, 'b': true},
      );
      final renderC = await engine.render(
        parseResult,
        variables: {'a': false, 'b': false},
      );

      Should.satisfyAllConditions([
        () => renderA.text.should.be('A'),
        () => renderB.text.should.be('B'),
        () => renderC.text.should.be('C'),
        () => parseResult.errors.should.beEmpty(),
      ]);
    });

    test('supports elseif without else', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText(
        '{{ if a }}A{{ elseif b }}B{{ endif }}',
      );

      final renderA = await engine.render(
        parseResult,
        variables: {'a': true, 'b': false},
      );
      final renderB = await engine.render(
        parseResult,
        variables: {'a': false, 'b': true},
      );
      final renderEmpty = await engine.render(
        parseResult,
        variables: {'a': false, 'b': false},
      );

      Should.satisfyAllConditions([
        () => renderA.text.should.be('A'),
        () => renderB.text.should.be('B'),
        () => renderEmpty.text.should.be(''),
        () => parseResult.errors.should.beEmpty(),
      ]);
    });

    test('supports multiple elseif branches', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText(
        '{{ if a }}A{{ elseif b }}B{{ elseif c }}C{{ else }}D{{ endif }}',
      );

      final rA = await engine.render(parseResult, variables: {'a': true});
      final rB = await engine.render(
        parseResult,
        variables: {'a': false, 'b': true},
      );
      final rC = await engine.render(
        parseResult,
        variables: {'a': false, 'b': false, 'c': true},
      );
      final rD = await engine.render(
        parseResult,
        variables: {'a': false, 'b': false, 'c': false},
      );

      Should.satisfyAllConditions([
        () => rA.text.should.be('A'),
        () => rB.text.should.be('B'),
        () => rC.text.should.be('C'),
        () => rD.text.should.be('D'),
        () => parseResult.errors.should.beEmpty(),
      ]);
    });

    test('handles uppercase ELSEIF', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText(
        '{{ IF a }}A{{ ELSEIF b }}B{{ ELSE }}C{{ ENDIF }}',
      );

      final r = await engine.render(
        parseResult,
        variables: {'a': false, 'b': true},
      );
      r.text.should.be('B');
      parseResult.errors.should.beEmpty();
    });

    test('missing endif with elseif produces error', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText('{{ if a }}A{{ elseif b }}B');
      Should.satisfyAllConditions([
        () => parseResult.errors.should.haveCount(1),
        () => parseResult.errors.first.message.should.be(
          'Expected `elseif` or `else` or `endif` before end of template',
        ),
        () => parseResult.errors.first.location.should.be(
          TemplateLocation(1, 26),
        ),
      ]);
    });

    test('renders else branch correctly', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText(
        '{{ if active }}Yes{{ else }}No{{ endif }}',
      );
      final render = await engine.render(
        parseResult,
        variables: {'active': false},
      );
      Should.satisfyAllConditions([
        () => render.text.should.be('No'),
        () => parseResult.errors.should.beEmpty(),
      ]);
    });

    test('missing endif produces error', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText('{{ if active }}Yes');
      Should.satisfyAllConditions([
        () => parseResult.errors.should.haveCount(1),
        () => parseResult.errors.first.message.should.be(
          'Expected `elseif` or `else` or `endif` before end of template',
        ),
        () => parseResult.errors.first.location.should.be(
          TemplateLocation(1, 16),
        ),
      ]);
    });

    test('missing else block still works', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText(
        '{{ if active }}Yes{{ endif }}',
      );

      final render = await engine.render(
        parseResult,
        variables: {'active': false},
      );
      Should.satisfyAllConditions([
        () => render.text.should.be(''),
        () => parseResult.errors.should.beEmpty(),
      ]);
    });

    test('else without endif produces error', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText(
        '{{ if active }}Yes{{ else }}No',
      );
      final renderResult = await engine.render(
        parseResult,
        variables: {'active': true},
      );

      Should.satisfyAllConditions([
        () => parseResult.errors.should.haveCount(1),
        () => parseResult.errors.first.message.should.be(
          'Expected `endif` before end of template',
        ),
        () => parseResult.errors.first.location.should.be(
          TemplateLocation(1, 29),
        ),
        () => renderResult.text.should.be('Yes'),
      ]);
    });

    test('empty if block', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText('{{ if active }}{{ endif }}');

      final render = await engine.render(
        parseResult,
        variables: {'active': true},
      );

      Should.satisfyAllConditions([
        () => render.text.should.be(''),
        () => parseResult.errors.should.beEmpty(),
      ]);
    });

    test('if with complex condition', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText(
        '{{ if user.isActive }}Active{{ else }}Inactive{{ endif }}',
      );

      final render = await engine.render(
        parseResult,
        variables: {
          'user': {'isActive': true},
        },
      );
      Should.satisfyAllConditions([
        () => render.text.should.be('Active'),
        () => parseResult.errors.should.beEmpty(),
      ]);
    });

    test('multiple if statements in sequence', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText(
        '{{ if a }}A{{ endif }}{{ if b }}B{{ endif }}',
      );

      final render = await engine.render(
        parseResult,
        variables: {'a': true, 'b': true},
      );

      Should.satisfyAllConditions([
        () => render.text.should.be('AB'),
        () => parseResult.errors.should.beEmpty(),
      ]);
    });

    test('incomplete if condition still produces error', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText('{{ if }}Yes{{ endif }}');
      Should.satisfyAllConditions([
        () => parseResult.errors.should.haveCount(1),
        () => parseResult.errors.first.message.should.be(
          'Unexpected end of expression',
        ),
        () =>
            parseResult.errors.first.location.should.be(TemplateLocation(1, 7)),
      ]);
    });

    test('dangling else produces error', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText('{{ else }}No');
      Should.satisfyAllConditions([
        () => parseResult.errors.should.haveCount(1),
        () => parseResult.errors.first.message.should.be(
          'Unable to parse expression block: Unexpected reserved keyword `else`',
        ),
        () =>
            parseResult.errors.first.location.should.be(TemplateLocation(1, 4)),
      ]);
    });

    test('dangling endif produces error', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText('{{ endif }}');
      Should.satisfyAllConditions([
        () => parseResult.errors.should.haveCount(1),
        () => parseResult.errors.first.message.should.be(
          'Unable to parse expression block: Unexpected reserved keyword `endif`',
        ),
        () =>
            parseResult.errors.first.location.should.be(TemplateLocation(1, 4)),
      ]);
    });

    test('dangling else and endif produces errors', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText('{{ else }}No{{ endif }}');

      Should.satisfyAllConditions([
        () => parseResult.errors.should.haveCount(2),
        () => parseResult.errors.first.message.should.be(
          'Unable to parse expression block: Unexpected reserved keyword `else`',
        ),
        () =>
            parseResult.errors.first.location.should.be(TemplateLocation(1, 4)),
        () => parseResult.errors.last.message.should.be(
          'Unable to parse expression block: Unexpected reserved keyword `endif`',
        ),
        () =>
            parseResult.errors.last.location.should.be(TemplateLocation(1, 16)),
      ]);
    });
  });
}
