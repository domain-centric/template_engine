
![](https://raw.githubusercontent.com/domain-centric/template_engine/main/doc/template/template_engine.png)

A flexible Dart library to parse templates and render output such as:
* [Html](https://en.wikipedia.org/wiki/HTML)
* [Programming code](https://en.wikipedia.org/wiki/Programming_language)
* [Markdown](https://en.wikipedia.org/wiki/Markdown)
* [Xml](https://en.wikipedia.org/wiki/XML), [Json](https://en.wikipedia.org/wiki/JSON), [Yaml](https://en.wikipedia.org/wiki/YAML)
* Etc...

## Features
- Variable Tags: get values form variables and nested variables
- Function Tags: call your Dart code to generate values with optional attributes

## Getting started

See: [Installing](https://pub.dev/packages/template_engine/install)

## Usage

```dart
import 'package:template_engine/template_engine.dart';

void main() {
  var template = TextTemplate('Hello {{name}}.');
  // See also FileTemplate and WebTemplate
  var engine = TemplateEngine();
  var parseResult = engine.parse(template, {'name': 'world'});
  // Here you could additionally mutate or validate the parseResult if needed.
  print(engine.render(parseResult)); // should print 'Hello world.';
}
```

For more see: [Examples](https://pub.dev/packages/template_engine/example)
