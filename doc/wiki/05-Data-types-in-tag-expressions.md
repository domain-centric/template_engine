[//]: # (This file was generated from: doc/template/doc/wiki/05-Data-types-in-tag-expressions.md.template using the documentation_builder package)
[//]: # (TODO: This text should be imported from the dart doc of the DataType class using document_generator package)
A [data type](https://en.wikipedia.org/wiki/Data_type) defines what the
possible values an expression, such as a variable, operator
or a function call, might take.

The TemplateEngine supports several default DataTypes.

## Custom DataTypes
You can adopt existing DataTypes or add your own custom DataTypes by 
manipulating the TemplateEngine.dataTypes field.
See [Example](https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/data_type/custom_data_type_test.dart). 

## Available DataTypes
### String Data Type
<table>
<tr><td>description:</td><td>A form of data containing a sequence of characters</td></tr>
<tr><td>syntax:</td><td>A string is declared with a chain of characters, surrounded by two single (') or double (") quotes to indicate the start and end of a string. In example: 'Hello' or "Hello"</td></tr>
<tr><td>example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/data_type/string_test.dart">string_test.dart</a></td></tr>
</table>

### Number Data Type
<table>
<tr><td>description:</td><td>A form of data to express the size of something.</td></tr>
<tr><td>syntax:</td><td>A number is declared with:<br>* optional: positive (e.g. +12) or negative (e.g. -12) prefix or no prefix (12=positive)<br>* one or more digits (e.g. 12)<br>* optional fragments (e.g. 0.12)<br>* optional: scientific notation: the letter E is used to mean"10 to the power of." (e.g. 1.314E+1 means 1.314 * 10^1which is 13.14).<br></td></tr>
<tr><td>example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/data_type/num_test.dart">num_test.dart</a></td></tr>
</table>

### Boolean Data Type
<table>
<tr><td>description:</td><td>A form of data with only two possible values: true or false</td></tr>
<tr><td>syntax:</td><td>A boolean is declared with the word true or false. The letters are case insensitive.</td></tr>
<tr><td>example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/data_type/bool_test.dart">bool_test.dart</a></td></tr>
</table>
