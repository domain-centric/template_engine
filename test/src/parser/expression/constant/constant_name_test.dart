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
        parseResult.errors.should.beEmpty();
        var renderResult = await engine.render(
          parseResult,
          variables: {'east': 'Direction of where the sun rises.'},
        );
        renderResult.text.should.be('Direction of where the sun rises.');
      },
    );

    test('valid constant names should not throw an error', () {
      var validConstantNames = ['e', 'ln10', 'log10e', 'myConstant'];
      Should.satisfyAllConditions([
        for (var validName in validConstantNames)
          () => Should.notThrowError(
            () => ConstantDefinition(
              name: validName,
              description: 'dummy',
              value: 10,
            ),
          ),
      ]);
    });

    test('invalid constant names should not throw an argument error', () {
      Should.satisfyAllConditions([
        () =>
            Should.throwException<InvalidIdentifierName>(
              () => ConstantDefinition(
                name: '1e',
                description: 'dummy',
                value: 10,
              ),
            )?.message.should.be(
              'invalid constant name: "1e", letter OR underscore expected at position 0',
            ),
        () =>
            Should.throwException<InvalidIdentifierName>(
              () => ConstantDefinition(
                name: ' SpacePrefix',
                description: 'dummy',
                value: 10,
              ),
            )?.message.should.be(
              'invalid constant name: " SpacePrefix", letter OR underscore expected at position 0',
            ),
        () =>
            Should.throwException<InvalidIdentifierName>(
              () => ConstantDefinition(
                name: 'SpaceSuffix ',
                description: 'dummy',
                value: 10,
              ),
            )?.message.should.be(
              'invalid constant name: "SpaceSuffix ", letter OR digit expected at position 11',
            ),
        () =>
            Should.throwException<InvalidIdentifierName>(
              () => ConstantDefinition(
                name: 'withInv@lidSymbols',
                description: 'dummy',
                value: 10,
              ),
            )?.message.should.be(
              'invalid constant name: "withInv@lidSymbols", letter OR digit expected at position 7',
            ),
      ]);
    });
  });
}
