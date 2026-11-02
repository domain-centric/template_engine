[//]: # (This file was generated from: doc/template/doc/wiki/06-Constants.md.template using the documentation_builder package)
A [Constant](https://en.wikipedia.org/wiki/Constant_(computer_programming)) is a value that does not change value over time.

The [template_engine](https://pub.dev/packages/template_engine) comes with several mathematical constants.
#### e Constant
<table>
<tr><td>description:</td><td>Base of the natural logarithms.</td></tr>
<tr><td>value:</td><td>2.718281828459045 (double)</td></tr>
<tr><td>test example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/constant/e_test.dart">e_test.dart</a></td></tr>
</table>

#### ln10 Constant
<table>
<tr><td>description:</td><td>Natural logarithm of 10.</td></tr>
<tr><td>value:</td><td>2.302585092994046 (double)</td></tr>
<tr><td>test example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/constant/ln10_test.dart">ln10_test.dart</a></td></tr>
</table>

#### ln2 Constant
<table>
<tr><td>description:</td><td>Natural logarithm of 2.</td></tr>
<tr><td>value:</td><td>0.6931471805599453 (double)</td></tr>
<tr><td>test example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/constant/ln2_test.dart">ln2_test.dart</a></td></tr>
</table>

#### log10e Constant
<table>
<tr><td>description:</td><td>Base-10 logarithm of e.</td></tr>
<tr><td>value:</td><td>0.4342944819032518 (double)</td></tr>
<tr><td>test example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/constant/log10e_test.dart">log10e_test.dart</a></td></tr>
</table>

#### log2e Constant
<table>
<tr><td>description:</td><td>Base-2 logarithm of e.</td></tr>
<tr><td>value:</td><td>1.4426950408889634 (double)</td></tr>
<tr><td>test example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/constant/log2e_test.dart">log2e_test.dart</a></td></tr>
</table>

#### pi Constant
<table>
<tr><td>description:</td><td>The ratio of a circle's circumference to its diameter</td></tr>
<tr><td>value:</td><td>3.141592653589793 (double)</td></tr>
<tr><td>test example:</td><td><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/constant/pi_test.dart">pi_test.dart</a></td></tr>
</table>

### Custom constants
You can use the constant that are packaged with Template Engine, but you can also add or replace these with your own custom made constants. This is done by creating your own TemplateEngineConfiguration or adding to it using the withAdditionalConstants() method

Example: <a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/expression/constant/custom_constant_test.dart">custom_constant_test.dart</a>
