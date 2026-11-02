[//]: # (This file was generated from: doc/template/doc/wiki/05-Data-types.md.template using the documentation_builder package)
A [data type](https://en.wikipedia.org/wiki/Data_type) defines what the possible values an expression, such as a variable, operator or a function call, might use.

The [template_engine](https://pub.dev/packages/template_engine) supports several default DataTypes.
### Boolean
<table>
<tr><td>description:</td><td>A form of data with only two possible values: true or false</td></tr>
<tr><td>syntax:</td><td>{{true}}  {{false}}</td></tr>
<tr><td>syntax explanation:</td><td>A boolean is declared with the word true or false (case un-sensitive).</td></tr>
<tr><td>test example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/data_type/bool_test.dart">bool_test.dart</a></td></tr>
</table>

### Number
<table>
<tr><td>description:</td><td>A form of data to express the size of something.</td></tr>
<tr><td>syntax:</td><td>{{-12.34}}</td></tr>
<tr><td>syntax explanation:</td><td>Numbers are declared in many ways:<br>* integer (e.g. 2021)<br>* fragments (e.g. 3.14)<br>* positive (e.g. 10 or +10 or 10.2)<br>* negative (e.g. -11 or -1.2)<br>* scientific (e.g. 1e3 = 1000.0 or -123e-2 = -1.23)<br>* hexadecimal (e.g. 0x1f = 31 or -0xFF = -255)</td></tr>
<tr><td>test example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/data_type/num_test.dart">num_test.dart</a></td></tr>
</table>

### String
<table>
<tr><td>description:</td><td>A form of data containing a sequence of characters</td></tr>
<tr><td>syntax:</td><td></td></tr>
<tr><td>syntax explanation:</td><td>A string is declared with a chain of characters, surrounded by two single (') or double (") quotes to indicate the start and end of a string. In example: 'Hello' or "Hello"</td></tr>
<tr><td>test example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/data_type/string_test.dart">string_test.dart</a></td></tr>
</table>

### List
<table>
<tr><td>description:</td><td>An indexable ordered collection of objects.</td></tr>
<tr><td>syntax:</td><td>{{List(1, 2, 3)}}</td></tr>
<tr><td>syntax explanation:</td><td>List() creates an empty list. Values can be supplied as constructor arguments.</td></tr>
<tr><td>test example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/data_type/list_test.dart">list_test.dart</a></td></tr>
</table>

### Set
<table>
<tr><td>description:</td><td>An unordered collection of unique objects.</td></tr>
<tr><td>syntax:</td><td>{{Set(1, 2, 3)}}</td></tr>
<tr><td>syntax explanation:</td><td>Set() creates an empty set. Values can be supplied as constructor arguments.</td></tr>
<tr><td>test example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/data_type/set_test.dart">set_test.dart</a></td></tr>
</table>

### Map
<table>
<tr><td>description:</td><td>A collection of key-value pairs.</td></tr>
<tr><td>syntax:</td><td>{{Map("name": "Nils", "age": 12)}}</td></tr>
<tr><td>syntax explanation:</td><td>Map() creates an empty map. Key-value pairs can be supplied using the syntax key: value.</td></tr>
<tr><td>test example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/data_type/map_test.dart">map_test.dart</a></td></tr>
</table>

### Custom data types
You can use the data types that are packaged with Template Engine, but you can also add or replace these with your own custom made data types. This is done by creating your own TemplateEngineConfiguration or adding to it using the withAdditionalDataTypes() method

Example: <a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/data_type/custom_data_type_test.dart">custom_data_type_test.dart</a>
