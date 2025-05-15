import 'package:test/test.dart';
import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  group('escapedTagStartParser and escapedTagEndParser', () {
    test('should parse and render escaped tag start "{{"', () async {
      final template = TextTemplate('Hello \\{{ world.');
      final engine = TemplateEngine();

      final parseResult = await engine.parseTemplate(template);
      final templateParseResult = parseResult.children.first;

      Should.satisfyAllConditions([
        () => templateParseResult.children.length.should.be(3),
        () => templateParseResult.children.first.should
            .beOfType<String>()!
            .should
            .be('Hello '),
        () => templateParseResult.children[1].should
            .beOfType<String>()!
            .should
            .be('{{'),
        () => templateParseResult.children.last.should
            .beOfType<String>()!
            .should
            .be(' world.'),
      ]);

      final result = await engine.render(parseResult, {'name': 'world'});
      result.text.should.be('Hello {{ world.');
    });

    test('should parse and render escaped tag end "}}"', () async {
      final template = TextTemplate('Hello \\}} world.');
      final engine = TemplateEngine();

      final parseResult = await engine.parseTemplate(template);
      final templateParseResult = parseResult.children.first;

      Should.satisfyAllConditions([
        () => templateParseResult.children.length.should.be(3),
        () => templateParseResult.children.first.should
            .beOfType<String>()!
            .should
            .be('Hello '),
        () => templateParseResult.children[1].should
            .beOfType<String>()!
            .should
            .be('}}'),
        () => templateParseResult.children.last.should
            .beOfType<String>()!
            .should
            .be(' world.'),
      ]);

      final result = await engine.render(parseResult, {'name': 'world'});
      result.text.should.be('Hello }} world.');
    });

    test('should parse and render escaped tag block "{{ ... }}"', () async {
      final template = TextTemplate('\\{{ this is not a tag or variable \\}}');
      final engine = TemplateEngine();

      final parseResult = await engine.parseTemplate(template);
      final templateParseResult = parseResult.children.first;

      Should.satisfyAllConditions([
        () => templateParseResult.children.length.should.be(3),
        () => templateParseResult.children.first.should
            .beOfType<String>()!
            .should
            .be('{{'),
        () => templateParseResult.children[1].should
            .beOfType<String>()!
            .should
            .be(' this is not a tag or variable '),
        () => templateParseResult.children.last.should
            .beOfType<String>()!
            .should
            .be('}}'),
      ]);

      final result = await engine.render(parseResult, {'name': 'world'});
      result.text.should.be('{{ this is not a tag or variable }}');
    });
  });
}
