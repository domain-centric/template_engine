import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test(
    "{{items.put('1stKey',1)}}{{items}} should render: {1stKey: 1}",
    () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText(
        "{{items.put('1stKey',1)}}{{items}}",
      );
      var renderResult = await engine.render(
        parseResult,
        variables: {'items': {}},
      );
      renderResult.text.should.be('{1stKey: 1}');
    },
  );

  test(
    "{{items.put('3rdKey',3)}}{{items}} should render: {1stKey: 1, 2ndKey: 2, 3rdKey: 3}",
    () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText(
        "{{items.put('3rdKey',3)}}{{items}}",
      );
      var renderResult = await engine.render(
        parseResult,
        variables: {
          'items': {'1stKey': 1, '2ndKey': 2},
        },
      );
      renderResult.text.should.be('{1stKey: 1, 2ndKey: 2, 3rdKey: 3}');
    },
  );

  test(
    "{{items.put('2ndKey','overridden')}}{{items}} should render: {1stKey: 1, 2ndKey: overridden}",
    () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText(
        "{{items.put('2ndKey','overridden')}}{{items}}",
      );
      var renderResult = await engine.render(
        parseResult,
        variables: {
          'items': <String, dynamic>{'1stKey': 1, '2ndKey': 2},
        },
      );
      renderResult.text.should.be('{1stKey: 1, 2ndKey: overridden}');
    },
  );
}
