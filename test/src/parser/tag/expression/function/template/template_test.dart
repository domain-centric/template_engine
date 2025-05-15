import 'package:test/test.dart';
import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';

void main() {
  group('TemplateEngine with TemplateSource function', () {
    test('should render templateSource() to the template source path',
        () async {
      final engine = TemplateEngine();
      final template = TemplateWithTemplateSourceFunction();

      final parseResult = await engine.parseTemplate(template);
      final renderResult = await engine.render(parseResult);

      renderResult.text.should.be(template.source);
    });
  });
}

class TemplateWithTemplateSourceFunction extends Template {
  TemplateWithTemplateSourceFunction() {
    source = 'doc/template/generic/generated.md.template';
    sourceTitle = source;
    text = Future.value('{{templateSource()}}');
  }
}
