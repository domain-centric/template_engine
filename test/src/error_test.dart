import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  group('TemplateError', () {
    test('TemplateError formats location and message', () {
      final error = ParseError('Boom', TemplateLocation(2, 5));
      error.toString().should.be('2:5 - Boom');
    });

    test('TemplateLocation creates a readable string', () {
      TemplateLocation(3, 7).toString().should.be('Line 3, Column 7');
    });
  });
}
