[//]: # (This file was generated from: doc/template/doc/wiki/07-Variables-in-tag-expressions.md.template using the documentation_builder package)
[//]: # (TODO: This text should be imported from the dart doc of the Variable class using document_generator package)
A [Variable](https://en.wikipedia.org/wiki/Variable_(computer_science)) is
a named container for some type of information 
(like number, boolean, String etc...)
 
[//]: # (TODO: This text should be imported from the dart doc of the Variables typedef using document_generator package)
* Variables are stored as key, value pairs in a dart Map<String, Object> where:
  * String=Variable name
  * Object=Variable value
* Variables can be used in a tag expression
* Initial variable values are passed to the TemplateEngine.render method
* Variables can be modified during rendering 

[//]: # (TODO: This text should be imported from the dart doc of the VariableName class using document_generator package)
The variable name:
* must be unique and does not match a other [Tag] syntax
* must start with a letter, optionally followed by letters and or digits
* is case sensitive (convention: use [camelCase](https://en.wikipedia.org/wiki/Camel_case))

Variables can be nested. Concatenate variable names separated with dot's
to get the variable value of a nested variable.

E.g.:<br>
Variable map: {'person': {'name': 'John Doe', 'age',30}}<br>
Variable Name person.name: refers to the variable value of 'John Doe'
 
[//]: # (TODO replace links with functions)
Examples:
* [Variable Example](https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/variable/variable_test.dart)
* [Nested Variable Example](https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/variable/nested_variable_test.dart)
