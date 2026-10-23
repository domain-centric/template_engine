import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test(
    "{{items.add(9)}}{{items}} should render: {3, null, apple, banana, 9}",
    () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText("{{items.add(9)}}{{items}}");
      var renderResult = await engine.render(
        parseResult,
        variables: {
          'items': {3, null, 'apple', 'banana'},
        },
      );
      renderResult.errors.should.beEmpty();
      renderResult.text.should.be('{3, null, apple, banana, 9}');
    },
  );

  test("{{numbers.add(7)}}{{numbers}} should render: {1, 2, 3, 7}", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{numbers.add(7)}}{{numbers}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'numbers': {1, 2, 3},
      },
    );
    renderResult.text.should.be('{1, 2, 3, 7}');
  });

  test("{{numbers.add(2)}}{{numbers}} should render: {1, 2, 3}", () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText("{{numbers.add(2)}}{{numbers}}");
    var renderResult = await engine.render(
      parseResult,
      variables: {
        'numbers': {1, 2, 3},
      },
    );
    renderResult.text.should.be('{1, 2, 3}');
  });

  test(
    "{{words.add('cherry')}}{{words}} should render: {apple, banana, cherry}",
    () async {
      var engine = TemplateEngine();
      var parseResult = await engine.parseText(
        "{{words.add('cherry')}}{{words}}",
      );
      var renderResult = await engine.render(
        parseResult,
        variables: {
          'words': {'apple', 'banana'},
        },
      );
      renderResult.text.should.be('{apple, banana, cherry}');
    },
  );
}
