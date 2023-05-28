A Dart library to parse and render templates.

## Features
- Use variables and nested variables

## Getting started

See: [Installing](https://github.com/domain-centric/template_engine/install)

## Usage

```dart
import 'package:template_engine/template_engine.dart';

void main() {
  var template = TextTemplate('Hello {{name}}.');
  // See also FileTemplate and WebTemplate
  var engine = TemplateEngine(variables: {'name': 'world'});
  var model = engine.parse(template);
  // Here you could additionally mutate or validate the model if needed.
  print(engine.render(model)); // should print 'Hello world.';
}
```

For more see: [Examples](https://github.com/domain-centric/template_engine/example)
