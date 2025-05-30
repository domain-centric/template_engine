[//]: # (This file was generated from: doc/template/doc/wiki/04-Tags.md.template using the documentation_builder package)
Tags are specific texts in templates that are replaced by the [template_engine](https://pub.dev/packages/template_engine) with other information.

A tag:
* Starts with some bracket and/or character combination, e.g.: {{
* Followed by some contents
* Ends with some closing bracket and/or character combination, e.g.: }}

A tag example: {{customer.name}}

By default the TemplateEngine tags start with {{ and end with }} brackets,
just like the popular template engines
[Mustache](https://mustache.github.io/) and
[Handlebars](https://handlebarsjs.com).

You can also define alternative Tag brackets in the TemplateEngine
constructor parameters. See TemplateEngine.tagStart and
TemplateEngine.tagEnd

It is recommended to use a start and end combination that is not used
elsewhere in your templates, e.g.: Do not use < > as Tag start and end
if your template contains HTML or XML

## Custom tags  
The [template_engine](https://pub.dev/packages/template_engine) comes with DefaultTags. You can replace or add your
own Tags by manipulating the the TemplateEngine.tags field.

## Available tags  
### Expression Tag
<table>
<tr><td>description:</td><td>Evaluates an expression that can contain:<br>* Data Types (e.g. boolean, number or String)<br>* Constants (e.g. pi)<br>* Variables (e.g. person.name )<br>* Operators (e.g. + - * /)<br>* Functions (e.g. cos(7) )<br>* or any combination of the above</td></tr>
<tr><td>expression example:</td><td colspan="4">The volume of a sphere = {{ round( (3/4) * pi * (radius ^ 3) )}}.</td></tr>
<tr><td>code example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/tag_expression_parser_test.dart">tag_expression_parser_test.dart</a></td></tr>
</table>
