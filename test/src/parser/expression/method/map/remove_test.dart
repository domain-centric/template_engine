import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test(
    "{{items.remove('1stKey')}}{{items}} should render: {2ndKey: 2}",
    () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText(
        "{{items.remove('1stKey')}}{{items}}",
      );
      var renderResult = await engine.render(
        parseResult,
        variables: {
          'items': {'1stKey': 1, '2ndKey': 2},
        },
      );
      renderResult.text.should.be('{2ndKey: 2}');
    },
  );

  test(
    "{{items.remove('2ndKey')}}{{items}} should render: {2ndKey: 2}",
    () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText(
        "{{items.remove('2ndKey')}}{{items}}",
      );
      var renderResult = await engine.render(
        parseResult,
        variables: {
          'items': {'1stKey': 1, '2ndKey': 2},
        },
      );
      renderResult.text.should.be('{1stKey: 1}');
    },
  );

  test(
    "{{items.remove('nonExistingKey')}}{{items}} should render: {}",
    () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText(
        "{{items.remove('nonExistingKey')}}{{items}}",
      );
      var renderResult = await engine.render(
        parseResult,
        variables: {'items': {}},
      );
      renderResult.text.should.be('{}');
    },
  );
}
