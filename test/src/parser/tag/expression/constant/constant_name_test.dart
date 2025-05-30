import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  group('Constant.name', () {
    test(
      'Variable "east" to be found and not taken hostage by constant "e"',
      () async {
        var engine = TemplateEngine();
        var parseResult = await engine.parseText('{{east}}');
        parseResult.errorMessage.should.beBlank();
        var renderResult = await engine.render(parseResult, {
          'east': 'Direction of where the sun rises.',
        });
        renderResult.text.should.be('Direction of where the sun rises.');
      },
    );

    test('valid constant names should not throw an error', () {
      var validConstantNames = ['e', 'ln10', 'log10e', 'myConstant'];
      Should.satisfyAllConditions([
        for (var validName in validConstantNames)
          () => Should.notThrowError(
            () => Constant(name: validName, description: 'dummy', value: 10),
          ),
      ]);
    });

    test('in-valid constant names should not throw an argument error', () {
      var inValidConstantNames = ['1e', 'Ln10', 'log>10e', '_myConstant'];
      Should.satisfyAllConditions([
        for (var inValidName in inValidConstantNames)
          () => Should.throwException<IdentifierException>(
            () => Constant(name: inValidName, description: 'dummy', value: 10),
          ),
      ]);
    });
  });
}
