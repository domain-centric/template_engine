import 'package:template_engine/template_engine.dart';
import 'package:shouldly/shouldly.dart';
import 'package:test/test.dart';

void main() {
  group('CommentStatement', () {
    test('ignores single-line comment', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText('{{ // this is a comment }}');

      final render = await engine.render(parseResult);

      render.text.should.be('');
      parseResult.errors.should.beEmpty();
    });

    test('ignores multiline comment content', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText(
        '{{ // this is a\nmultiline comment }}',
      );

      final render = await engine.render(parseResult);

      render.text.should.be('');
      parseResult.errors.should.beEmpty();
    });

    test('comment does not affect surrounding content', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText('Hello {{ // comment }}World');

      final render = await engine.render(parseResult);

      render.text.should.be('Hello World');
      parseResult.errors.should.beEmpty();
    });

    test('comment inside expression block with spaces', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText(
        '{{    // comment with spaces    }}',
      );

      final render = await engine.render(parseResult);

      render.text.should.be('');
      parseResult.errors.should.beEmpty();
    });

    test('multiple comments are all ignored', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText(
        '{{ // first }}A{{ // second }}B{{ // third }}',
      );

      final render = await engine.render(parseResult);

      render.text.should.be('AB');
      parseResult.errors.should.beEmpty();
    });

    test('comment mixed with other statements', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText(
        '{{ // ignore }}{{ if active }}Yes{{ endif }}',
      );

      final render = await engine.render(
        parseResult,
        variables: {'active': true},
      );

      render.text.should.be('Yes');
      parseResult.errors.should.beEmpty();
    });

    test('comment without closing block produces error', () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText('{{ // unclosed comment ');

      parseResult.errors.isNotEmpty.should.beTrue();
    });
  });
}
