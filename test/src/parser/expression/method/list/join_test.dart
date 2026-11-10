import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{items.join()}} should render items without a separator', () async {
    final engine = TemplateEngine();
    final parseResult = await engine.parseText('{{items.join()}}');
    final renderResult = await engine.render(
      parseResult,
      variables: {
        'items': ['apple', 'berry', 'cherry'],
      },
    );

    renderResult.text.should.be('appleberrycherry');
  });

  test('{{items.join(", ")}} should render items with a separator', () async {
    final engine = TemplateEngine();
    final parseResult = await engine.parseText('{{items.join(", ")}}');
    final renderResult = await engine.render(
      parseResult,
      variables: {
        'items': ['apple', 'berry', 'cherry'],
      },
    );

    renderResult.text.should.be('apple, berry, cherry');
  });
}
