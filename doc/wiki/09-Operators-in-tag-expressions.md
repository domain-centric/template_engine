[//]: # (This file was generated from: doc/template/doc/wiki/09-Operators-in-tag-expressions.md.template using the documentation_builder package)
 An operator behaves generally like functions,
  but differs syntactically or semantically.

 Common simple examples include arithmetic (e.g. addition with +) and
 logical operations (e.g. &).

 An operator can be used anywhere in an tag expression
 wherever that particular Operator should be performed.

 The TemplateEngine supports several standard operators.

 ## Custom Operators
 You can adopt existing operators or add your own custom operators by
 manipulating the TemplateEngine.operatorGroups field.
 See [custom_operator_test.dart](https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/operator/custom_operator_test.dart).

## Available Operators
### Parentheses
#### Parentheses Operator ()
<table>
<tr><td>description:</td><td>Groups expressions together: What is between parentheses gets processed first</td></tr>
<tr><td>expression example:</td><td>{{2+1*3}} should render: 6<br>{{(2+1)*3}} should render: 9</td></tr>
<tr><td>code example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/operator/parentheses_test.dart">parentheses_test.dart</a></td></tr>
</table>

### Prefixes
#### Positive Operator +
<table>
<tr><th colspan="2">parameter type: number</th></tr>
<tr><td>description:</td><td>Optional prefix for positive numbers</td></tr>
<tr><td>expression example:</td><td>{{+3}} should render: 3</td></tr>
<tr><td>code example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/operator/prefix/positive_test.dart">positive_test.dart</a></td></tr>
</table>

#### Negative Operator -
<table>
<tr><th colspan="2">parameter type: number</th></tr>
<tr><td>description:</td><td>Prefix for a negative number</td></tr>
<tr><td>expression example:</td><td>{{-3}} should render: -3</td></tr>
<tr><td>code example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/operator/prefix/negative_test.dart">negative_test.dart</a></td></tr>
</table>

#### Not Operator !
<table>
<tr><th colspan="2">parameter type: boolean</th></tr>
<tr><td>description:</td><td>Prefix to invert a boolean, e.g.: !true =false</td></tr>
<tr><td>expression example:</td><td>{{!true}} should render: false</td></tr>
<tr><td>code example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/operator/prefix/not_test.dart">not_test.dart</a></td></tr>
</table>

### Multiplication
#### Caret Operator ^
<table>
<tr><th colspan="2">parameter type: number</th></tr>
<tr><td>description:</td><td>Calculates a number to the power of the exponent number</td></tr>
<tr><td>expression example:</td><td>{{2^3}} should render: 8</td></tr>
<tr><td>code example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/operator/multiplication/num_power_test.dart">num_power_test.dart</a></td></tr>
<tr><th colspan="2">parameter type: boolean</th></tr>
<tr><td>description:</td><td>Logical XOR with two booleans</td></tr>
<tr><td>expression example:</td><td>{{true^false}} should render: true</td></tr>
<tr><td>code example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/operator/multiplication/bool_xor_test.dart">bool_xor_test.dart</a></td></tr>
</table>

#### Multiply Operator *
<table>
<tr><th colspan="2">parameter type: number</th></tr>
<tr><td>description:</td><td>Multiplies 2 numbers</td></tr>
<tr><td>expression example:</td><td>{{2*3}} should render: 6</td></tr>
<tr><td>code example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/operator/multiplication/num_multiply_test.dart">num_multiply_test.dart</a></td></tr>
</table>

#### Divide Operator /
<table>
<tr><th colspan="2">parameter type: number</th></tr>
<tr><td>description:</td><td>Divides 2 numbers</td></tr>
<tr><td>expression example:</td><td>{{6/4}} should render: 1.5</td></tr>
<tr><td>code example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/operator/multiplication/num_divide_test.dart">num_divide_test.dart</a></td></tr>
</table>

#### Modulo Operator %
<table>
<tr><th colspan="2">parameter type: number</th></tr>
<tr><td>description:</td><td>Calculates the modulo (rest value of a division)</td></tr>
<tr><td>expression example:</td><td>{{8%3}} should render: 2</td></tr>
<tr><td>code example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/operator/multiplication/num_modulo_test.dart">num_modulo_test.dart</a></td></tr>
</table>

#### And Operator &
<table>
<tr><th colspan="2">parameter type: boolean</th></tr>
<tr><td>description:</td><td>Logical AND operation on two booleans</td></tr>
<tr><td>expression example:</td><td>{{true&true}} should render: true</td></tr>
<tr><td>code example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/operator/multiplication/bool_and_test.dart">bool_and_test.dart</a></td></tr>
<tr><th colspan="2">parameter type: String</th></tr>
<tr><td>description:</td><td>Concatenates two strings</td></tr>
<tr><td>expression example:</td><td>{{"Hel"&"lo"}} should render: Hello</td></tr>
<tr><td>code example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/operator/multiplication/string_concatenate_test.dart">string_concatenate_test.dart</a></td></tr>
</table>

### Additions
#### Add Operator +
<table>
<tr><th colspan="2">parameter type: number</th></tr>
<tr><td>description:</td><td>Adds two numbers</td></tr>
<tr><td>expression example:</td><td>{{2+3}} should render: 5</td></tr>
<tr><td>code example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/operator/addition/num_addition_test.dart">num_addition_test.dart</a></td></tr>
<tr><th colspan="2">parameter type: String</th></tr>
<tr><td>description:</td><td>Concatenates two strings</td></tr>
<tr><td>expression example:</td><td>{{"Hel"+"lo"}} should render: Hello</td></tr>
<tr><td>code example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/operator/addition/string_concatenate_test.dart">string_concatenate_test.dart</a></td></tr>
</table>

#### Subtract Operator -
<table>
<tr><th colspan="2">parameter type: number</th></tr>
<tr><td>description:</td><td>Subtracts two numbers</td></tr>
<tr><td>expression example:</td><td>{{5-3}} should render: 2</td></tr>
<tr><td>code example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/operator/addition/num_subtract_test.dart">num_subtract_test.dart</a></td></tr>
</table>

#### Or Operator |
<table>
<tr><th colspan="2">parameter type: boolean</th></tr>
<tr><td>description:</td><td>Logical OR operation on two booleans</td></tr>
<tr><td>expression example:</td><td>{{false|true}} should render: true</td></tr>
<tr><td>code example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/operator/addition/bool_or_test.dart">bool_or_test.dart</a></td></tr>
</table>

### Comparisons
#### Equals Operator ==
<table>
<tr><th colspan="2">parameter type: Object</th></tr>
<tr><td>description:</td><td>Checks if two values are equal</td></tr>
<tr><td>expression example:</td><td>{{5==2+3}} should render: true</td></tr>
<tr><td>code example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/operator/comparison/equals_test.dart">equals_test.dart</a></td></tr>
</table>

#### Not Equals Operator !=
<table>
<tr><th colspan="2">parameter type: Object</th></tr>
<tr><td>description:</td><td>Checks if two values are NOT equal</td></tr>
<tr><td>expression example:</td><td>{{4!=2+3}} should render: true</td></tr>
<tr><td>code example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/operator/comparison/not_equals_test.dart">not_equals_test.dart</a></td></tr>
</table>

#### Greater Than Or Equal Operator >=
<table>
<tr><th colspan="2">parameter type: number</th></tr>
<tr><td>description:</td><td>Checks if the left value is greater than or equal to the right value</td></tr>
<tr><td>expression example:</td><td>{{2>=2}} should render: true</td></tr>
<tr><td>code example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/operator/comparison/greater_than_or_equal_test.dart">greater_than_or_equal_test.dart</a></td></tr>
</table>

#### Greater Than Operator >
<table>
<tr><th colspan="2">parameter type: number</th></tr>
<tr><td>description:</td><td>Checks if the left value is greater than the right value</td></tr>
<tr><td>expression example:</td><td>{{2>1}} should render: true</td></tr>
<tr><td>code example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/operator/comparison/greater_than_test.dart">greater_than_test.dart</a></td></tr>
</table>

#### Less Than Or Equal Operator <=
<table>
<tr><th colspan="2">parameter type: number</th></tr>
<tr><td>description:</td><td>Checks if the left value is less than or equal to the right value</td></tr>
<tr><td>expression example:</td><td>{{2<=2}} should render: true</td></tr>
<tr><td>code example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/operator/comparison/less_than_or_equal_test.dart">less_than_or_equal_test.dart</a></td></tr>
</table>

#### Less Than Operator <
<table>
<tr><th colspan="2">parameter type: number</th></tr>
<tr><td>description:</td><td>Checks if the left value is less than the right value</td></tr>
<tr><td>expression example:</td><td>{{2>1}} should render: true</td></tr>
<tr><td>code example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/operator/comparison/less_than_test.dart">less_than_test.dart</a></td></tr>
</table>

### Assignment
#### Assignment Operator =
<table>
<tr><td>description:</td><td>Assigns a value to a variable. A new variable will be created when it did not exist before, otherwise it will be overridden with a new value.</td></tr>
<tr><td>expression example:</td><td>{{x=2}}{{x=x+3}}{{x}} should render: 5</td></tr>
<tr><td>code example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/operator/assignment/assignment_test.dart">assignment_test.dart</a></td></tr>
</table>
