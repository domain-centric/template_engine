[//]: # (This file was generated from: doc/template/doc/wiki/08-Operators.md.template using the documentation_builder package)
An expression can contain one or more operators. An [operator](https://en.wikipedia.org/wiki/Operator_(computer_programming)) is a symbol or keyword that performs an operation on one or more values (operands).

Common simple examples include arithmetic (e.g. addition with +) and logical operations (e.g. &).

Operators can be combined, e.g.: 3 + 4 - 2, which results in 5.

Operators are processed in a specific order, e.g.: 3 + 2 * 5, which results in 2 * 5 = 10 + 3 = 13

This order that operators are processed is the order of the following paragraphs.

You can change the order that operators are processed with parentheses, e.g.: (3 + 2) * 5, which results in 3 + 2 = 5 * 5 =25
## Unary operators
### + operator
<table>
<tr><td colspan="2"><p align="center">syntax: +&lt;number&gt;<br>returns: &lt;number&gt;</p></td></tr>
<tr><td>description:</td><td>Optional prefix for positive numbers</td></tr>
<tr><td>code block example:</td><td>{{+3}} should render: '3'</td></tr>
<tr><td>test example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/operator/prefix/positive_test.dart">positive_test.dart</a></td></tr>
</table>

### - operator
<table>
<tr><td colspan="2"><p align="center">syntax: -&lt;number&gt;<br>returns: &lt;number&gt;</p></td></tr>
<tr><td>description:</td><td>Prefix for a negative number</td></tr>
<tr><td>code block example:</td><td>{{-3}} should render: '-3'</td></tr>
<tr><td>test example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/operator/prefix/negative_test.dart">negative_test.dart</a></td></tr>
</table>

### ! operator
<table>
<tr><td colspan="2"><p align="center">syntax: !&lt;boolean&gt;<br>returns: &lt;boolean&gt;</p></td></tr>
<tr><td>description:</td><td>Prefix to invert a boolean, e.g.: !true => false</td></tr>
<tr><td>code block example:</td><td>{{!true}} should render: 'false'</td></tr>
<tr><td>test example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/operator/prefix/not_test.dart">not_test.dart</a></td></tr>
</table>

## Exponentiation operators
### ** operator
<table>
<tr><td colspan="2"><p align="center">syntax: &lt;number&gt; ** &lt;number&gt;<br>returns: &lt;number&gt;</p></td></tr>
<tr><td>description:</td><td>Calculates a number to the power of the exponent number</td></tr>
<tr><td>code block example:</td><td>{{2**3}} should render: '8'</td></tr>
<tr><td>test example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/operator/exponentiation/num_power_test.dart">num_power_test.dart</a></td></tr>
</table>

## Multiplicative operators
### * operator
<table>
<tr><td colspan="2"><p align="center">syntax: &lt;number&gt; * &lt;number&gt;<br>returns: &lt;number&gt;</p></td></tr>
<tr><td>description:</td><td>Multiplies 2 numbers</td></tr>
<tr><td>code block example:</td><td>{{2*3}} should render: '6'</td></tr>
<tr><td>test example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/operator/multiplication/num_multiply_test.dart">num_multiply_test.dart</a></td></tr>
</table>

### / operator
<table>
<tr><td colspan="2"><p align="center">syntax: &lt;number&gt; / &lt;number&gt;<br>returns: &lt;number&gt;</p></td></tr>
<tr><td>description:</td><td>Divides 2 numbers</td></tr>
<tr><td>code block example:</td><td>{{6/4}} should render: '1.5'</td></tr>
<tr><td>test example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/operator/multiplication/num_divide_test.dart">num_divide_test.dart</a></td></tr>
</table>

### % operator
<table>
<tr><td colspan="2"><p align="center">syntax: &lt;number&gt; % &lt;number&gt;<br>returns: &lt;number&gt;</p></td></tr>
<tr><td>description:</td><td>Calculates the modulo (rest value of a division)</td></tr>
<tr><td>code block example:</td><td>{{7%3}} should render: '1'</td></tr>
<tr><td>test example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/operator/multiplication/num_modulo_test.dart">num_modulo_test.dart</a></td></tr>
</table>

## Additive operators
### + operator
<table>
<tr><td colspan="2"><p align="center">syntax: &lt;number&gt; + &lt;number&gt;<br>returns: &lt;number&gt;</p></td></tr>
<tr><td>description:</td><td>Adds two numbers</td></tr>
<tr><td>code block example:</td><td>{{2+3}} should render: '5'</td></tr>
<tr><td>test example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/operator/additive/num_addition_test.dart">num_addition_test.dart</a></td></tr>
<tr><td colspan="2"><p align="center">syntax: &lt;String&gt; + &lt;String&gt;<br>returns: &lt;String&gt;</p></td></tr>
<tr><td>description:</td><td>Concatenates two strings</td></tr>
<tr><td>code block example:</td><td>{{"Hel"+"lo"}} should render: 'Hello'</td></tr>
<tr><td>test example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/operator/additive/string_concatenate_test.dart">string_concatenate_test.dart</a></td></tr>
</table>

### - operator
<table>
<tr><td colspan="2"><p align="center">syntax: &lt;number&gt; - &lt;number&gt;<br>returns: &lt;number&gt;</p></td></tr>
<tr><td>description:</td><td>Subtracts two numbers</td></tr>
<tr><td>code block example:</td><td>{{5-3}} should render: '2'</td></tr>
<tr><td>test example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/operator/additive/num_subtract_test.dart">num_subtract_test.dart</a></td></tr>
</table>

## Relational operators
### > operator
<table>
<tr><td colspan="2"><p align="center">syntax: &lt;number&gt; > &lt;number&gt;<br>returns: &lt;boolean&gt;</p></td></tr>
<tr><td>description:</td><td>Checks if the left value is greater than the right value</td></tr>
<tr><td>code block example:</td><td>{{2>1}} should render: 'true'</td></tr>
<tr><td>test example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/operator/comparison/greater_than_test.dart">greater_than_test.dart</a></td></tr>
</table>

### >= operator
<table>
<tr><td colspan="2"><p align="center">syntax: &lt;number&gt; >= &lt;number&gt;<br>returns: &lt;boolean&gt;</p></td></tr>
<tr><td>description:</td><td>Checks if the left value is greater than or equal to the right value</td></tr>
<tr><td>code block example:</td><td>{{2>=2}} should render: 'true'</td></tr>
<tr><td>test example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/operator/comparison/greater_than_or_equal_test.dart">greater_than_or_equal_test.dart</a></td></tr>
</table>

### < operator
<table>
<tr><td colspan="2"><p align="center">syntax: &lt;number&gt; < &lt;number&gt;<br>returns: &lt;boolean&gt;</p></td></tr>
<tr><td>description:</td><td>Checks if the left value is less than the right value</td></tr>
<tr><td>code block example:</td><td>{{1<2}} should render: 'true'</td></tr>
<tr><td>test example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/operator/comparison/less_than_test.dart">less_than_test.dart</a></td></tr>
</table>

### <= operator
<table>
<tr><td colspan="2"><p align="center">syntax: &lt;number&gt; <= &lt;number&gt;<br>returns: &lt;boolean&gt;</p></td></tr>
<tr><td>description:</td><td>Checks if the left value is less than or equal to the right value</td></tr>
<tr><td>code block example:</td><td>{{2<=2}} should render: 'true'</td></tr>
<tr><td>test example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/operator/comparison/less_than_or_equal_test.dart">less_than_or_equal_test.dart</a></td></tr>
</table>

## Equality operators
### == operator
<table>
<tr><td colspan="2"><p align="center">syntax: &lt;Object&gt; == &lt;Object&gt;<br>returns: &lt;Object&gt;</p></td></tr>
<tr><td>description:</td><td>Checks if two values are equal</td></tr>
<tr><td>code block example:</td><td>{{5==2+3}} should render: 'true'</td></tr>
<tr><td>test example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/operator/comparison/equals_test.dart">equals_test.dart</a></td></tr>
</table>

### != operator
<table>
<tr><td colspan="2"><p align="center">syntax: &lt;Object&gt; != &lt;Object&gt;<br>returns: &lt;boolean&gt;</p></td></tr>
<tr><td>description:</td><td>Checks if two values are NOT equal</td></tr>
<tr><td>code block example:</td><td>{{4!=2+3}} should render: 'true'</td></tr>
<tr><td>test example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/operator/comparison/not_equals_test.dart">not_equals_test.dart</a></td></tr>
</table>

## And operators
### & operator
<table>
<tr><td colspan="2"><p align="center">syntax: &lt;int&gt; & &lt;int&gt;<br>returns: &lt;int&gt;</p></td></tr>
<tr><td>description:</td><td>Bitwise AND operation on two integers</td></tr>
<tr><td>code block example:</td><td>{{5&4}} should render: '4'</td></tr>
<tr><td>test example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/operator/and/int_and_test.dart">int_and_test.dart</a></td></tr>
<tr><td colspan="2"><p align="center">syntax: &lt;boolean&gt; & &lt;boolean&gt;<br>returns: &lt;boolean&gt;</p></td></tr>
<tr><td>description:</td><td>Logical AND operation on two booleans</td></tr>
<tr><td>code block example:</td><td>{{true&true}} should render: 'true'</td></tr>
<tr><td>test example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/operator/and/bool_and_test.dart">bool_and_test.dart</a></td></tr>
<tr><td colspan="2"><p align="center">syntax: &lt;String&gt; & &lt;String&gt;<br>returns: &lt;String&gt;</p></td></tr>
<tr><td>description:</td><td>Concatenate two strings</td></tr>
<tr><td>code block example:</td><td>{{"Hel"&"lo"}} should render: 'Hello'</td></tr>
<tr><td>test example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/operator/and/string_concatenate_test.dart">string_concatenate_test.dart</a></td></tr>
</table>

## Xor operators
### ^ operator
<table>
<tr><td colspan="2"><p align="center">syntax: &lt;int&gt; ^ &lt;int&gt;<br>returns: &lt;int&gt;</p></td></tr>
<tr><td>description:</td><td>Bitwise XOR with two integers</td></tr>
<tr><td>code block example:</td><td>{{12^10}} should render: '6'</td></tr>
<tr><td>test example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/operator/xor/int_xor_test.dart">int_xor_test.dart</a></td></tr>
<tr><td colspan="2"><p align="center">syntax: &lt;boolean&gt; ^ &lt;boolean&gt;<br>returns: &lt;boolean&gt;</p></td></tr>
<tr><td>description:</td><td>Logical XOR with two booleans</td></tr>
<tr><td>code block example:</td><td>{{true^false}} should render: 'true'</td></tr>
<tr><td>test example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/operator/xor/bool_xor_test.dart">bool_xor_test.dart</a></td></tr>
</table>

## Or operators
### | operator
<table>
<tr><td colspan="2"><p align="center">syntax: &lt;int&gt; | &lt;int&gt;<br>returns: &lt;int&gt;</p></td></tr>
<tr><td>description:</td><td>Bitwise OR operation on two integers</td></tr>
<tr><td>code block example:</td><td>{{5|2}} should render: '7'</td></tr>
<tr><td>test example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/operator/or/int_or_test.dart">int_or_test.dart</a></td></tr>
<tr><td colspan="2"><p align="center">syntax: &lt;boolean&gt; | &lt;boolean&gt;<br>returns: &lt;boolean&gt;</p></td></tr>
<tr><td>description:</td><td>Logical OR operation on two booleans</td></tr>
<tr><td>code block example:</td><td>{{false|true}} should render: 'true'</td></tr>
<tr><td>test example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/operator/or/bool_or_test.dart">bool_or_test.dart</a></td></tr>
</table>

### Custom operators
You can use the operators that are packaged with Template Engine, but you can also add or replace these with your own custom made operators. This is done by creating your own TemplateEngineConfiguration or adding to it with the following TemplateEngineConfiguration methods:
* withAdditionalUnaryOperators()
* withAdditionalBinaryOperators()

Example: <a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/operator/custom_operator_test.dart">custom_operator_test.dart</a>
