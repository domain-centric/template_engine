[//]: # (This file was generated from: doc/template/doc/wiki/01-Template-Engine.md.template using the documentation_builder package)
![](https://github.com/domain-centric/template_engine/wiki/template_engine.png)

The [TemplateEngine](https://github.com/domain-centric/template_engine/blob/7271af789c98ce24b7e39cb6639a9201c517e080/lib/src/template_engine.dart#L40) can:
* Parse the [Template](https://pub.dev/packages/Template) text into a
  [parser tree](https://en.wikipedia.org/wiki/Parse_tree)
* Render the [parser tree](https://en.wikipedia.org/wiki/Parse_tree)
  to an output such as:
  * [Html](https://en.wikipedia.org/wiki/HTML)
  * [Programming code](https://en.wikipedia.org/wiki/Programming_language)
  * [Markdown](https://en.wikipedia.org/wiki/Markdown)
  * [Xml](https://en.wikipedia.org/wiki/XML),
  * [Json](https://en.wikipedia.org/wiki/JSON),
  * [Yaml](https://en.wikipedia.org/wiki/YAML)
  * Etc...

# Features
Template code blocks support:
* Statements, like
  * comments
  * variable assignments
  * if, then, else
  * loops
  * etc...
* Expressions that can contain (combinations of):
  * Data types
  * Constants
  * Variables
  * Operators
  * Methods
  * Functions
    e.g. functions to import:
    * Pure files (to be imported as is)
    * Template files (to be parsed and rendered)
    * XML files (to be used as a data source)
    * JSON files (to be used as a data source)
    * YAML files (to be used as a data source)
* All of the above can be customized by replacing or adding your own grammar.