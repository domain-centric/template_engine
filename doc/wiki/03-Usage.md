[//]: # (This file was generated from: doc/template/doc/wiki/03-Usage.md.template using the documentation_builder package)
A typical way to use the [template_engine](https://pub.dev/packages/template_engine):

`test/src/template_engine_template_example_test.dart`
```dart
import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

Future<void> main() async {
  test('example should work', () async {
    var engine = TemplateEngine();
    var parseResult = await engine.parseText('Hello {{name}}.');
    var renderResult = await engine.render(parseResult, {'name': 'world'});
    renderResult.text.should.be('Hello world.');
  });
}

```


For more see: [Examples](https://pub.dev/packages/template_engine/example)