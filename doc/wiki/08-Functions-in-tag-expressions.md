[//]: # (This file was generated from: doc/template/doc/wiki/08-Functions-in-tag-expressions.md.template using the documentation_builder package)
A [function](https://en.wikipedia.org/wiki/Function_(computer_programming)) is a piece of dart code that performs a specific task.
So a function can basically do anything that dart code can do.

A function can be used anywhere in an tag expression. Wherever that particular task should be performed.

An example of a function call: cos(pi)
Should result in: -1

## Parameters and Arguments  
**Function & Parameter & argument names:**
* are [case sensitive](https://en.wikipedia.org/wiki/Case_sensitivity)
* must start with a lower case letter, optionally followed by (lower or upper case) letters and or digits.
* conventions: use [lowerCamelCase](https://en.wikipedia.org/wiki/Camel_case)
* must be unique and does not match a other tag syntax

**Parameters vs Arguments**
* Parameters are the names used in the function definition.
* Arguments are the actual values passed when calling the function.

**Parameters:**
* A function can have zero or more parameters
* Parameters are defined as either mandatory or optional
* Optional parameters can have a default value

**Arguments:**
* Multiple arguments are separated with a comma, e.g. single argument: `cos(pi)` multiple arguments: `volume(10,20,30)`
* There are different types of arguments
  * Positional Arguments: These are passed in the order the function defines them. e.g.: `volume(10, 20, 30)`
  * Named Arguments: You can specify which parameter you're assigning a value to, regardless of order. e.g.: `volume(l=30, h=10, w=20)`
* Arguments can set a parameter only once
* You can mix positional arguments and named arguments, but positional arguments must come first
* Named arguments remove ambiguity: If you want to skip an optional argument or specify one out of order, you must name it explicitly

**Argument values:**
* must match the expected parameter type. e.g. `area(length='hello', width='world')` will result in a failure
* may be a tag expression such as a variable, constant, operation, function, or combination. e.g. `cos(2*pi)`

## Custom Functions  
You can use prepackaged [template_engine] functions or add your own custom functions by manipulating the TemplateEngine.functionGroups field.  
See [Example](https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/function/custom_function_test.dart).

## Available Functions  
### Math Functions
#### exp Function
<table>
<tr><td>description:</td><td colspan="4">Returns the natural exponent e, to the power of the value</td></tr>
<tr><td>return type:</td><td colspan="4">number</td></tr>
<tr><td>expression example:</td><td colspan="4">{{exp(7)}} should render: 1096.6331584284585</td></tr>
<tr><td>code example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/function/math/exp_test.dart">exp_test.dart</a></td></tr>
<tr><td>parameter:</td><td>value</td><td>number</td><td colspan="2">mandatory</td></tr>
</table>

#### log Function
<table>
<tr><td>description:</td><td colspan="4">Returns the natural logarithm of the value</td></tr>
<tr><td>return type:</td><td colspan="4">number</td></tr>
<tr><td>expression example:</td><td colspan="4">{{log(7)}} should render: 1.9459101490553132</td></tr>
<tr><td>code example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/function/math/log_test.dart">log_test.dart</a></td></tr>
<tr><td>parameter:</td><td>value</td><td>number</td><td colspan="2">mandatory</td></tr>
</table>

#### sin Function
<table>
<tr><td>description:</td><td colspan="4">Returns the sine of the radians</td></tr>
<tr><td>return type:</td><td colspan="4">number</td></tr>
<tr><td>expression example:</td><td colspan="4">{{sin(7)}} should render: 0.6569865987187891</td></tr>
<tr><td>code example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/function/math/sin_test.dart">sin_test.dart</a></td></tr>
<tr><td>parameter:</td><td>radians</td><td>number</td><td colspan="2">mandatory</td></tr>
</table>

#### asin Function
<table>
<tr><td>description:</td><td colspan="4">Returns the values arc sine in radians</td></tr>
<tr><td>return type:</td><td colspan="4">number</td></tr>
<tr><td>expression example:</td><td colspan="4">{{asin(0.5)}} should render: 0.5235987755982989</td></tr>
<tr><td>code example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/function/math/asin_test.dart">asin_test.dart</a></td></tr>
<tr><td>parameter:</td><td>value</td><td>number</td><td colspan="2">mandatory</td></tr>
</table>

#### cos Function
<table>
<tr><td>description:</td><td colspan="4">Returns the cosine of the radians</td></tr>
<tr><td>return type:</td><td colspan="4">number</td></tr>
<tr><td>expression example:</td><td colspan="4">{{cos(7)}} should render: 0.7539022543433046</td></tr>
<tr><td>code example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/function/math/cos_test.dart">cos_test.dart</a></td></tr>
<tr><td>parameter:</td><td>radians</td><td>number</td><td colspan="2">mandatory</td></tr>
</table>

#### acos Function
<table>
<tr><td>description:</td><td colspan="4">Returns the values arc cosine in radians</td></tr>
<tr><td>return type:</td><td colspan="4">number</td></tr>
<tr><td>expression example:</td><td colspan="4">{{acos(0.5)}} should render: 1.0471975511965979</td></tr>
<tr><td>code example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/function/math/acos_test.dart">acos_test.dart</a></td></tr>
<tr><td>parameter:</td><td>value</td><td>number</td><td colspan="2">mandatory</td></tr>
</table>

#### tan Function
<table>
<tr><td>description:</td><td colspan="4">Returns the the tangent of the radians</td></tr>
<tr><td>return type:</td><td colspan="4">number</td></tr>
<tr><td>expression example:</td><td colspan="4">{{tan(7)}} should render: 0.8714479827243188</td></tr>
<tr><td>code example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/function/math/tan_test.dart">tan_test.dart</a></td></tr>
<tr><td>parameter:</td><td>radians</td><td>number</td><td colspan="2">mandatory</td></tr>
</table>

#### atan Function
<table>
<tr><td>description:</td><td colspan="4">Returns the values arc tangent in radians</td></tr>
<tr><td>return type:</td><td colspan="4">number</td></tr>
<tr><td>expression example:</td><td colspan="4">{{atan(0.5)}} should render: 0.4636476090008061</td></tr>
<tr><td>code example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/function/math/atan_test.dart">atan_test.dart</a></td></tr>
<tr><td>parameter:</td><td>value</td><td>number</td><td colspan="2">mandatory</td></tr>
</table>

#### sqrt Function
<table>
<tr><td>description:</td><td colspan="4">Returns the positive square root of the value.</td></tr>
<tr><td>return type:</td><td colspan="4">number</td></tr>
<tr><td>expression example:</td><td colspan="4">{{sqrt(9)}} should render: 3.0</td></tr>
<tr><td>code example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/function/math/sqrt_test.dart">sqrt_test.dart</a></td></tr>
<tr><td>parameter:</td><td>value</td><td>number</td><td colspan="2">mandatory</td></tr>
</table>

#### round Function
<table>
<tr><td>description:</td><td colspan="4">Returns the a rounded number.</td></tr>
<tr><td>return type:</td><td colspan="4">number</td></tr>
<tr><td>expression example:</td><td colspan="4">{{round(4.445)}} should render: 4</td></tr>
<tr><td>code example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/function/math/round_test.dart">round_test.dart</a></td></tr>
<tr><td>parameter:</td><td>value</td><td>number</td><td colspan="2">mandatory</td></tr>
</table>

### String Functions
#### length Function
<table>
<tr><td>description:</td><td colspan="4">Returns the length of a string</td></tr>
<tr><td>return type:</td><td colspan="4">number</td></tr>
<tr><td>expression example:</td><td colspan="4">{{length("Hello")}} should render: 5</td></tr>
<tr><td>code example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/function/string/length_test.dart">length_test.dart</a></td></tr>
<tr><td>parameter:</td><td>string</td><td>String</td><td colspan="2">mandatory</td></tr>
</table>

### Documentation Functions
#### tagDocumentation Function
<table>
<tr><td>description:</td><td colspan="4">Generates markdown documentation of all the tags within a TemplateEngine</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ tagDocumentation() }}</td></tr>
<tr><td>parameter:</td><td>titleLevel</td><td>number</td><td>optional (default=1)</td><td>The level of the tag title</td></tr>
</table>

#### dataTypeDocumentation Function
<table>
<tr><td>description:</td><td colspan="4">Generates markdown documentation of all the data types that can be used within a ExpressionTag of a TemplateEngine</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ dataTypeDocumentation() }}</td></tr>
<tr><td>parameter:</td><td>titleLevel</td><td>number</td><td>optional (default=1)</td><td>The level of the tag title</td></tr>
</table>

