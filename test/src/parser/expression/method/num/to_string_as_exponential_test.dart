import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{1.toStringAsExponential()}} should render: 1e+0', () async {
    final engine = TemplateEngine();
    final parseResult = await engine.parseText('{{1.toStringAsExponential()}}');
    final renderResult = await engine.render(parseResult);
    renderResult.text.should.be('1e+0');
  });

  test('{{1.toStringAsExponential(3)}} should render: 1.000e+0', () async {
    final engine = TemplateEngine();
    final parseResult = await engine.parseText(
      '{{1.toStringAsExponential(3)}}',
    );
    final renderResult = await engine.render(parseResult);
    renderResult.text.should.be('1.000e+0');
  });

  test(
    '{{123456.toStringAsExponential()}} should render: 1.23456e+5',
    () async {
      final engine = TemplateEngine();
      final parseResult = await engine.parseText(
        '{{123456.toStringAsExponential()}}',
      );
      final renderResult = await engine.render(parseResult);
      renderResult.text.should.be('1.23456e+5');
    },
  );

  test('{{123456.toStringAsExponential(3)}} should render: 1.235e+5', () async {
    final engine = TemplateEngine();
    final parseResult = await engine.parseText(
      '{{123456.toStringAsExponential(3)}}',
    );
    final renderResult = await engine.render(parseResult);
    renderResult.text.should.be('1.235e+5');
  });

  test('{{123.toStringAsExponential(0)}} should render: 1e+2', () async {
    final engine = TemplateEngine();
    final parseResult = await engine.parseText(
      '{{123.toStringAsExponential(0)}}',
    );
    final renderResult = await engine.render(parseResult);
    renderResult.text.should.be('1e+2');
  });
}
