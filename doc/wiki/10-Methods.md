[//]: # (This file was generated from: doc/template/doc/wiki/10-Methods.md.template using the documentation_builder package)
A [method](https://en.wikipedia.org/wiki/Method_(computer_programming)) is just a [function](https://en.wikipedia.org/wiki/Function_(computer_programming)) that lives inside an object. 
It does everything a function does, but it’s tied to the object it belongs to.
A method can be used after an expression value and a . (dot) operator, 

In example: 'Hello'.length()
Should result in: 5

## Parameters and Arguments
**Parameter & argument names:**
* are [case unsensitive sensitive](https://en.wikipedia.org/wiki/Case_sensitivity)
* must start with a letter, optionally followed by letters and or digits.
* preferred convention: prefer to use [lowerCamelCase](https://en.wikipedia.org/wiki/Camel_case)
* must be unique and does not match reserved key words (e.g. statements and constants)

**Parameters vs Arguments**
* Parameters are the names used in the ParameterOwner.method definition.
* Arguments are the actual values passed when calling the ParameterOwner.method.

**Parameters:**
* A ParameterOwner.method can have zero or more parameters
* Parameters are defined as either mandatory or optional
* Optional parameters can have a default value

**Arguments:**
* Multiple arguments are separated with a comma, e.g.: 
single argument: `'Hello'.right(2)` multiple arguments: `'Telephone'.replaceFirst('phone','vision')`
* There are different types of arguments
  * Positional Arguments: These are passed in the order the function defines them. e.g.: 
`'Telephone'.replaceFirst('phone','vision')`
  * Named Arguments: You can specify which parameter you're assigning a value to, regardless of order. e.g.: 
`'Telephone'.replaceFirst(from:'phone',to:'vision')`
* Arguments can set a parameter value only once
* You can mix positional arguments and named arguments, but positional arguments must come first
* Named arguments remove ambiguity: If you want to skip an optional argument or specify one out of order, you must name it explicitly

**Argument values:**
* must match the expected parameter type. e.g. `area(length='hello', width='world')` will result in a error
* may be a expression such as a variable, constant, operation, function, or combination. e.g. `cos(2*pi)`


## Dynamic Methods
### toString Method
<table>
<tr><td>description:</td><td colspan="4">Returns the string representation of the object</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>code block example:</td><td colspan="4">{{12.5.toString()}} should render: '12.5'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/dynamic/to_string_test.dart">to_string_test.dart</a></td></tr>
</table>

### type Method
<table>
<tr><td>description:</td><td colspan="4">Returns the type of the object</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>code block example:</td><td colspan="4">{{12.5.type()}} should render: 'double'</td></tr>
<tr><td>code block example:</td><td colspan="4">{{12.type()}} should render: 'int'</td></tr>
<tr><td>code block example:</td><td colspan="4">{{"Hello".type()}} should render: 'String'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/dynamic/type_test.dart">type_test.dart</a></td></tr>
</table>

## String Methods
### toNumber Method
<table>
<tr><td>description:</td><td colspan="4">Returns a string as a number (int or double). </td></tr>
<tr><td>return type:</td><td colspan="4">number</td></tr>
<tr><td>code block example:</td><td colspan="4">{{"123".toNumber()}} should render: '123'</td></tr>
<tr><td>code block example:</td><td colspan="4">{{"12.3".toNumber()}} should render: '12.3'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/string/to_number_test.dart">to_number_test.dart</a></td></tr>
</table>

### toUpperCase Method
<table>
<tr><td>description:</td><td colspan="4">Returns a string where all characters are in upper case</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>code block example:</td><td colspan="4">{{"HELlo".toUpperCase()}} should render: 'HELLO'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/string/to_lower_case_test.dart">to_lower_case_test.dart</a></td></tr>
</table>

### toLowerCase Method
<table>
<tr><td>description:</td><td colspan="4">Returns a string where all characters are in lower case</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>code block example:</td><td colspan="4">{{"HELlo".toLowerCase()}} should render: 'hello'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/string/to_lower_case_test.dart">to_lower_case_test.dart</a></td></tr>
</table>

### toCamelCase Method
<table>
<tr><td>description:</td><td colspan="4">Returns a string converted to camelCase</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>code block example:</td><td colspan="4">{{"Hello world".toCamelCase()}} should render: 'helloWorld'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/string/to_camel_case_test.dart">to_camel_case_test.dart</a></td></tr>
</table>

### toConstantCase Method
<table>
<tr><td>description:</td><td colspan="4">Returns a string converted to CONSTANT_CASE</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>code block example:</td><td colspan="4">{{"Hello world".toConstantCase()}} should render: 'HELLO_WORLD'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/string/to_constant_case_test.dart">to_constant_case_test.dart</a></td></tr>
</table>

### toSentenceCase Method
<table>
<tr><td>description:</td><td colspan="4">Returns a string converted to sentence case</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>code block example:</td><td colspan="4">{{"hello_world".toSentenceCase()}} should render: 'Hello world'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/string/to_sentence_case_test.dart">to_sentence_case_test.dart</a></td></tr>
</table>

### toSnakeCase Method
<table>
<tr><td>description:</td><td colspan="4">Returns a string converted to snake_case</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>code block example:</td><td colspan="4">{{"Hello World".toSnakeCase()}} should render: 'hello_world'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/string/to_snake_case_test.dart">to_snake_case_test.dart</a></td></tr>
</table>

### toDotCase Method
<table>
<tr><td>description:</td><td colspan="4">Returns a string converted to dot.case</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>code block example:</td><td colspan="4">{{"Hello World".toDotCase()}} should render: 'hello.world'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/string/to_dot_case_test.dart">to_dot_case_test.dart</a></td></tr>
</table>

### toParamCase Method
<table>
<tr><td>description:</td><td colspan="4">Returns a string converted to param-case</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>code block example:</td><td colspan="4">{{"Hello World".toParamCase()}} should render: 'hello-world'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/string/to_param_case_test.dart">to_param_case_test.dart</a></td></tr>
</table>

### toPathCase Method
<table>
<tr><td>description:</td><td colspan="4">Returns a string converted to path/case</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>code block example:</td><td colspan="4">{{"Hello World".toPathCase()}} should render: 'hello/world'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/string/to_path_case_test.dart">to_path_case_test.dart</a></td></tr>
</table>

### toPascalCase Method
<table>
<tr><td>description:</td><td colspan="4">Returns a string converted to PascalCase</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>code block example:</td><td colspan="4">{{"hello world".toPascalCase()}} should render: 'HelloWorld'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/string/to_pascal_case_test.dart">to_pascal_case_test.dart</a></td></tr>
</table>

### toHeaderCase Method
<table>
<tr><td>description:</td><td colspan="4">Returns a string converted to Header-Case</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>code block example:</td><td colspan="4">{{"hello world".toHeaderCase()}} should render: 'Hello-World'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/string/to_header_case_test.dart">to_header_case_test.dart</a></td></tr>
</table>

### toTitleCase Method
<table>
<tr><td>description:</td><td colspan="4">Returns a string converted to Title Case</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>code block example:</td><td colspan="4">{{"hello_world".toTitleCase()}} should render: 'Hello World'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/string/to_title_case_test.dart">to_title_case_test.dart</a></td></tr>
</table>

### trim Method
<table>
<tr><td>description:</td><td colspan="4">Returns a string without any leading and trailing whitespace</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>code block example:</td><td colspan="4">{{"  Hello  ".trim()}} should render: 'Hello'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/string/trim_test.dart">trim_test.dart</a></td></tr>
</table>

### trimLeft Method
<table>
<tr><td>description:</td><td colspan="4">Returns a string without any leading whitespace</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>code block example:</td><td colspan="4">{{"  Hello  ".trimLeft()}} should render: 'Hello  '</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/string/trim_left_test.dart">trim_left_test.dart</a></td></tr>
</table>

### trimRight Method
<table>
<tr><td>description:</td><td colspan="4">Returns a string without any trailing whitespace</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>code block example:</td><td colspan="4">{{"  Hello  ".trimRight()}} should render: '  Hello'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/string/trim_right_test.dart">trim_right_test.dart</a></td></tr>
</table>

### padLeft Method
<table>
<tr><td>description:</td><td colspan="4">Returns a string with padding added to the left</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>parameter:</td><td>width</td><td>int</td><td>mandatory</td><td>The total width of the resulting string</td></tr>
<tr><td>parameter:</td><td>padding</td><td>String</td><td>optional (default value:  )</td><td>The string to use for padding</td></tr>
<tr><td>code block example:</td><td colspan="4">{{"Hello".padLeft(7)}} should render: '  Hello'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/string/pad_left_test.dart">pad_left_test.dart</a></td></tr>
</table>

### padRight Method
<table>
<tr><td>description:</td><td colspan="4">Returns a string with padding added to the right</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>parameter:</td><td>width</td><td>int</td><td>mandatory</td><td>The total width of the resulting string</td></tr>
<tr><td>parameter:</td><td>padding</td><td>String</td><td>optional (default value:  )</td><td>The string to use for padding</td></tr>
<tr><td>code block example:</td><td colspan="4">{{"Hello".padRight(7)}} should render: 'Hello  '</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/string/pad_right_test.dart">pad_right_test.dart</a></td></tr>
</table>

### subString Method
<table>
<tr><td>description:</td><td colspan="4">Returns a substring of the string</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>parameter:</td><td>start</td><td>int</td><td>mandatory</td><td>The starting index of the substring (0=first character)</td></tr>
<tr><td>parameter:</td><td>end</td><td>int</td><td>optional</td><td>The ending index of the substring</td></tr>
<tr><td>code block example:</td><td colspan="4">{{"12345".subString(0, 2)}} should render: '12'</td></tr>
<tr><td>code block example:</td><td colspan="4">{{"12345".subString(1, 4)}} should render: '234'</td></tr>
<tr><td>code block example:</td><td colspan="4">{{"12345".subString(3)}} should render: '45'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/string/sub_string_test.dart">sub_string_test.dart</a></td></tr>
</table>

### split Method
<table>
<tr><td>description:</td><td colspan="4">Returns a list of strings obtained by splitting the string at each occurrence of the pattern</td></tr>
<tr><td>return type:</td><td colspan="4">List<String></td></tr>
<tr><td>parameter:</td><td>pattern</td><td>String</td><td>mandatory</td><td>The pattern to split the string by</td></tr>
<tr><td>code block example:</td><td colspan="4">{{"Hello world".split(" ")}} should render: '[Hello, world]'</td></tr>
<tr><td>code block example:</td><td colspan="4">{{"Hello world".split("")}} should render: '[H, e, l, l, o,  , w, o, r, l, d]'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/string/split_test.dart">split_test.dart</a></td></tr>
</table>

### replaceFirst Method
<table>
<tr><td>description:</td><td colspan="4">Returns a string with the first occurrence of a substring replaced</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>parameter:</td><td>from</td><td>String</td><td>mandatory</td><td>The string to replace</td></tr>
<tr><td>parameter:</td><td>to</td><td>String</td><td>mandatory</td><td>The string to replace with</td></tr>
<tr><td>code block example:</td><td colspan="4">{{'Hello ! !'.replaceFirst('!','world')}} should render: 'Hello world !'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/string/replace_first_test.dart">replace_first_test.dart</a></td></tr>
</table>

### replaceAll Method
<table>
<tr><td>description:</td><td colspan="4">Returns a string with all occurrences of a substring replaced</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>parameter:</td><td>from</td><td>String</td><td>mandatory</td><td>The string to replace</td></tr>
<tr><td>parameter:</td><td>to</td><td>String</td><td>mandatory</td><td>The string to replace with</td></tr>
<tr><td>code block example:</td><td colspan="4">{{'Hello ??'.replaceAll('?','!')}} should render: 'Hello !!'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/string/replace_all_test.dart">replace_all_test.dart</a></td></tr>
</table>

### startsWith Method
<table>
<tr><td>description:</td><td colspan="4">Returns a boolean indicating if the string starts with the specified pattern</td></tr>
<tr><td>return type:</td><td colspan="4">boolean</td></tr>
<tr><td>parameter:</td><td>pattern</td><td>String</td><td>mandatory</td><td>The pattern to check if the string starts with</td></tr>
<tr><td>parameter:</td><td>index</td><td>int</td><td>optional (default value: 0)</td><td>The index to check if the string starts with</td></tr>
<tr><td>code block example:</td><td colspan="4">{{'Hello world'.startsWith('Hello')}} should render: 'true'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/string/starts_with_test.dart">starts_with_test.dart</a></td></tr>
</table>

### endsWith Method
<table>
<tr><td>description:</td><td colspan="4">Returns a boolean indicating if the string ends with the specified pattern</td></tr>
<tr><td>return type:</td><td colspan="4">boolean</td></tr>
<tr><td>parameter:</td><td>pattern</td><td>String</td><td>mandatory</td><td>The pattern to check if the string ends with</td></tr>
<tr><td>code block example:</td><td colspan="4">{{'Hello world'.endsWith('world')}} should render: 'true'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/string/ends_with_test.dart">ends_with_test.dart</a></td></tr>
</table>

### indexOf Method
<table>
<tr><td>description:</td><td colspan="4">Returns the index of the first occurrence of the specified pattern in the string. It returns -1 if the pattern is not found.</td></tr>
<tr><td>return type:</td><td colspan="4">int</td></tr>
<tr><td>parameter:</td><td>pattern</td><td>String</td><td>mandatory</td><td>The text to search for in the string</td></tr>
<tr><td>parameter:</td><td>start</td><td>int</td><td>optional (default value: 0)</td><td>The index to start searching from</td></tr>
<tr><td>code block example:</td><td colspan="4">{{'Hello world'.indexOf('lo')}} should render: '3'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/string/index_of_test.dart">index_of_test.dart</a></td></tr>
</table>

### length Method
<table>
<tr><td>description:</td><td colspan="4">Returns the length of a string in number of characters</td></tr>
<tr><td>return type:</td><td colspan="4">number</td></tr>
<tr><td>code block example:</td><td colspan="4">{{"Hello".length()}} should render: '5'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/string/length_test.dart">length_test.dart</a></td></tr>
</table>

## Num Methods
### toInt Method
<table>
<tr><td>description:</td><td colspan="4">Returns this number truncated to an integer.</td></tr>
<tr><td>return type:</td><td colspan="4">int</td></tr>
<tr><td>code block example:</td><td colspan="4">{{4.5.toInt()}} should render: '4'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/num/to_int_test.dart">to_int_test.dart</a></td></tr>
</table>

### toDouble Method
<table>
<tr><td>description:</td><td colspan="4">Returns this number into a double.</td></tr>
<tr><td>return type:</td><td colspan="4">double</td></tr>
<tr><td>code block example:</td><td colspan="4">{{4.toDouble()}} should render: '4.0'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/num/to_double_test.dart">to_double_test.dart</a></td></tr>
</table>

### toStringAsFixed Method
<table>
<tr><td>description:</td><td colspan="4">Returns this number to a String with a given number of digits.</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>parameter:</td><td>fractionDigits</td><td>int</td><td>mandatory</td><td>The number of digits after the dot</td></tr>
<tr><td>code block example:</td><td colspan="4">{{(4321.12345678).toStringAsFixed(3)}} should render: '4321.123'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/num/to_string_as_fixed_test.dart">to_string_as_fixed_test.dart</a></td></tr>
</table>

### toStringAsExponential Method
<table>
<tr><td>description:</td><td colspan="4">Returns this number in exponential notation with optional precision.</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>parameter:</td><td>fractionDigits</td><td>int</td><td>optional</td><td>The number of digits after the dot</td></tr>
<tr><td>code block example:</td><td colspan="4">{{4321.12345678.toStringAsExponential(3)}} should render: '4.321e+3'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/num/to_string_as_exponential_test.dart">to_string_as_exponential_test.dart</a></td></tr>
</table>

## Int Methods
### toRadixString Method
<table>
<tr><td>description:</td><td colspan="4">Converts this [int] to a string representation in the given [radix]. In the string representation, lower-case letters are used for digits above '9', with 'a' being 10 and 'z' being 35.</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>parameter:</td><td>radix</td><td>int</td><td>mandatory</td><td>the base or the number of unique digits (including zero) used to represent numbers in a positional numeral system, e.g.: 2= binary, 8= octal, 10= decimal, 16=hexadecimal. radix must be an integer in the range 2 to 36</td></tr>
<tr><td>code block example:</td><td colspan="4">{{12.toRadixString(2)}} should render: '1100'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/int/to_radix_string_test.dart">to_radix_string_test.dart</a></td></tr>
</table>

## Double Methods
### round Method
<table>
<tr><td>description:</td><td colspan="4">Returns the integer closest to this number.</td></tr>
<tr><td>return type:</td><td colspan="4">int</td></tr>
<tr><td>code block example:</td><td colspan="4">{{3.5.round()}} should render: '4'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/double/round_test.dart">round_test.dart</a></td></tr>
</table>

### truncate Method
<table>
<tr><td>description:</td><td colspan="4">Returns the integer obtained by discarding any fractional part of this number.</td></tr>
<tr><td>return type:</td><td colspan="4">int</td></tr>
<tr><td>code block example:</td><td colspan="4">{{2.00001.truncate()}} should render: '2'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/double/truncate_test.dart">truncate_test.dart</a></td></tr>
</table>

### floor Method
<table>
<tr><td>description:</td><td colspan="4">Returns the greatest integer no greater than this number.</td></tr>
<tr><td>return type:</td><td colspan="4">int</td></tr>
<tr><td>code block example:</td><td colspan="4">{{1.99999.floor()}} should render: '1'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/double/floor_test.dart">floor_test.dart</a></td></tr>
</table>

### ceil Method
<table>
<tr><td>description:</td><td colspan="4">Returns the least integer that is not smaller than this number.</td></tr>
<tr><td>return type:</td><td colspan="4">int</td></tr>
<tr><td>code block example:</td><td colspan="4">{{1.99999.ceil()}} should render: '2'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/double/ceil_test.dart">ceil_test.dart</a></td></tr>
</table>

## List<dynamic> Methods
### length Method
<table>
<tr><td>description:</td><td colspan="4">Returns the number of items (length) of a List</td></tr>
<tr><td>return type:</td><td colspan="4">number</td></tr>
<tr><td>code block example:</td><td colspan="4">{{numbers.length()}}
variables: {numbers: [4, 5, 7]}
should render: '3'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/list/length_test.dart">length_test.dart</a></td></tr>
</table>

### first Method
<table>
<tr><td>description:</td><td colspan="4">Returns the first item of a List</td></tr>
<tr><td>return type:</td><td colspan="4">dynamic</td></tr>
<tr><td>code block example:</td><td colspan="4">{{numbers.first()}}
variables: {numbers: [4, 5, 7]}
should render: '4'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/list/first_test.dart">first_test.dart</a></td></tr>
</table>

### last Method
<table>
<tr><td>description:</td><td colspan="4">Returns the last item of a List</td></tr>
<tr><td>return type:</td><td colspan="4">dynamic</td></tr>
<tr><td>code block example:</td><td colspan="4">{{numbers.last()}}
variables: {numbers: [4, 5, 7]}
should render: '7'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/list/last_test.dart">last_test.dart</a></td></tr>
</table>

### isEmpty Method
<table>
<tr><td>description:</td><td colspan="4">Returns true if the List is empty, false otherwise</td></tr>
<tr><td>return type:</td><td colspan="4">boolean</td></tr>
<tr><td>code block example:</td><td colspan="4">{{items.isEmpty()}}
variables: {items: []}
should render: 'true'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/list/is_empty_test.dart">is_empty_test.dart</a></td></tr>
</table>

### isNotEmpty Method
<table>
<tr><td>description:</td><td colspan="4">Returns true if the List is not empty, false otherwise</td></tr>
<tr><td>return type:</td><td colspan="4">boolean</td></tr>
<tr><td>code block example:</td><td colspan="4">{{items.isNotEmpty()}}
variables: {items: [1, 2, 3]}
should render: 'true'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/list/is_not_empty_test.dart">is_not_empty_test.dart</a></td></tr>
</table>

### sort Method
<table>
<tr><td>description:</td><td colspan="4">Sorts the List in according to the natural ordering of its elements.</td></tr>
<tr><td>return type:</td><td colspan="4">void</td></tr>
<tr><td>code block example:</td><td colspan="4">{{items.sort()}}{{items}}
variables: {items: [3, 1, 2]}
should render: '[1, 2, 3]'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/list/sort_test.dart">sort_test.dart</a></td></tr>
</table>

### reverse Method
<table>
<tr><td>description:</td><td colspan="4">Reverses the order in a list.</td></tr>
<tr><td>return type:</td><td colspan="4">void</td></tr>
<tr><td>code block example:</td><td colspan="4">{{items.reverse()}}{{items}}
variables: {items: [1, 2, 3]}
should render: '[3, 2, 1]'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/list/reverse_test.dart">reverse_test.dart</a></td></tr>
</table>

### toSet Method
<table>
<tr><td>description:</td><td colspan="4">Returns the elements of the List as a Set (a set is a collection of unique items)</td></tr>
<tr><td>return type:</td><td colspan="4">Set<dynamic></td></tr>
<tr><td>code block example:</td><td colspan="4">{{items.toSet()}}
variables: {items: [1, 2, 2, 3]}
should render: '{1, 2, 3}'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/list/to_set_test.dart">to_set_test.dart</a></td></tr>
</table>

### indexOf Method
<table>
<tr><td>description:</td><td colspan="4">Searches the List from index [start] to the end of the list and returns the found index number (0= if the value matches first item). Returns -1 then value can not be found in the List.</td></tr>
<tr><td>return type:</td><td colspan="4">int</td></tr>
<tr><td>parameter:</td><td>value</td><td>dynamic</td><td>mandatory</td><td>The value in the list that we want the index from</td></tr>
<tr><td>parameter:</td><td>start</td><td>int</td><td>optional (default value: 0)</td><td>The index the search starts at</td></tr>
<tr><td>code block example:</td><td colspan="4">{{items.indexOf(2)}}
variables: {items: [1, 2, 2, 3]}
should render: '1'</td></tr>
<tr><td>code block example:</td><td colspan="4">{{items.indexOf(2,2)}}
variables: {items: [1, 2, 2, 3]}
should render: '2'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/list/index_of_test.dart">index_of_test.dart</a></td></tr>
</table>

### get Method
<table>
<tr><td>description:</td><td colspan="4">Gets the value of an item in the List using an given index(0=is the first item). Returns null if the index is out of bounds</td></tr>
<tr><td>return type:</td><td colspan="4">dynamic</td></tr>
<tr><td>parameter:</td><td>index</td><td>int</td><td>optional (default value: 0)</td><td>The index of the item in the List that we want to get</td></tr>
<tr><td>code block example:</td><td colspan="4">{{items.get(1)}}
variables: {items: [apple, berry, cherry]}
should render: 'berry'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/list/get_test.dart">get_test.dart</a></td></tr>
</table>

### remove Method
<table>
<tr><td>description:</td><td colspan="4">Removes the given value from the List (0 is the first item)</td></tr>
<tr><td>return type:</td><td colspan="4">void</td></tr>
<tr><td>parameter:</td><td>value</td><td>dynamic</td><td>mandatory</td><td>The value that we want to remove from the List</td></tr>
<tr><td>code block example:</td><td colspan="4">{{items.remove("berry")}}{{items}}
variables: {items: [apple, berry, cherry]}
should render: '[apple, cherry]'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/list/remove_test.dart">remove_test.dart</a></td></tr>
</table>

### removeAt Method
<table>
<tr><td>description:</td><td colspan="4">Removes the item at the given index from the List (0 is the first item)</td></tr>
<tr><td>return type:</td><td colspan="4">void</td></tr>
<tr><td>parameter:</td><td>index</td><td>int</td><td>mandatory</td><td>The index of the item in the List that we want to remove</td></tr>
<tr><td>code block example:</td><td colspan="4">{{items.removeAt(1)}}{{items}}
variables: {items: [apple, berry, cherry]}
should render: '[apple, cherry]'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/list/remove_at_test.dart">remove_at_test.dart</a></td></tr>
</table>

### add Method
<table>
<tr><td>description:</td><td colspan="4">Returns the List with the added value</td></tr>
<tr><td>return type:</td><td colspan="4">void</td></tr>
<tr><td>parameter:</td><td>value</td><td>dynamic</td><td>mandatory</td><td>The value to add to the List</td></tr>
<tr><td>code block example:</td><td colspan="4">{{items.add(7)}}{{items}}
variables: {items: [1, 2, 3]}
should render: '[1, 2, 3, 7]'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/list/add_test.dart">add_test.dart</a></td></tr>
</table>

### insert Method
<table>
<tr><td>description:</td><td colspan="4">Adds a value to the List</td></tr>
<tr><td>return type:</td><td colspan="4">void</td></tr>
<tr><td>parameter:</td><td>index</td><td>int</td><td>mandatory</td><td>The index where the value needs to be inserted into the List (index=is first position)</td></tr>
<tr><td>parameter:</td><td>value</td><td>dynamic</td><td>mandatory</td><td>The value to add to the List</td></tr>
<tr><td>code block example:</td><td colspan="4">{{items.insert(2, 3)}}{{items}}
variables: {items: [1, 2, 4]}
should render: '[1, 2, 3, 4]'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/list/insert_test.dart">insert_test.dart</a></td></tr>
</table>

### contains Method
<table>
<tr><td>description:</td><td colspan="4">Returns true if a given value is part of the List, and false if not</td></tr>
<tr><td>return type:</td><td colspan="4">boolean</td></tr>
<tr><td>parameter:</td><td>value</td><td>dynamic</td><td>mandatory</td><td>The value to find in the List</td></tr>
<tr><td>code block example:</td><td colspan="4">{{items.contains("berry")}}
variables: {items: [apple, berry, cherry]}
should render: 'true'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/list/contains_test.dart">contains_test.dart</a></td></tr>
</table>

### clear Method
<table>
<tr><td>description:</td><td colspan="4">Returns the List, where all items are removed</td></tr>
<tr><td>return type:</td><td colspan="4">void</td></tr>
<tr><td>code block example:</td><td colspan="4">{{items.clear()}}{{items}}
variables: {items: [apple, berry, cherry]}
should render: '[]'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/list/clear_test.dart">clear_test.dart</a></td></tr>
</table>

## Set<dynamic> Methods
### length Method
<table>
<tr><td>description:</td><td colspan="4">Returns the number of items (length) of a Set</td></tr>
<tr><td>return type:</td><td colspan="4">number</td></tr>
<tr><td>code block example:</td><td colspan="4">{{numbers.length()}}
variables: {numbers: {4, 5, 7}}
should render: '3'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/set/length_test.dart">length_test.dart</a></td></tr>
</table>

### first Method
<table>
<tr><td>description:</td><td colspan="4">Returns the first item of a Set</td></tr>
<tr><td>return type:</td><td colspan="4">dynamic</td></tr>
<tr><td>code block example:</td><td colspan="4">{{numbers.first()}}
variables: {numbers: {4, 5, 7}}
should render: '4'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/set/first_test.dart">first_test.dart</a></td></tr>
</table>

### last Method
<table>
<tr><td>description:</td><td colspan="4">Returns the last item of a Set</td></tr>
<tr><td>return type:</td><td colspan="4">dynamic</td></tr>
<tr><td>code block example:</td><td colspan="4">{{numbers.last()}}
variables: {numbers: {4, 5, 7}}
should render: '7'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/set/last_test.dart">last_test.dart</a></td></tr>
</table>

### isEmpty Method
<table>
<tr><td>description:</td><td colspan="4">Returns true if the Set is empty, false otherwise</td></tr>
<tr><td>return type:</td><td colspan="4">boolean</td></tr>
<tr><td>code block example:</td><td colspan="4">{{items.isEmpty()}}
variables: {items: {}}
should render: 'true'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/set/is_empty_test.dart">is_empty_test.dart</a></td></tr>
</table>

### isNotEmpty Method
<table>
<tr><td>description:</td><td colspan="4">Returns true if the Set is not empty, false otherwise</td></tr>
<tr><td>return type:</td><td colspan="4">boolean</td></tr>
<tr><td>code block example:</td><td colspan="4">{{items.isNotEmpty()}}
variables: {items: {1, 2, 3}}
should render: 'true'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/set/is_not_empty_test.dart">is_not_empty_test.dart</a></td></tr>
</table>

### toList Method
<table>
<tr><td>description:</td><td colspan="4">Returns the elements of the Set as a List</td></tr>
<tr><td>return type:</td><td colspan="4">List<dynamic></td></tr>
<tr><td>code block example:</td><td colspan="4">{{items.toList()}}
variables: {items: {1, 2, 3}}
should render: '[1, 2, 3]'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/set/to_list_test.dart">to_list_test.dart</a></td></tr>
</table>

### contains Method
<table>
<tr><td>description:</td><td colspan="4">Returns if a Set contains a given value</td></tr>
<tr><td>return type:</td><td colspan="4">boolean</td></tr>
<tr><td>parameter:</td><td>value</td><td>dynamic</td><td>mandatory</td><td>The value to remove from the Set</td></tr>
<tr><td>code block example:</td><td colspan="4">{{items.contains(2)}}
variables: {items: {1, 2, 3}}
should render: 'true'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/set/contains_test.dart">contains_test.dart</a></td></tr>
</table>

### add Method
<table>
<tr><td>description:</td><td colspan="4">Returns the set with the added value</td></tr>
<tr><td>return type:</td><td colspan="4">void</td></tr>
<tr><td>parameter:</td><td>value</td><td>dynamic</td><td>mandatory</td><td>The value to add to the Set</td></tr>
<tr><td>code block example:</td><td colspan="4">{{items.add(7)}}{{items}}
variables: {items: {1, 2, 3}}
should render: '{1, 2, 3, 7}'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/set/add_test.dart">add_test.dart</a></td></tr>
</table>

### remove Method
<table>
<tr><td>description:</td><td colspan="4">Returns the set, where the value was removed</td></tr>
<tr><td>return type:</td><td colspan="4">void</td></tr>
<tr><td>parameter:</td><td>value</td><td>dynamic</td><td>mandatory</td><td>The value to remove from the Set</td></tr>
<tr><td>code block example:</td><td colspan="4">{{items.remove(2)}}{{items}}
variables: {items: {1, 2, 3}}
should render: '{1, 3}'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/set/remove_test.dart">remove_test.dart</a></td></tr>
</table>

### clear Method
<table>
<tr><td>description:</td><td colspan="4">Returns the set, where all items are removed</td></tr>
<tr><td>return type:</td><td colspan="4">void</td></tr>
<tr><td>code block example:</td><td colspan="4">{{items.clear()}}{{items}}
variables: {items: {1, 2, 3}}
should render: '{}'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/set/clear_test.dart">clear_test.dart</a></td></tr>
</table>

## Map<dynamic, Dynamic> Methods
### length Method
<table>
<tr><td>description:</td><td colspan="4">Returns the number of key, value pairs in a Map</td></tr>
<tr><td>return type:</td><td colspan="4">number</td></tr>
<tr><td>code block example:</td><td colspan="4">{{items.length()}}
variables: {items: {numbers: {4, 5, 7}, words: {apple, banana}}}
should render: '2'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/map/length_test.dart">length_test.dart</a></td></tr>
</table>

### isEmpty Method
<table>
<tr><td>description:</td><td colspan="4">Returns true if the Map is empty, false otherwise</td></tr>
<tr><td>return type:</td><td colspan="4">boolean</td></tr>
<tr><td>code block example:</td><td colspan="4">{{items.isEmpty()}}
variables: {items: {}}
should render: 'true'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/map/is_empty_test.dart">is_empty_test.dart</a></td></tr>
</table>

### isNotEmpty Method
<table>
<tr><td>description:</td><td colspan="4">Returns true if the Map is not empty, false otherwise</td></tr>
<tr><td>return type:</td><td colspan="4">boolean</td></tr>
<tr><td>code block example:</td><td colspan="4">{{items.isNotEmpty()}}
variables: {items: {key: value}}
should render: 'true'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/map/is_not_empty_test.dart">is_not_empty_test.dart</a></td></tr>
</table>

### keys Method
<table>
<tr><td>description:</td><td colspan="4">Returns the keys of a Map as a Set</td></tr>
<tr><td>return type:</td><td colspan="4">Set<dynamic></td></tr>
<tr><td>code block example:</td><td colspan="4">{{items.keys()}}
variables: {items: {1stKey: 1, 2ndKey: 2, 3rdKey: 3}}
should render: '{1stKey, 2ndKey, 3rdKey}'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/map/keys_test.dart">keys_test.dart</a></td></tr>
</table>

### values Method
<table>
<tr><td>description:</td><td colspan="4">Returns the values of a Map as a List</td></tr>
<tr><td>return type:</td><td colspan="4">List<dynamic></td></tr>
<tr><td>code block example:</td><td colspan="4">{{items.values()}}
variables: {items: {1stKey: 1, 2ndKey: 2, 3rdKey: 3}}
should render: '[1, 2, 3]'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/map/values_test.dart">values_test.dart</a></td></tr>
</table>

### get Method
<table>
<tr><td>description:</td><td colspan="4">Gets the value of an item in the Map using a given key. If the key does not exist, null is returned.</td></tr>
<tr><td>return type:</td><td colspan="4">dynamic</td></tr>
<tr><td>parameter:</td><td>key</td><td>Object</td><td>mandatory</td><td>The key of the item in the Map that we want to get</td></tr>
<tr><td>code block example:</td><td colspan="4">{{properties.get("age")}}
variables: {properties: {name: James, age: 30, city: New York}}
should render: '30'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/map/get_test.dart">get_test.dart</a></td></tr>
</table>

### clear Method
<table>
<tr><td>description:</td><td colspan="4">Returns the Map, where all keys and values are removed</td></tr>
<tr><td>return type:</td><td colspan="4">void</td></tr>
<tr><td>code block example:</td><td colspan="4">{{items.clear()}}{{items}}
variables: {items: {1stKey: 1, 2ndKey: 2, 3rdKey: 3}}
should render: '{}'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/map/clear_test.dart">clear_test.dart</a></td></tr>
</table>

### put Method
<table>
<tr><td>description:</td><td colspan="4">Returns the map with the added key and value pair</td></tr>
<tr><td>return type:</td><td colspan="4">void</td></tr>
<tr><td>parameter:</td><td>key</td><td>Object</td><td>mandatory</td><td>The key to add</td></tr>
<tr><td>parameter:</td><td>value</td><td>dynamic</td><td>mandatory</td><td>The value to add</td></tr>
<tr><td>code block example:</td><td colspan="4">{{items.put("3rdKey", 3)}}{{items}}
variables: {items: {1stKey: 1, 2ndKey: 2}}
should render: '{1stKey: 1, 2ndKey: 2, 3rdKey: 3}'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/map/put_test.dart">put_test.dart</a></td></tr>
</table>

### remove Method
<table>
<tr><td>description:</td><td colspan="4">Returns the map with the removed key and value pair</td></tr>
<tr><td>return type:</td><td colspan="4">void</td></tr>
<tr><td>parameter:</td><td>key</td><td>Object</td><td>mandatory</td><td>The key to remove</td></tr>
<tr><td>code block example:</td><td colspan="4">{{items.remove("1stKey")}}{{items}}
variables: {items: {1stKey: 1, 2ndKey: 2}}
should render: '{2ndKey: 2}'</td></tr>
<tr><td>test example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/map/remove_test.dart">remove_test.dart</a></td></tr>
</table>


## Custom Methods
You can use pre-packaged [template_engine](https://pub.dev/packages/template_engine) methods or add your own custom methods by manipulating the Grammar.methods field.
See <a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/custom_method_test.dart">custom_method_test.dart</a>
