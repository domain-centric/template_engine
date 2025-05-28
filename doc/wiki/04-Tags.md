[//]: # (This file was generated from: doc/template/doc/wiki/04-Tags.md.template using the documentation_builder package)
[Tag](https://pub.dev/packages/Tag)s are specific texts in [Template](https://pub.dev/packages/Template)s that are replaced by the
[TemplateEngine](https://github.com/domain-centric/template_engine/blob/451e02fd54473c314e038a56b1be06088d141938/lib/src/parser/tag/tag.dart#L6) with other information.

A [Tag](https://pub.dev/packages/Tag):
* Starts with some bracket and/or character combination, e.g.: \{{
* Followed by some contents
* Ends with some closing bracket and/or character combination, e.g.: \}}

A tag example: \{{customer.name\}}

By default the TemplateEngine [Tag](https://pub.dev/packages/Tag)s start with \{{ and end with \}} brackets,
just like the popular template engines
[Mustache](https://mustache.github.io/) and
[Handlebars](https://handlebarsjs.com).

You can also define alternative [Tag](https://pub.dev/packages/Tag) brackets in the [TemplateEngine](https://github.com/domain-centric/template_engine/blob/451e02fd54473c314e038a56b1be06088d141938/lib/src/parser/tag/tag.dart#L6)
constructor parameters. See [TemplateEngine.tagStart](https://github.com/domain-centric/template_engine/blob/451e02fd54473c314e038a56b1be06088d141938/lib/src/parser/tag/tag.dart#L21) and
[TemplateEngine.tagEnd](https://github.com/domain-centric/template_engine/blob/451e02fd54473c314e038a56b1be06088d141938/lib/src/parser/tag/tag.dart#L22).

It is recommended to use a start and end combination that is not used
elsewhere in your templates, e.g.: Do not use < > as [Tag](https://pub.dev/packages/Tag) start and end
if your template contains HTML or XML

The [TemplateEngine](https://github.com/domain-centric/template_engine/blob/451e02fd54473c314e038a56b1be06088d141938/lib/src/parser/tag/tag.dart#L6) comes with [DefaultTags](https://github.com/domain-centric/template_engine/blob/451e02fd54473c314e038a56b1be06088d141938/lib/src/parser/tag/tag.dart#L28). You can replace or add your
own [Tag](https://pub.dev/packages/Tag)s by manipulating the the [TemplateEngine.tags](https://github.com/domain-centric/template_engine/blob/451e02fd54473c314e038a56b1be06088d141938/lib/src/parser/tag/tag.dart#L29) field.

## Expression Tag
<table>
<tr><td>description:</td><td>Evaluates an expression that can contain:<br>* Data Types (e.g. boolean, number or String)<br>* Constants (e.g. pi)<br>* Variables (e.g. person.name )<br>* Operators (e.g. + - * /)<br>* Functions (e.g. cos(7) )<br>* or any combination of the above</td></tr>
<tr><td>expression example:</td><td colspan="4">The volume of a sphere = {{ round( (3/4) * pi * (radius ^ 3) )}}.</td></tr>
<tr><td>code example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/tag_expression_parser_test.dart">tag_expression_parser_test.dart</a></td></tr>
</table>
