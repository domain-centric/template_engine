[//]: # (This file was generated from: doc/template/doc/wiki/07-Variables-in-tag-expressions.md.template using the documentation_builder package)
A [variable](https://en.wikipedia.org/wiki/Variable_(computer_science)) is
a named container for some type of information
(like a [number](https://en.wikipedia.org/wiki/Double-precision_floating-point_format), [boolean](https://en.wikipedia.org/wiki/Boolean_data_type), [string](https://en.wikipedia.org/wiki/String_(computer_science)), etc...)

* Variables are stored as key, value pairs in a dart Map<String, dynamic> where:
  * String=Variable name
  * dynamic=Variable value
* Variables can be used in an ExpressionTag
* Initial variable values are passed to the TemplateEngine.render method
* Variables can be modified during rendering

The [variable name](https://en.wikipedia.org/wiki/Variable_(computer_science)) 
identifies the variable and corresponds with the keys
in the variable map.

The [variable names](https://en.wikipedia.org/wiki/Variable_(computer_science)):  
* are [case sensitive](https://en.wikipedia.org/wiki/Case_sensitivity)
* must start with a lower case letter, optionally followed by (lower or upper) letters and or digits.
* conventions: use [lowerCamelCase](https://en.wikipedia.org/wiki/Camel_case)
* must be unique and does not match a other tag syntax

Variables can be nested. Concatenate [variable names](https://en.wikipedia.org/wiki/Variable_(computer_science)) separated with dot's
to get the variable value of a nested [variable name](https://en.wikipedia.org/wiki/Variable_(computer_science)):
E.g.:<br>
Variable map: {'person': {'name': 'John Doe', 'age',30}}<br>
Variable name person.name: refers to the variable value of 'John Doe'

Examples:
* [Variable Example](https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/variable/variable_test.dart)
* [Nested Variable Example](https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/variable/nested_variable_test.dart)