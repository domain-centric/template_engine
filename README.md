
![](https://raw.githubusercontent.com/domain-centric/template_engine/main/doc/template/template_engine.png)

A flexible Dart library to parse templates and render output such as:
* [Html](https://en.wikipedia.org/wiki/HTML)
* [Programming code](https://en.wikipedia.org/wiki/Programming_language)
* [Markdown](https://en.wikipedia.org/wiki/Markdown)
* [Xml](https://en.wikipedia.org/wiki/XML), [Json](https://en.wikipedia.org/wiki/JSON), [Yaml](https://en.wikipedia.org/wiki/YAML)
* Etc...

## Features
- Variable Tags: get values form variables and nested variables
- Function Tags: call your Dart code to generate values with optional attributes

## Getting started

See: [Installing](https://pub.dev/packages/template_engine/install)

## Usage

```dart
import 'package:template_engine/template_engine.dart';

void main() {
  var template = TextTemplate('Hello {{name}}.');
  // See also FileTemplate and WebTemplate
  var engine = TemplateEngine();
  var parseResult = engine.parse(template, {'name': 'world'});
  // Here you could additionally mutate or validate the parseResult if needed.
  print(engine.render(parseResult)); // should print 'Hello world.';
}
```

For more see: [Examples](https://pub.dev/packages/template_engine/example)
# Math Functions
<table>
<tr><th colspan="5">exp</th></tr>
<tr><td>description:</td><td colspan="4">Returns the natural exponent e, to the power of the value</td></tr>
<tr><td>return type:</td><td colspan="4">number</td></tr>
<tr><td>example:</td><td colspan="2">{{exp(7)}}</td><td colspan="2">1096.6331584284585</td></tr>
<tr><td>parameter:</td><td>value</td><td>number</td><td colspan="2">mandatory</td></tr>
</table>
<table>
<tr><th colspan="5">log</th></tr>
<tr><td>description:</td><td colspan="4">Returns the natural logarithm of the value</td></tr>
<tr><td>return type:</td><td colspan="4">number</td></tr>
<tr><td>example:</td><td colspan="2">{{log(7)}}</td><td colspan="2">1.9459101490553132</td></tr>
<tr><td>parameter:</td><td>value</td><td>number</td><td colspan="2">mandatory</td></tr>
</table>
<table>
<tr><th colspan="5">sin</th></tr>
<tr><td>description:</td><td colspan="4">Returns the sine of the radians</td></tr>
<tr><td>return type:</td><td colspan="4">number</td></tr>
<tr><td>example:</td><td colspan="2">{{sin(7)}}</td><td colspan="2">0.6569865987187891</td></tr>
<tr><td>parameter:</td><td>radians</td><td>number</td><td colspan="2">mandatory</td></tr>
</table>
<table>
<tr><th colspan="5">asin</th></tr>
<tr><td>description:</td><td colspan="4">Returns the values arc sine in radians</td></tr>
<tr><td>return type:</td><td colspan="4">number</td></tr>
<tr><td>example:</td><td colspan="2">{{asin(0.5)}}</td><td colspan="2">0.5235987755982989</td></tr>
<tr><td>parameter:</td><td>value</td><td>number</td><td colspan="2">mandatory</td></tr>
</table>
<table>
<tr><th colspan="5">cos</th></tr>
<tr><td>description:</td><td colspan="4">Returns the cosine of the radians</td></tr>
<tr><td>return type:</td><td colspan="4">number</td></tr>
<tr><td>example:</td><td colspan="2">{{cos(7)}}</td><td colspan="2">0.7539022543433046</td></tr>
<tr><td>parameter:</td><td>radians</td><td>number</td><td colspan="2">mandatory</td></tr>
</table>
<table>
<tr><th colspan="5">acos</th></tr>
<tr><td>description:</td><td colspan="4">Returns the values arc cosine in radians</td></tr>
<tr><td>return type:</td><td colspan="4">number</td></tr>
<tr><td>example:</td><td colspan="2">{{acos(0.5)}}</td><td colspan="2">1.0471975511965979</td></tr>
<tr><td>parameter:</td><td>value</td><td>number</td><td colspan="2">mandatory</td></tr>
</table>
<table>
<tr><th colspan="5">tan</th></tr>
<tr><td>description:</td><td colspan="4">Returns the the tangent of the radians</td></tr>
<tr><td>return type:</td><td colspan="4">number</td></tr>
<tr><td>example:</td><td colspan="2">{{tan(7)}}</td><td colspan="2">0.8714479827243188</td></tr>
<tr><td>parameter:</td><td>radians</td><td>number</td><td colspan="2">mandatory</td></tr>
</table>
<table>
<tr><th colspan="5">atan</th></tr>
<tr><td>description:</td><td colspan="4">Returns the values arc tangent in radians</td></tr>
<tr><td>return type:</td><td colspan="4">number</td></tr>
<tr><td>example:</td><td colspan="2">{{atan(0.5)}}</td><td colspan="2">0.4636476090008061</td></tr>
<tr><td>parameter:</td><td>value</td><td>number</td><td colspan="2">mandatory</td></tr>
</table>
<table>
<tr><th colspan="5">sqrt</th></tr>
<tr><td>description:</td><td colspan="4">Returns the positive square root of the value.</td></tr>
<tr><td>return type:</td><td colspan="4">number</td></tr>
<tr><td>example:</td><td colspan="2">{{sqrt(9)}}</td><td colspan="2">3.0</td></tr>
<tr><td>parameter:</td><td>value</td><td>number</td><td colspan="2">mandatory</td></tr>
</table>
# String Functions
<table>
<tr><th colspan="5">length</th></tr>
<tr><td>description:</td><td colspan="4">Returns the length of a string</td></tr>
<tr><td>return type:</td><td colspan="4">number</td></tr>
<tr><td>example:</td><td colspan="2">{{length("Hello")}}</td><td colspan="2">5</td></tr>
<tr><td>parameter:</td><td>string</td><td>String</td><td colspan="2">mandatory</td></tr>
</table>
# Documentation Functions
<table>
<tr><th colspan="5">engine.tag.documentation</th></tr>
<tr><td>description:</td><td colspan="4">Generates markdown documentation of all the tags within a TemplateEngine</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>example:</td><td colspan="4">{{ engine.tag.documentation() }}</td></tr>
<tr><td>parameter:</td><td>titleLevel</td><td>number</td><td>optional (default=1)</td><td>The level of the tag title</td></tr>
</table>
<table>
<tr><th colspan="5">engine.function.documentation</th></tr>
<tr><td>description:</td><td colspan="4">Generates markdown documentation of all the functions that can be used within a ExpressionTag of a TemplateEngine</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>example:</td><td colspan="4">{{ engine.function.documentation() }}</td></tr>
<tr><td>parameter:</td><td>titleLevel</td><td>number</td><td>optional (default=1)</td><td>The level of the tag title</td></tr>
</table>