#### constantDocumentation Function
<table>
<tr><td>description:</td><td colspan="4">Generates markdown documentation of all the constants that can be used within a ExpressionTag of a TemplateEngine</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ constantDocumentation() }}</td></tr>
<tr><td>parameter:</td><td>titleLevel</td><td>number</td><td>optional (default=1)</td><td>The level of the tag title</td></tr>
</table>

#### variableDocumentation Function
<table>
<tr><td>description:</td><td colspan="4">Generates markdown documentation of variables that can be used within a ExpressionTag of a TemplateEngine</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ variableDocumentation() }}</td></tr>
<tr><td>parameter:</td><td>titleLevel</td><td>number</td><td>optional (default=1)</td><td>The level of the tag title</td></tr>
</table>

#### functionDocumentation Function
<table>
<tr><td>description:</td><td colspan="4">Generates markdown documentation of all the functions that can be used within a ExpressionTag of a TemplateEngine</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ functionDocumentation() }}</td></tr>
<tr><td>parameter:</td><td>titleLevel</td><td>number</td><td>optional (default=1)</td><td>The level of the tag title</td></tr>
</table>

#### operatorDocumentation Function
<table>
<tr><td>description:</td><td colspan="4">Generates markdown documentation of all the operators that can be used within a ExpressionTag of a TemplateEngine</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ operatorDocumentation() }}</td></tr>
<tr><td>parameter:</td><td>titleLevel</td><td>number</td><td>optional (default=1)</td><td>The level of the tag title</td></tr>
</table>

