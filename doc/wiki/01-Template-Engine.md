[//]: # (This file was generated from: doc/template/doc/wiki/01-Template-Engine.md.template using the documentation_builder package)
![](https://github.com/domain-centric/template_engine/wiki/template_engine.png)

The [TemplateEngine](https://github.com/domain-centric/template_engine/blob/7f25304a5a769c58bc81d218456d839fcde5b5bc/lib/src/template_engine.dart#L4) can:
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