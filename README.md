[//]: # (This file was generated from: doc/template/README.md.template using the documentation_builder package)
[![Pub Package](https://img.shields.io/pub/v/template_engine)](https://pub.dev/packages/template_engine)
[![Project on github.com](https://img.shields.io/badge/repository-git%20hub-informational)](https://github.com/domain-centric/template_engine)
[![Project Wiki pages on github.com](https://img.shields.io/badge/documentation-wiki-informational)](https://github.com/domain-centric/template_engine/wiki)
[![Pub Scores](https://img.shields.io/pub/likes/template_engine)](https://pub.dev/packages/template_engine/score)
[![Stars ranking on github.com](https://img.shields.io/github/stars/domain-centric/template_engine?style=flat)](https://github.com/domain-centric/template_engine/stargazers)
[![Open issues on github.com](https://img.shields.io/github/issues/domain-centric/template_engine)](https://github.com/domain-centric/template_engine/issues)
[![Open pull requests on github.com](https://img.shields.io/github/issues-pr/domain-centric/template_engine)](https://github.com/domain-centric/template_engine/pulls)
[![Project License](https://img.shields.io/github/license/domain-centric/template_engine)](https://github.com/domain-centric/template_engine/blob/main/LICENSE)
 
![](https://github.com/domain-centric/template_engine/wiki/template_engine.png)

The [TemplateEngine](https://github.com/domain-centric/template_engine/blob/db47eea4b9cddc4c13b9447260877484fd66ab04/lib/src/template_engine.dart#L4) can:
* Parse the [Template](https://pub.dev/packages/Template) text into a
  [parser tree](https://en.wikipedia.org/wiki/Parse_tree)
* Render the [parser tree](https://en.wikipedia.org/wiki/Parse_tree)
  to a output such as:
  * [Html](https://en.wikipedia.org/wiki/HTML)
  * [Programming code](https://en.wikipedia.org/wiki/Programming_language)
  * [Markdown](https://en.wikipedia.org/wiki/Markdown)
  * [Xml](https://en.wikipedia.org/wiki/XML),
  * [Json](https://en.wikipedia.org/wiki/JSON),
  * [Yaml](https://en.wikipedia.org/wiki/YAML)
  * Etc...

# Features
* Template expressions that can contain (combinations of):
  * Data types
  * Constants
  * Variables
  * Operators
  * Functions
    e.g. functions to import:
    * Pure files (to be imported as is)
    * Template files (to be parsed and rendered)
    * XML files (to be used as a data source)
    * JSON files (to be used as a data source)
    * YAML files (to be used as a data source)
* All of the above can be customized or you could add your own.

# Getting Started
To get started:
* [Read the wiki documentation](https://github.com/domain-centric/template_engine/wiki)
* [See the examples](https://github.com/domain-centric/template_engine/wiki/10%20Examples)
* [Install the template_engine package in your project](https://pub.dev/packages/template_engine/install)
* Start coding

# Usage
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

# Documentation
For more information read the [template_engine wiki](https://github.com/domain-centric/template_engine/wiki)