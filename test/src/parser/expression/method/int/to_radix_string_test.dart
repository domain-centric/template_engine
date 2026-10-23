import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{12.toRadixString(2)}} should render: 1100', () async {
    final engine = TemplateEngine();
    final parseResult = await engine.parseText('{{12.toRadixString(2)}}');
    final renderResult = await engine.render(parseResult);
    renderResult.text.should.be('1100');
  });

  test('{{31.toRadixString(2)}} should render: 11111', () async {
    final engine = TemplateEngine();
    final parseResult = await engine.parseText('{{31.toRadixString(2)}}');
    final renderResult = await engine.render(parseResult);
    renderResult.text.should.be('11111');
  });

  test('{{2021.toRadixString(2)}} should render: 11111100101', () async {
    final engine = TemplateEngine();
    final parseResult = await engine.parseText('{{2021.toRadixString(2)}}');
    final renderResult = await engine.render(parseResult);
    renderResult.text.should.be('11111100101');
  });

  test('{{(-12).toRadixString(2)}} should render: -1100', () async {
    final engine = TemplateEngine();
    final parseResult = await engine.parseText('{{(-12).toRadixString(2)}}');
    final renderResult = await engine.render(parseResult);
    renderResult.text.should.be('-1100');
  });

  test('{{12.toRadixString(8)}} should render: 14', () async {
    final engine = TemplateEngine();
    final parseResult = await engine.parseText('{{12.toRadixString(8)}}');
    final renderResult = await engine.render(parseResult);
    renderResult.text.should.be('14');
  });

  test('{{31.toRadixString(8)}} should render: 37', () async {
    final engine = TemplateEngine();
    final parseResult = await engine.parseText('{{31.toRadixString(8)}}');
    final renderResult = await engine.render(parseResult);
    renderResult.text.should.be('37');
  });

  test('{{2021.toRadixString(8)}} should render: 3745', () async {
    final engine = TemplateEngine();
    final parseResult = await engine.parseText('{{2021.toRadixString(8)}}');
    final renderResult = await engine.render(parseResult);
    renderResult.text.should.be('3745');
  });

  test('{{12.toRadixString(16)}} should render: c', () async {
    final engine = TemplateEngine();
    final parseResult = await engine.parseText('{{12.toRadixString(16)}}');
    final renderResult = await engine.render(parseResult);
    renderResult.text.should.be('c');
  });

  test('{{31.toRadixString(16)}} should render: 1f', () async {
    final engine = TemplateEngine();
    final parseResult = await engine.parseText('{{31.toRadixString(16)}}');
    final renderResult = await engine.render(parseResult);
    renderResult.text.should.be('1f');
  });

  test('{{2021.toRadixString(16)}} should render: 7e5', () async {
    final engine = TemplateEngine();
    final parseResult = await engine.parseText('{{2021.toRadixString(16)}}');
    final renderResult = await engine.render(parseResult);
    renderResult.text.should.be('7e5');
  });

  test('{{(35 * 36 + 1).toRadixString(36)}} should render: z1', () async {
    final engine = TemplateEngine();
    final parseResult = await engine.parseText(
      '{{(35 * 36 + 1).toRadixString(36)}}',
    );
    final renderResult = await engine.render(parseResult);
    renderResult.text.should.be('z1');
  });
}
