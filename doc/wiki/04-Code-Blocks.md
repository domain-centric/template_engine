[//]: # (This file was generated from: doc/template/doc/wiki/04-Code-Blocks.md.template using the documentation_builder package)
Templates that are processed by [template_engine](https://pub.dev/packages/template_engine) are made out of different blocks:
* Text blocks: static template text that is not a code block
* Code blocks:
  * statement blocks: perform an action
  * expression blocks: produce a value

A code block:
* Starts with some bracket and/or character combination, e.g.: {{
* Followed by statement or expression syntax
* Ends with some closing bracket and/or character combination, e.g.: }}
### Code block delimiters
By default the [template_engine](https://pub.dev/packages/template_engine) code blocks start with {{ and end with }} 
brackets, just like the popular template engines 
[Mustache](https://mustache.github.io/) and 
[Handlebars](https://handlebarsjs.com).

You can also define alternative code block delimiters in the [template_engine](https://pub.dev/packages/template_engine) 
constructor grammar parameter. See Grammar.codeBlockDelimiter

It is recommended to use a start and end combination that is not used 
elsewhere in your templates, e.g.: Do not use < > as code block start and end 
if your template contains HTML or XML
## Statements
A statement is a code block (or a combination of code blocks with text blocks between them) that performs an action. 
Examples are: 
* if statements
* for statements
* variable assignments
* etc... 
### Comment statement
<table>
<tr><td>description:</td><td>A comment statement is a placeholder for comments for developers. A comment statement is ignored during rendering.</td></tr>
<tr><td>syntax:</td><td>{{ // This is a comment }}</td></tr>
<tr><td>syntax explanation:</td><td>Comments start with `//` and continue until the end of the line. For multiline comments, you can use multiple lines starting with `//`.</td></tr>
<tr><td>code block example:</td><td>{{ // This is a comment }} should render: Nothing</td></tr>
<tr><td>code block example:</td><td>{{  // This is a<br>      multiline comment }} should render: Nothing</td></tr>
<tr><td>test example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/statement/comment_statement_test.dart">comment_statement_test.dart</a></td></tr>
</table>

### Variable assignment statement
<table>
<tr><td>description:</td><td>Assign a value to a variable.</td></tr>
<tr><td>syntax:</td><td>{{ variableName = expression }}</td></tr>
<tr><td>syntax explanation:</td><td>variableName is the name of the variable to assign to (must be a valid identifier)
= is the assignment operator
expression is any valid expression (see expression grammar) and any supported data type
</td></tr>
<tr><td>code block example:</td><td>{{ name = "World" }} should render: Nothing</td></tr>
<tr><td>test example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/statement/assignment_statement_test.dart">assignment_statement_test.dart</a></td></tr>
</table>

### If statement
<table>
<tr><td>description:</td><td>Conditionally render content using `if`, optional `else`, and `endif`.</td></tr>
<tr><td>syntax:</td><td>{{ if condition }}Text and/or statement blocks that render if condition is true.{{ else }}Text and/or statement blocks that render if condition is false.{{ endif }}</td></tr>
<tr><td>syntax explanation:</td><td>{{if ... }} starts the if statement
condition is any boolean expression (see expression grammar)
{{else}} is optional (fallback section)
{{endif}} closes the if statement
</td></tr>
<tr><td>code block example:</td><td>{{ if user.isActive }}Active{{ else }}Inactive{{ endif }}
variables: {user: {isActive: false}}
should render: 'Inactive'</td></tr>
<tr><td>test example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/statement/if_statement_test.dart">if_statement_test.dart</a></td></tr>
</table>

### For loop statement
<table>
<tr><td>description:</td><td>A numeric for loop using `for` and `next`.</td></tr>
<tr><td>syntax:</td><td>{{ for i = 1 to 10 }}...{{ next i }}</td></tr>
<tr><td>syntax explanation:</td><td>Loop from start to end (inclusive). The loop variable is available inside the loop body and optionally checked on the matching `next`.</td></tr>
<tr><td>code block example:</td><td>{{ for i = 1 to 3 }}{{ i }}{{ next i }} should render: '123'</td></tr>
<tr><td>code block example:</td><td>{{ for i = 7 to 4 }}{{ i }}{{ next i }} should render: '7654'</td></tr>
<tr><td>test example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/statement/for_statement_test.dart">for_statement_test.dart</a></td></tr>
</table>

### For each loop statement
<table>
<tr><td>description:</td><td>Iterate over an iterable or collection using `for each` and `next <variable>`.</td></tr>
<tr><td>syntax:</td><td>{{ for each item in items }}...{{ next item }}</td></tr>
<tr><td>syntax explanation:</td><td>Iterate over each value in the provided iterable or collection. The loop variable is available inside the loop body and the closing `next` must use the same variable name.</td></tr>
<tr><td>code block example:</td><td>{{ for each item in items }}{{ item }}{{ next item }}
variables: {items: [A, B, C]}
should render: 'ABC'</td></tr>
<tr><td>test example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/statement/for_each_statement_test.dart">for_each_statement_test.dart</a></td></tr>
</table>

### While loop statement
<table>
<tr><td>description:</td><td>Loop while a condition is true using `while ... do` and `endwhile`.</td></tr>
<tr><td>syntax:</td><td>{{ while condition do }}...{{ endwhile }}</td></tr>
<tr><td>syntax explanation:</td><td>Evaluate condition before each loop iteration. Continue looping while the condition is truthy. Terminate the loop with `endwhile`.</td></tr>
<tr><td>code block example:</td><td>{{ count = 0 }}{{ while count < 3 do }}{{ count = count + 1 }}{{ count }}{{ endwhile }} should render: '123'</td></tr>
<tr><td>test example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/statement/while_statement_test.dart">while_statement_test.dart</a></td></tr>
</table>


### Custom statements
The [template_engine](https://pub.dev/packages/template_engine) comes with its own statements 
(see next paragraphs). 
Statements are pluggable, which means that you can 
remove/change or add your own statement syntax. 
See <a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/statement/custom_statement_test.dart">custom_statement_test.dart</a>

## Expressions
An expression is a piece of code that produces a value. 
Examples are: 
* variables
* constants
* operators
* function calls
* method calls
* or a combination of all of the above
* etc... 

Expressions can be used:
* inside statements (e.g. the condition of an if statement or the value of an assignment statement)
* as an expression code block, e.g. {{ sin(pi) }}

You can define your own expression grammar or modify or add tot the standard [template_engine](https://pub.dev/packages/template_engine) grammar.
* <a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/data_type/custom_data_type_test.dart">custom_data_type_test.dart</a>
* <a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/constant/custom_constant_test.dart">custom_constant_test.dart</a>
* <a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/operator/custom_operator_test.dart">custom_operator_test.dart</a>
* <a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/function/custom_function_test.dart">custom_function_test.dart</a>
* <a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/method/custom_method_test.dart">custom_method_test.dart</a>