#### exampleDocumentation Function
<table>
<tr><td>description:</td><td colspan="4">Generates markdown documentation of all the examples. This could be used to generate example.md file.</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ exampleDocumentation() }}</td></tr>
<tr><td>parameter:</td><td>titleLevel</td><td>number</td><td>optional (default=1)</td><td>The level of the tag title</td></tr>
</table>

### Path Functions
#### templateSource Function
<table>
<tr><td>description:</td><td colspan="4">Gives the relative path of the current template</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>expression example:</td><td colspan="4">{{templateSource()}}</td></tr>
<tr><td>code example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/function/template/template_test.dart">template_test.dart</a></td></tr>
</table>

### Import Functions
#### importTemplate Function
<table>
<tr><td>description:</td><td colspan="4">Imports, parses and renders a template file</td></tr>
<tr><td>return type:</td><td colspan="4">IntermediateRenderResult</td></tr>
<tr><td>expression example:</td><td colspan="4">{{importTemplate('test/src/parser/tag/expression/function/import/to_import.md.template')}}</td></tr>
<tr><td>code example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/function/import/import_template_test.dart">import_template_test.dart</a></td></tr>
<tr><td>parameter:</td><td>source</td><td>String</td><td>mandatory</td><td>The project path of the template file</td></tr>
</table>

#### importPure Function
<table>
<tr><td>description:</td><td colspan="4">Imports a file as is (without parsing and rendering)</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>expression example:</td><td colspan="4">{{importPure('test/src/template_engine_template_example_test.dart')}}</td></tr>
<tr><td>code example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/function/import/import_pure_test.dart">import_pure_test.dart</a></td></tr>
<tr><td>parameter:</td><td>source</td><td>String</td><td>mandatory</td><td>The project path of the file. This path can be a absolute or relative file path or URI.</td></tr>
</table>

#### importJson Function
<table>
<tr><td>description:</td><td colspan="4">Imports a JSON file and decode it to a Map<String, dynamic>, which could be assigned it to a variable.</td></tr>
<tr><td>return type:</td><td colspan="4">Map<String, dynamic></td></tr>
<tr><td>expression example:</td><td colspan="4">{{json=importJson('test/src/parser/tag/expression/function/import/person.json')}}{{json.person.child.name}}</td></tr>
<tr><td>code example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/function/import/import_json_test.dart">import_json_test.dart</a></td></tr>
<tr><td>parameter:</td><td>source</td><td>String</td><td>mandatory</td><td>The project path of the JSON file. This path can be a absolute or relative file path or URI.</td></tr>
</table>

#### importXml Function
<table>
<tr><td>description:</td><td colspan="4">Imports a XML file and decode it to a Map<String, dynamic>, which could be assigned it to a variable.</td></tr>
<tr><td>return type:</td><td colspan="4">Map<String, dynamic></td></tr>
<tr><td>expression example:</td><td colspan="4">{{xml=importXml('test/src/parser/tag/expression/function/import/person.xml')}}{{xml.person.child.name}}</td></tr>
<tr><td>code example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/function/import/import_xml_test.dart">import_xml_test.dart</a></td></tr>
<tr><td>parameter:</td><td>source</td><td>String</td><td>mandatory</td><td>The project path of the XML file. This path can be a absolute or relative file path or URI.</td></tr>
</table>

#### importYaml Function
<table>
<tr><td>description:</td><td colspan="4">Imports a YAML file and decode it to a Map<String, dynamic>, which could be assigned it to a variable.</td></tr>
<tr><td>return type:</td><td colspan="4">Map<String, dynamic></td></tr>
<tr><td>expression example:</td><td colspan="4">{{yaml=importYaml('test/src/parser/tag/expression/function/import/person.yaml')}}{{yaml.person.child.name}}</td></tr>
<tr><td>code example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/function/import/import_yaml_test.dart">import_yaml_test.dart</a></td></tr>
<tr><td>parameter:</td><td>source</td><td>String</td><td>mandatory</td><td>The project path of the YAML file. This path can be a absolute or relative file path or URI.</td></tr>
</table>

