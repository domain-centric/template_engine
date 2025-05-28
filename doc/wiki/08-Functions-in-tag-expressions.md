[//]: # (This file was generated from: doc/template/doc/wiki/08-Functions-in-tag-expressions.md.template using the documentation_builder package)
[//]: # (TODO: This text should be imported from the dart doc of the ExpressionFunction class using document_generator package)
A function is a piece of dart code that performs a specific task. 
So a function can basically do anything that dart code can do.
 
A function can be used anywhere in an tag expression. Wherever that particular task should be performed.

An example of a function call: cos(pi)
Should result in: -1

[//]: # (TODO: This text should be imported from the dart doc of the Identifier class using document_generator package)
**Function & Parameter & argument names:**
* are [case sensitive](https://en.wikipedia.org/wiki/Case_sensitivity) 
* must start with a lower case letter, optionally followed by (lower or upper case) letters and or digits.
* conventions: use [lowerCamelCase](https://en.wikipedia.org/wiki/Camel_case)
* must be unique and does not match a other [Tag] syntax

**Parameters vs Arguments**
* Parameters are the names used in the function definition.
* Arguments are the actual values passed when calling the function.

**Parameters:**
* A function can have zero or more parameters
* Parameters are defined as either mandatory or optional
* Optional parameters can have a default value

[//]: # (TODO: This text should be imported from the dart doc of the ArgumentParser class using document_generator package)
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
[//]: # (TODO: replace link with function)
See [Example](https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/function/custom_function_test.dart). 

## Available Functions
## Import Functions
### importTemplate Function
<table>
<tr><td>description:</td><td colspan="4">Imports, parses and renders a template file</td></tr>
<tr><td>return type:</td><td colspan="4">IntermediateRenderResult</td></tr>
<tr><td>expression example:</td><td colspan="4">{{importTemplate('doc/template/common/generated_comment.template')}}</td></tr>
<tr><td>code example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/function/import/import_template_test.dart">import_template_test.dart</a></td></tr>
<tr><td>parameter:</td><td>source</td><td>String</td><td>mandatory</td><td>The project path of the template file</td></tr>
</table>

### importPure Function
<table>
<tr><td>description:</td><td colspan="4">Imports a file as is (without parsing and rendering)</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>expression example:</td><td colspan="4">{{importPure('test/src/template_engine_template_example_test.dart')}}</td></tr>
<tr><td>code example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/function/import/import_pure_test.dart">import_pure_test.dart</a></td></tr>
<tr><td>parameter:</td><td>source</td><td>String</td><td>mandatory</td><td>The project path of the file. This path can be a absolute or relative file path or URI.</td></tr>
</table>

### importCode Function
<table>
<tr><td>description:</td><td colspan="4">A markdown code block that imports a code file.</td></tr>
<tr><td>return type:</td><td colspan="4">Object</td></tr>
<tr><td>expression example:</td><td colspan="4">{{importCode('test/src/template_engine_template_example_test.dart')}}</td></tr>
<tr><td>parameter:</td><td>source</td><td>String</td><td>mandatory</td><td>The project path of the code file to importThis path can be a absolute or relative file path or URI.</td></tr>
<tr><td>parameter:</td><td>language</td><td>String</td><td>optional (default="")</td><td>You can specify the language to optimize syntax highlighting, e.g. html, dart, ruby</td></tr>
<tr><td>parameter:</td><td>sourceHeader</td><td>boolean</td><td>optional (default=true)</td><td>Adds the source path as a header</td></tr>
</table>

### importDartCode Function
<table>
<tr><td>description:</td><td colspan="4">A markdown code block that imports a dart code file.</td></tr>
<tr><td>return type:</td><td colspan="4">Object</td></tr>
<tr><td>expression example:</td><td colspan="4">{{importDartCode('test/src/template_engine_template_example_test.dart')}}</td></tr>
<tr><td>parameter:</td><td>source</td><td>String</td><td>mandatory</td><td>The project path of the dart code file to import.This path can be a absolute or relative file path or URI.</td></tr>
<tr><td>parameter:</td><td>sourceHeader</td><td>boolean</td><td>optional (default=true)</td><td>Adds the source path as a header</td></tr>
</table>

### importDartDoc Function
<table>
<tr><td>description:</td><td colspan="4">A markdown code block that imports dat documentation comments for a given library member from a dart code file.:
* /// will be removed.* Text between [] in the Dart documentation could represent references.* These references will be replaced to links if possible or nessasary. This is done in the following order:  * hyper links, e.g. [Google](https://google.com)
  * links to pub.dev packages, e.g. [documentation_builder]
  * links to dart members, e.g. [MyClass] or [myField] or [MyClass.myField]
* Note that tags have no place in dart documentation comments and will therefore not be resolved. Use references or links instead (see above)</td></tr>
<tr><td>return type:</td><td colspan="4">Object</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ImportDartDoc('test/src/template_engine_template_example_test.dart')}}</td></tr>
<tr><td>parameter:</td><td>source</td><td>String</td><td>mandatory</td><td>A reference to a piece of your Dart source code.
This could be anything from a whole dart file to one of its members.
Format: <DartFilePath>|<DartMemberPath>
* <DartFilePath> (required) is a DartFilePath to a Dart file without dart extension, e.g. lib/my_library.dart
* #: the <DartFilePath> and <DartMemberPath> are separated with a hash
* <DartMemberPath> (optional) is a dot separated path to the member inside the Dart file, e.g.:
  * constant name
  * function name
  * enum name
  * class name
  * extension name

Examples:
* lib/my_library.dart
* lib/my_library.dart|myConstant
* lib/my_library.dart|myFunction
* lib/my_library.dart|MyEnum
* lib/my_library.dart|MyEnum.myValue
* lib/my_library.dart|MyClass
* lib/my_library.dart|MyClass.myFieldName
* lib/my_library.dart|MyClass.myFieldName.get
* lib/my_library.dart|MyClass.myFieldName.set
* lib/my_library.dart|MyClass.myMethod
* lib/my_library.dart|MyExtension
* lib/my_library.dart|MyExtension.myFieldName
* lib/my_library.dart|MyExtension.myFieldName.get
* lib/my_library.dart|MyExtension.myFieldName.set
* lib/my_library.dart|MyExtension.myMethod
</td></tr>
</table>

### importJson Function
<table>
<tr><td>description:</td><td colspan="4">Imports a JSON file and decode it to a Map<String, dynamic>, which could be assigned it to a variable.</td></tr>
<tr><td>return type:</td><td colspan="4">Map<String, dynamic></td></tr>
<tr><td>expression example:</td><td colspan="4">{{json=importJson('test/src/parser/tag/expression/function/import/person.json')}}{{json.person.child.name}}</td></tr>
<tr><td>code example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/function/import/import_json_test.dart">import_json_test.dart</a></td></tr>
<tr><td>parameter:</td><td>source</td><td>String</td><td>mandatory</td><td>The project path of the JSON file. This path can be a absolute or relative file path or URI.</td></tr>
</table>

### importXml Function
<table>
<tr><td>description:</td><td colspan="4">Imports a XML file and decode it to a Map<String, dynamic>, which could be assigned it to a variable.</td></tr>
<tr><td>return type:</td><td colspan="4">Map<String, dynamic></td></tr>
<tr><td>expression example:</td><td colspan="4">{{xml=importXml('test/src/parser/tag/expression/function/import/person.xml')}}{{xml.person.child.name}}</td></tr>
<tr><td>code example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/function/import/import_xml_test.dart">import_xml_test.dart</a></td></tr>
<tr><td>parameter:</td><td>source</td><td>String</td><td>mandatory</td><td>The project path of the XML file. This path can be a absolute or relative file path or URI.</td></tr>
</table>

### importYaml Function
<table>
<tr><td>description:</td><td colspan="4">Imports a YAML file and decode it to a Map<String, dynamic>, which could be assigned it to a variable.</td></tr>
<tr><td>return type:</td><td colspan="4">Map<String, dynamic></td></tr>
<tr><td>expression example:</td><td colspan="4">{{yaml=importYaml('test/src/parser/tag/expression/function/import/person.yaml')}}{{yaml.person.child.name}}</td></tr>
<tr><td>code example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/function/import/import_yaml_test.dart">import_yaml_test.dart</a></td></tr>
<tr><td>parameter:</td><td>source</td><td>String</td><td>mandatory</td><td>The project path of the YAML file. This path can be a absolute or relative file path or URI.</td></tr>
</table>

## Generator Functions
### license Function
<table>
<tr><td>description:</td><td colspan="4">Creates a license text for the given type, year and copyright holder</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ license(type='type value', name='name value') }}</td></tr>
<tr><td>parameter:</td><td>type</td><td>String</td><td>mandatory</td><td>Type of license, currently supported: MIT, BSD3</td></tr>
<tr><td>parameter:</td><td>name</td><td>String</td><td>mandatory</td><td>Name of the copyright holder</td></tr>
<tr><td>parameter:</td><td>year</td><td>int</td><td>optional</td><td>Year of the copyright. It wil use the current year if not defined</td></tr>
</table>

### tableOfContents Function
<table>
<tr><td>description:</td><td colspan="4">Markdown table of content with links to all markdown chapters (e.g. # chapter, ## paragraph, ## sub paragraph) of a template file or all template files in a folder.</td></tr>
<tr><td>return type:</td><td colspan="4">Object</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ tableOfContents('path value') }}</td></tr>
<tr><td>parameter:</td><td>path</td><td>String</td><td>mandatory</td><td>A relative project path (always with slash forward) to a template file (e.g.: doc/template/README.md.template) or a folder with template files (e.g.: doc/template/doc/wiki)</td></tr>
<tr><td>parameter:</td><td>includeFileLink</td><td>boolean</td><td>optional (default=true)</td><td>If the title links should be preceded with a link to the file</td></tr>
<tr><td>parameter:</td><td>gitHubWiki</td><td>boolean</td><td>optional (default=false)</td><td>Will remove the .md extension from the links so that they work correctly inside gitHub wiki pages</td></tr>
</table>

### gitHubMileStones Function
<table>
<tr><td>description:</td><td colspan="4">A markdown text of milestones on GitHub. You could use this for the CHANGELOG.md file.</td></tr>
<tr><td>return type:</td><td colspan="4">Object</td></tr>
<tr><td>expression example:</td><td colspan="4">{{gitHubMileStones('test/src/template_engine_template_example_test.dart')}}</td></tr>
<tr><td>parameter:</td><td>state</td><td>String</td><td>optional (default="all")</td><td>The state of the milestones, either: open, closed, all</td></tr>
</table>

## Path Functions
### templateSource Function
<table>
<tr><td>description:</td><td colspan="4">Gives the relative path of the current template</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>expression example:</td><td colspan="4">{{templateSource()}}</td></tr>
<tr><td>code example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/function/template/template_test.dart">template_test.dart</a></td></tr>
</table>

### inputPath Function
<table>
<tr><td>description:</td><td colspan="4">Returns the path of the template file being used.
Prefer to use this function over the 'templateSource' because 'inputPath' always resolves to a path</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>expression example:</td><td colspan="4">{{inputPath()}} should render: doc/example.md</td></tr>
</table>

### outputPath Function
<table>
<tr><td>description:</td><td colspan="4">Returns the path of the file being created from the template</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>expression example:</td><td colspan="4">{{outputPath()}} should render: doc/example.md</td></tr>
</table>

### referenceUri Function
<table>
<tr><td>description:</td><td colspan="4">Returns a URI of Creates a uri from an address.</td></tr>
<tr><td>return type:</td><td colspan="4">Uri</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ referenceUri(???) }}</td></tr>
<tr><td>parameter:</td><td>ref</td><td>dynamic</td><td>mandatory</td><td>The ref (reference) can be:
* a Uri to something on the internet, e.g,: 'https://www.google.com' 
* a package name on pub.dev, e.g.: 'documentation_builder'
* reference to a source file, e.g.: 'example/example.md' or 'lib/src/my_library.dart'
* a reference to dart library member, e.g.: 'lib/src/my_library.dart#MyClass.myField'</td></tr>
</table>

### gitHubUri Function
<table>
<tr><td>description:</td><td colspan="4">Returns a URI of a web page of your project on github.com</td></tr>
<tr><td>return type:</td><td colspan="4">Uri</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ gitHubUri() }}</td></tr>
<tr><td>parameter:</td><td>suffix</td><td>String</td><td>optional</td><td>A suffix to append to the URI (e.g. path, query, fragment, etc)</td></tr>
</table>

### gitHubWikiUri Function
<table>
<tr><td>description:</td><td colspan="4">Returns a URI of a wiki page of your project on github.com</td></tr>
<tr><td>return type:</td><td colspan="4">Uri</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ gitHubWikiUri() }}</td></tr>
<tr><td>parameter:</td><td>suffix</td><td>String</td><td>optional</td><td>A suffix to append to the URI (e.g. path, query, fragment, etc)</td></tr>
</table>

### gitHubStarsUri Function
<table>
<tr><td>description:</td><td colspan="4">Returns a URI of a stars page of your project on github.com</td></tr>
<tr><td>return type:</td><td colspan="4">Uri</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ gitHubStarsUri() }}</td></tr>
<tr><td>parameter:</td><td>suffix</td><td>String</td><td>optional</td><td>A suffix to append to the URI (e.g. path, query, fragment, etc)</td></tr>
</table>

### gitHubIssuesUri Function
<table>
<tr><td>description:</td><td colspan="4">Returns a URI of an issue page of your project on github.com</td></tr>
<tr><td>return type:</td><td colspan="4">Uri</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ gitHubIssuesUri() }}</td></tr>
<tr><td>parameter:</td><td>suffix</td><td>String</td><td>optional</td><td>A suffix to append to the URI (e.g. path, query, fragment, etc)</td></tr>
</table>

### gitHubMilestonesUri Function
<table>
<tr><td>description:</td><td colspan="4">Returns a URI of a milestone page of your project on github.com</td></tr>
<tr><td>return type:</td><td colspan="4">Uri</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ gitHubMilestonesUri() }}</td></tr>
<tr><td>parameter:</td><td>suffix</td><td>String</td><td>optional</td><td>A suffix to append to the URI (e.g. path, query, fragment, etc)</td></tr>
</table>

### gitHubReleasesUri Function
<table>
<tr><td>description:</td><td colspan="4">Returns a URI of a releases page of your project on github.com</td></tr>
<tr><td>return type:</td><td colspan="4">Uri</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ gitHubReleasesUri() }}</td></tr>
<tr><td>parameter:</td><td>suffix</td><td>String</td><td>optional</td><td>A suffix to append to the URI (e.g. path, query, fragment, etc)</td></tr>
</table>

### gitHubPullRequestsUri Function
<table>
<tr><td>description:</td><td colspan="4">Returns a URI of a pull request page of your project on github.com</td></tr>
<tr><td>return type:</td><td colspan="4">Uri</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ gitHubPullRequestsUri() }}</td></tr>
<tr><td>parameter:</td><td>suffix</td><td>String</td><td>optional</td><td>A suffix to append to the URI (e.g. path, query, fragment, etc)</td></tr>
</table>

### gitHubRawUri Function
<table>
<tr><td>description:</td><td colspan="4">Returns a URI of a raw code page of your project on github.com</td></tr>
<tr><td>return type:</td><td colspan="4">Uri</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ gitHubRawUri('suffix value') }}</td></tr>
<tr><td>parameter:</td><td>suffix</td><td>String</td><td>mandatory</td><td>A suffix to append to the URI (e.g. path, query, fragment, etc)</td></tr>
</table>

### pubDevUri Function
<table>
<tr><td>description:</td><td colspan="4">Returns a URI of the home page of your project on pub.dev</td></tr>
<tr><td>return type:</td><td colspan="4">Uri</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ pubDevUri() }}</td></tr>
<tr><td>parameter:</td><td>suffix</td><td>String</td><td>optional</td><td>A suffix to append to the URI (e.g. path, query, fragment, etc)</td></tr>
</table>

### pubDevChangeLogUri Function
<table>
<tr><td>description:</td><td colspan="4">Returns a URI of the change log page of your project on pub.dev</td></tr>
<tr><td>return type:</td><td colspan="4">Uri</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ pubDevChangeLogUri() }}</td></tr>
<tr><td>parameter:</td><td>suffix</td><td>String</td><td>optional</td><td>A suffix to append to the URI (e.g. path, query, fragment, etc)</td></tr>
</table>

### pubDevVersionsUri Function
<table>
<tr><td>description:</td><td colspan="4">Returns a URI of the version page of your project on pub.dev</td></tr>
<tr><td>return type:</td><td colspan="4">Uri</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ pubDevVersionsUri() }}</td></tr>
<tr><td>parameter:</td><td>suffix</td><td>String</td><td>optional</td><td>A suffix to append to the URI (e.g. path, query, fragment, etc)</td></tr>
</table>

### pubDevExampleUri Function
<table>
<tr><td>description:</td><td colspan="4">Returns a URI of the example page of your project on pub.dev</td></tr>
<tr><td>return type:</td><td colspan="4">Uri</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ pubDevExampleUri() }}</td></tr>
<tr><td>parameter:</td><td>suffix</td><td>String</td><td>optional</td><td>A suffix to append to the URI (e.g. path, query, fragment, etc)</td></tr>
</table>

### pubDevInstallUri Function
<table>
<tr><td>description:</td><td colspan="4">Returns a URI of the install page of your project on pub.dev</td></tr>
<tr><td>return type:</td><td colspan="4">Uri</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ pubDevInstallUri() }}</td></tr>
<tr><td>parameter:</td><td>suffix</td><td>String</td><td>optional</td><td>A suffix to append to the URI (e.g. path, query, fragment, etc)</td></tr>
</table>

### pubDevScoreUri Function
<table>
<tr><td>description:</td><td colspan="4">Returns a URI of the score page of your project on pub.dev</td></tr>
<tr><td>return type:</td><td colspan="4">Uri</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ pubDevScoreUri() }}</td></tr>
<tr><td>parameter:</td><td>suffix</td><td>String</td><td>optional</td><td>A suffix to append to the URI (e.g. path, query, fragment, etc)</td></tr>
</table>

### pubDevLicenseUri Function
<table>
<tr><td>description:</td><td colspan="4">Returns a URI of the license page of your project on pub.dev</td></tr>
<tr><td>return type:</td><td colspan="4">Uri</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ pubDevLicenseUri() }}</td></tr>
<tr><td>parameter:</td><td>suffix</td><td>String</td><td>optional</td><td>A suffix to append to the URI (e.g. path, query, fragment, etc)</td></tr>
</table>

## Link Functions
### referenceLink Function
<table>
<tr><td>description:</td><td colspan="4">Returns a markdown hyperlink of Creates a uri from an address.</td></tr>
<tr><td>return type:</td><td colspan="4">MarkDownLink</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ referenceLink(???) }}</td></tr>
<tr><td>parameter:</td><td>ref</td><td>dynamic</td><td>mandatory</td><td>The ref (reference) can be:
* a Uri to something on the internet, e.g,: 'https://www.google.com' 
* a package name on pub.dev, e.g.: 'documentation_builder'
* reference to a source file, e.g.: 'example/example.md' or 'lib/src/my_library.dart'
* a reference to dart library member, e.g.: 'lib/src/my_library.dart#MyClass.myField'</td></tr>
<tr><td>parameter:</td><td>text</td><td>String</td><td>optional</td><td>The text of the hyperlink. An appropriate text will be provided if no text is defined</td></tr>
</table>

### gitHubLink Function
<table>
<tr><td>description:</td><td colspan="4">Returns a markdown hyperlink of a web page of your project on github.com</td></tr>
<tr><td>return type:</td><td colspan="4">MarkDownLink</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ gitHubLink() }}</td></tr>
<tr><td>parameter:</td><td>suffix</td><td>String</td><td>optional</td><td>A suffix to append to the URI (e.g. path, query, fragment, etc)</td></tr>
<tr><td>parameter:</td><td>text</td><td>String</td><td>optional</td><td>The text of the hyperlink. An appropriate text will be provided if no text is defined</td></tr>
</table>

### gitHubWikiLink Function
<table>
<tr><td>description:</td><td colspan="4">Returns a markdown hyperlink of a wiki page of your project on github.com</td></tr>
<tr><td>return type:</td><td colspan="4">MarkDownLink</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ gitHubWikiLink() }}</td></tr>
<tr><td>parameter:</td><td>suffix</td><td>String</td><td>optional</td><td>A suffix to append to the URI (e.g. path, query, fragment, etc)</td></tr>
<tr><td>parameter:</td><td>text</td><td>String</td><td>optional</td><td>The text of the hyperlink. An appropriate text will be provided if no text is defined</td></tr>
</table>

### gitHubStarsLink Function
<table>
<tr><td>description:</td><td colspan="4">Returns a markdown hyperlink of a stars page of your project on github.com</td></tr>
<tr><td>return type:</td><td colspan="4">MarkDownLink</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ gitHubStarsLink() }}</td></tr>
<tr><td>parameter:</td><td>suffix</td><td>String</td><td>optional</td><td>A suffix to append to the URI (e.g. path, query, fragment, etc)</td></tr>
<tr><td>parameter:</td><td>text</td><td>String</td><td>optional</td><td>The text of the hyperlink. An appropriate text will be provided if no text is defined</td></tr>
</table>

### gitHubIssuesLink Function
<table>
<tr><td>description:</td><td colspan="4">Returns a markdown hyperlink of an issue page of your project on github.com</td></tr>
<tr><td>return type:</td><td colspan="4">MarkDownLink</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ gitHubIssuesLink() }}</td></tr>
<tr><td>parameter:</td><td>suffix</td><td>String</td><td>optional</td><td>A suffix to append to the URI (e.g. path, query, fragment, etc)</td></tr>
<tr><td>parameter:</td><td>text</td><td>String</td><td>optional</td><td>The text of the hyperlink. An appropriate text will be provided if no text is defined</td></tr>
</table>

### gitHubMilestonesLink Function
<table>
<tr><td>description:</td><td colspan="4">Returns a markdown hyperlink of a milestone page of your project on github.com</td></tr>
<tr><td>return type:</td><td colspan="4">MarkDownLink</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ gitHubMilestonesLink() }}</td></tr>
<tr><td>parameter:</td><td>suffix</td><td>String</td><td>optional</td><td>A suffix to append to the URI (e.g. path, query, fragment, etc)</td></tr>
<tr><td>parameter:</td><td>text</td><td>String</td><td>optional</td><td>The text of the hyperlink. An appropriate text will be provided if no text is defined</td></tr>
</table>

### gitHubReleasesLink Function
<table>
<tr><td>description:</td><td colspan="4">Returns a markdown hyperlink of a releases page of your project on github.com</td></tr>
<tr><td>return type:</td><td colspan="4">MarkDownLink</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ gitHubReleasesLink() }}</td></tr>
<tr><td>parameter:</td><td>suffix</td><td>String</td><td>optional</td><td>A suffix to append to the URI (e.g. path, query, fragment, etc)</td></tr>
<tr><td>parameter:</td><td>text</td><td>String</td><td>optional</td><td>The text of the hyperlink. An appropriate text will be provided if no text is defined</td></tr>
</table>

### gitHubPullRequestsLink Function
<table>
<tr><td>description:</td><td colspan="4">Returns a markdown hyperlink of a pull request page of your project on github.com</td></tr>
<tr><td>return type:</td><td colspan="4">MarkDownLink</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ gitHubPullRequestsLink() }}</td></tr>
<tr><td>parameter:</td><td>suffix</td><td>String</td><td>optional</td><td>A suffix to append to the URI (e.g. path, query, fragment, etc)</td></tr>
<tr><td>parameter:</td><td>text</td><td>String</td><td>optional</td><td>The text of the hyperlink. An appropriate text will be provided if no text is defined</td></tr>
</table>

### gitHubRawLink Function
<table>
<tr><td>description:</td><td colspan="4">Returns a markdown hyperlink of a raw code page of your project on github.com</td></tr>
<tr><td>return type:</td><td colspan="4">MarkDownLink</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ gitHubRawLink('suffix value') }}</td></tr>
<tr><td>parameter:</td><td>suffix</td><td>String</td><td>mandatory</td><td>A suffix to append to the URI (e.g. path, query, fragment, etc)</td></tr>
<tr><td>parameter:</td><td>text</td><td>String</td><td>optional</td><td>The text of the hyperlink. An appropriate text will be provided if no text is defined</td></tr>
</table>

### pubDevLink Function
<table>
<tr><td>description:</td><td colspan="4">Returns a markdown hyperlink of the home page of your project on pub.dev</td></tr>
<tr><td>return type:</td><td colspan="4">MarkDownLink</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ pubDevLink() }}</td></tr>
<tr><td>parameter:</td><td>suffix</td><td>String</td><td>optional</td><td>A suffix to append to the URI (e.g. path, query, fragment, etc)</td></tr>
<tr><td>parameter:</td><td>text</td><td>String</td><td>optional</td><td>The text of the hyperlink. An appropriate text will be provided if no text is defined</td></tr>
</table>

### pubDevChangeLogLink Function
<table>
<tr><td>description:</td><td colspan="4">Returns a markdown hyperlink of the change log page of your project on pub.dev</td></tr>
<tr><td>return type:</td><td colspan="4">MarkDownLink</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ pubDevChangeLogLink() }}</td></tr>
<tr><td>parameter:</td><td>suffix</td><td>String</td><td>optional</td><td>A suffix to append to the URI (e.g. path, query, fragment, etc)</td></tr>
<tr><td>parameter:</td><td>text</td><td>String</td><td>optional</td><td>The text of the hyperlink. An appropriate text will be provided if no text is defined</td></tr>
</table>

### pubDevVersionsLink Function
<table>
<tr><td>description:</td><td colspan="4">Returns a markdown hyperlink of the version page of your project on pub.dev</td></tr>
<tr><td>return type:</td><td colspan="4">MarkDownLink</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ pubDevVersionsLink() }}</td></tr>
<tr><td>parameter:</td><td>suffix</td><td>String</td><td>optional</td><td>A suffix to append to the URI (e.g. path, query, fragment, etc)</td></tr>
<tr><td>parameter:</td><td>text</td><td>String</td><td>optional</td><td>The text of the hyperlink. An appropriate text will be provided if no text is defined</td></tr>
</table>

### pubDevExampleLink Function
<table>
<tr><td>description:</td><td colspan="4">Returns a markdown hyperlink of the example page of your project on pub.dev</td></tr>
<tr><td>return type:</td><td colspan="4">MarkDownLink</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ pubDevExampleLink() }}</td></tr>
<tr><td>parameter:</td><td>suffix</td><td>String</td><td>optional</td><td>A suffix to append to the URI (e.g. path, query, fragment, etc)</td></tr>
<tr><td>parameter:</td><td>text</td><td>String</td><td>optional</td><td>The text of the hyperlink. An appropriate text will be provided if no text is defined</td></tr>
</table>

### pubDevInstallLink Function
<table>
<tr><td>description:</td><td colspan="4">Returns a markdown hyperlink of the install page of your project on pub.dev</td></tr>
<tr><td>return type:</td><td colspan="4">MarkDownLink</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ pubDevInstallLink() }}</td></tr>
<tr><td>parameter:</td><td>suffix</td><td>String</td><td>optional</td><td>A suffix to append to the URI (e.g. path, query, fragment, etc)</td></tr>
<tr><td>parameter:</td><td>text</td><td>String</td><td>optional</td><td>The text of the hyperlink. An appropriate text will be provided if no text is defined</td></tr>
</table>

### pubDevScoreLink Function
<table>
<tr><td>description:</td><td colspan="4">Returns a markdown hyperlink of the score page of your project on pub.dev</td></tr>
<tr><td>return type:</td><td colspan="4">MarkDownLink</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ pubDevScoreLink() }}</td></tr>
<tr><td>parameter:</td><td>suffix</td><td>String</td><td>optional</td><td>A suffix to append to the URI (e.g. path, query, fragment, etc)</td></tr>
<tr><td>parameter:</td><td>text</td><td>String</td><td>optional</td><td>The text of the hyperlink. An appropriate text will be provided if no text is defined</td></tr>
</table>

### pubDevLicenseLink Function
<table>
<tr><td>description:</td><td colspan="4">Returns a markdown hyperlink of the license page of your project on pub.dev</td></tr>
<tr><td>return type:</td><td colspan="4">MarkDownLink</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ pubDevLicenseLink() }}</td></tr>
<tr><td>parameter:</td><td>suffix</td><td>String</td><td>optional</td><td>A suffix to append to the URI (e.g. path, query, fragment, etc)</td></tr>
<tr><td>parameter:</td><td>text</td><td>String</td><td>optional</td><td>The text of the hyperlink. An appropriate text will be provided if no text is defined</td></tr>
</table>

## Badge Functions
### customBadge Function
<table>
<tr><td>description:</td><td colspan="4">Creates markdown for a customizable badge image</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>expression example:</td><td colspan="4">{{customBadge(tooltip='GitHub License' label='license' message='MIT' link='https://github.com/domain-centric/documentation_builder/blob/main/LICENSE')}} should render: [![GitHub License](https://img.shields.io/badge/license-MIT-informational)](https://github.com/domain-centric/documentation_builder/blob/main/LICENSE)</td></tr>
<tr><td>parameter:</td><td>toolTip</td><td>String</td><td>optional</td><td>This text becomes visible when hoovering over a badge</td></tr>
<tr><td>parameter:</td><td>label</td><td>String</td><td>mandatory</td><td>The label is the left text of the badge and is often lower case text</td></tr>
<tr><td>parameter:</td><td>message</td><td>String</td><td>mandatory</td><td>The label is the left message is the right text of the badge and can have a fill color</td></tr>
<tr><td>parameter:</td><td>color</td><td>String</td><td>optional (default="informational")</td><td>The message is the right text of the [Badge] and can have fill color.
The color can be defined in different ways:
As color name:
- brightgreen
- green
- yellowgreen
- yellow
- orange
- red
- blue
- lightgrey
- blueviolet
As name
- success
- important
- critical
- informational (=default)
- inactive
As code:
- ff69b4
- 9cf
</td></tr>
<tr><td>parameter:</td><td>link</td><td>String</td><td>mandatory</td><td>A Uri that points to a web site page.</td></tr>
</table>

### pubPackageBadge Function
<table>
<tr><td>description:</td><td colspan="4">Creates markdown for a badge of an existing Dart or Flutter package on pub.dev</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ pubPackageBadge() }} should render: [![Pub Package](https://img.shields.io/pub/v/documentation_builder)](https://pub.dev/packages/documentation_builder)</td></tr>
<tr><td>parameter:</td><td>toolTip</td><td>String</td><td>optional (default="Pub Package")</td><td>This text becomes visible when hoovering over a badge</td></tr>
</table>

### pubScoresBadge Function
<table>
<tr><td>description:</td><td colspan="4">Creates markdown for a badge of the scores on pub.dev</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ pubScoresBadge() }} should render: [![Pub Scores](https://img.shields.io/pub/likes/documentation_builder)</td></tr>
<tr><td>parameter:</td><td>toolTip</td><td>String</td><td>optional (default="Pub Scores")</td><td>This text becomes visible when hoovering over a badge</td></tr>
</table>

### allPubBadges Function
<table>
<tr><td>description:</td><td colspan="4">Creates markdown for all pub.dev badges</td></tr>
<tr><td>return type:</td><td colspan="4">Object</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ allPubBadges() }}</td></tr>
</table>

### gitHubBadge Function
<table>
<tr><td>description:</td><td colspan="4">Creates markdown for a badge of a project on github.com</td></tr>
<tr><td>return type:</td><td colspan="4">Object</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ gitHubBadge() }} should render: [![Project on github.com](https://img.shields.io/badge/repository-git%20hub-informational)](https://github.com/domain-centric/documentation_builder)</td></tr>
<tr><td>parameter:</td><td>toolTip</td><td>String</td><td>optional (default="Project on github.com")</td><td>This text becomes visible when hoovering over a badge</td></tr>
</table>

### gitHubWikiBadge Function
<table>
<tr><td>description:</td><td colspan="4">Creates markdown for a badge of the Wiki pages of a project on GitHub.com</td></tr>
<tr><td>return type:</td><td colspan="4">Object</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ gitHubWikiBadge() }} should render: [![Project Wiki pages on github.com](https://img.shields.io/badge/documentation-wiki-informational)](https://github.com/domain-centric/documentation_builder/wiki)</td></tr>
<tr><td>parameter:</td><td>toolTip</td><td>String</td><td>optional (default="Project Wiki pages on github.com")</td><td>This text becomes visible when hoovering over a badge</td></tr>
</table>

### gitHubStarsBadge Function
<table>
<tr><td>description:</td><td colspan="4">Creates markdown for a badge with the amount of stars on github.com</td></tr>
<tr><td>return type:</td><td colspan="4">Object</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ gitHubStarsBadge() }} should render: [![Stars ranking on github.com](https://img.shields.io/github/stars/domain-centric/documentation_builder?style=flat)](https://github.com/domain-centric/documentation_builder/stargazers)</td></tr>
<tr><td>parameter:</td><td>toolTip</td><td>String</td><td>optional (default="Stars ranking on github.com")</td><td>This text becomes visible when hoovering over a badge</td></tr>
</table>

### gitHubIssuesBadge Function
<table>
<tr><td>description:</td><td colspan="4">Creates markdown for a badge with the amount of open issues on github.com</td></tr>
<tr><td>return type:</td><td colspan="4">Object</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ gitHubIssuesBadge() }} should render: [![Open issues on github.com](https://img.shields.io/github/issues/domain-centric/documentation_builder)](https://github.com/domain-centric/documentation_builder/issues)</td></tr>
<tr><td>parameter:</td><td>toolTip</td><td>String</td><td>optional (default="Open issues on github.com")</td><td>This text becomes visible when hoovering over a badge</td></tr>
</table>

### gitHubPullRequestsBadge Function
<table>
<tr><td>description:</td><td colspan="4">Creates markdown for a badge with the amount of open pull requests on github.com</td></tr>
<tr><td>return type:</td><td colspan="4">Object</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ gitHubPullRequestsBadge() }} should render: [![Open pull requests on github.com](https://img.shields.io/github/issues-pr/domain-centric/documentation_builder)](https://github.com/domain-centric/documentation_builder/pull)</td></tr>
<tr><td>parameter:</td><td>toolTip</td><td>String</td><td>optional (default="Open pull requests on github.com")</td><td>This text becomes visible when hoovering over a badge</td></tr>
</table>

### gitHubLicenseBadge Function
<table>
<tr><td>description:</td><td colspan="4">Creates markdown for a badge with the amount of open pull requests on github.com</td></tr>
<tr><td>return type:</td><td colspan="4">Object</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ gitHubLicenseBadge() }} should render: [![Project License](https://img.shields.io/github/license/domain-centric/documentation_buider)](https://github.com/domain-centric/documentation_builder/blob/main/LICENSE)</td></tr>
<tr><td>parameter:</td><td>toolTip</td><td>String</td><td>optional (default="Project License")</td><td>This text becomes visible when hoovering over a badge</td></tr>
</table>

### allGitHubBadges Function
<table>
<tr><td>description:</td><td colspan="4">Creates markdown for all github.com badges</td></tr>
<tr><td>return type:</td><td colspan="4">Object</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ allGitHubBadges() }}</td></tr>
</table>

### allPubGitHubBadges Function
<table>
<tr><td>description:</td><td colspan="4">Creates markdown for all pub.dev and github.com badges</td></tr>
<tr><td>return type:</td><td colspan="4">Object</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ allPubGitHubBadges() }}</td></tr>
</table>

## Math Functions
### exp Function
<table>
<tr><td>description:</td><td colspan="4">Returns the natural exponent e, to the power of the value</td></tr>
<tr><td>return type:</td><td colspan="4">number</td></tr>
<tr><td>expression example:</td><td colspan="4">{{exp(7)}} should render: 1096.6331584284585</td></tr>
<tr><td>code example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/function/math/exp_test.dart">exp_test.dart</a></td></tr>
<tr><td>parameter:</td><td>value</td><td>number</td><td colspan="2">mandatory</td></tr>
</table>

### log Function
<table>
<tr><td>description:</td><td colspan="4">Returns the natural logarithm of the value</td></tr>
<tr><td>return type:</td><td colspan="4">number</td></tr>
<tr><td>expression example:</td><td colspan="4">{{log(7)}} should render: 1.9459101490553132</td></tr>
<tr><td>code example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/function/math/log_test.dart">log_test.dart</a></td></tr>
<tr><td>parameter:</td><td>value</td><td>number</td><td colspan="2">mandatory</td></tr>
</table>

### sin Function
<table>
<tr><td>description:</td><td colspan="4">Returns the sine of the radians</td></tr>
<tr><td>return type:</td><td colspan="4">number</td></tr>
<tr><td>expression example:</td><td colspan="4">{{sin(7)}} should render: 0.6569865987187891</td></tr>
<tr><td>code example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/function/math/sin_test.dart">sin_test.dart</a></td></tr>
<tr><td>parameter:</td><td>radians</td><td>number</td><td colspan="2">mandatory</td></tr>
</table>

### asin Function
<table>
<tr><td>description:</td><td colspan="4">Returns the values arc sine in radians</td></tr>
<tr><td>return type:</td><td colspan="4">number</td></tr>
<tr><td>expression example:</td><td colspan="4">{{asin(0.5)}} should render: 0.5235987755982989</td></tr>
<tr><td>code example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/function/math/asin_test.dart">asin_test.dart</a></td></tr>
<tr><td>parameter:</td><td>value</td><td>number</td><td colspan="2">mandatory</td></tr>
</table>

### cos Function
<table>
<tr><td>description:</td><td colspan="4">Returns the cosine of the radians</td></tr>
<tr><td>return type:</td><td colspan="4">number</td></tr>
<tr><td>expression example:</td><td colspan="4">{{cos(7)}} should render: 0.7539022543433046</td></tr>
<tr><td>code example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/function/math/cos_test.dart">cos_test.dart</a></td></tr>
<tr><td>parameter:</td><td>radians</td><td>number</td><td colspan="2">mandatory</td></tr>
</table>

### acos Function
<table>
<tr><td>description:</td><td colspan="4">Returns the values arc cosine in radians</td></tr>
<tr><td>return type:</td><td colspan="4">number</td></tr>
<tr><td>expression example:</td><td colspan="4">{{acos(0.5)}} should render: 1.0471975511965979</td></tr>
<tr><td>code example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/function/math/acos_test.dart">acos_test.dart</a></td></tr>
<tr><td>parameter:</td><td>value</td><td>number</td><td colspan="2">mandatory</td></tr>
</table>

### tan Function
<table>
<tr><td>description:</td><td colspan="4">Returns the the tangent of the radians</td></tr>
<tr><td>return type:</td><td colspan="4">number</td></tr>
<tr><td>expression example:</td><td colspan="4">{{tan(7)}} should render: 0.8714479827243188</td></tr>
<tr><td>code example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/function/math/tan_test.dart">tan_test.dart</a></td></tr>
<tr><td>parameter:</td><td>radians</td><td>number</td><td colspan="2">mandatory</td></tr>
</table>

### atan Function
<table>
<tr><td>description:</td><td colspan="4">Returns the values arc tangent in radians</td></tr>
<tr><td>return type:</td><td colspan="4">number</td></tr>
<tr><td>expression example:</td><td colspan="4">{{atan(0.5)}} should render: 0.4636476090008061</td></tr>
<tr><td>code example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/function/math/atan_test.dart">atan_test.dart</a></td></tr>
<tr><td>parameter:</td><td>value</td><td>number</td><td colspan="2">mandatory</td></tr>
</table>

### sqrt Function
<table>
<tr><td>description:</td><td colspan="4">Returns the positive square root of the value.</td></tr>
<tr><td>return type:</td><td colspan="4">number</td></tr>
<tr><td>expression example:</td><td colspan="4">{{sqrt(9)}} should render: 3.0</td></tr>
<tr><td>code example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/function/math/sqrt_test.dart">sqrt_test.dart</a></td></tr>
<tr><td>parameter:</td><td>value</td><td>number</td><td colspan="2">mandatory</td></tr>
</table>

### round Function
<table>
<tr><td>description:</td><td colspan="4">Returns the a rounded number.</td></tr>
<tr><td>return type:</td><td colspan="4">number</td></tr>
<tr><td>expression example:</td><td colspan="4">{{round(4.445)}} should render: 4</td></tr>
<tr><td>code example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/function/math/round_test.dart">round_test.dart</a></td></tr>
<tr><td>parameter:</td><td>value</td><td>number</td><td colspan="2">mandatory</td></tr>
</table>

## String Functions
### length Function
<table>
<tr><td>description:</td><td colspan="4">Returns the length of a string</td></tr>
<tr><td>return type:</td><td colspan="4">number</td></tr>
<tr><td>expression example:</td><td colspan="4">{{length("Hello")}} should render: 5</td></tr>
<tr><td>code example:</td><td colspan="4"><a href="https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/function/string/length_test.dart">length_test.dart</a></td></tr>
<tr><td>parameter:</td><td>string</td><td>String</td><td colspan="2">mandatory</td></tr>
</table>

## Documentation Functions
### tagDocumentation Function
<table>
<tr><td>description:</td><td colspan="4">Generates markdown documentation of all the tags within a TemplateEngine</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ tagDocumentation() }}</td></tr>
<tr><td>parameter:</td><td>titleLevel</td><td>number</td><td>optional (default=1)</td><td>The level of the tag title</td></tr>
</table>

### dataTypeDocumentation Function
<table>
<tr><td>description:</td><td colspan="4">Generates markdown documentation of all the data types that can be used within a ExpressionTag of a TemplateEngine</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ dataTypeDocumentation() }}</td></tr>
<tr><td>parameter:</td><td>titleLevel</td><td>number</td><td>optional (default=1)</td><td>The level of the tag title</td></tr>
</table>

### constantDocumentation Function
<table>
<tr><td>description:</td><td colspan="4">Generates markdown documentation of all the constants that can be used within a ExpressionTag of a TemplateEngine</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ constantDocumentation() }}</td></tr>
<tr><td>parameter:</td><td>titleLevel</td><td>number</td><td>optional (default=1)</td><td>The level of the tag title</td></tr>
</table>

### functionDocumentation Function
<table>
<tr><td>description:</td><td colspan="4">Generates markdown documentation of all the functions that can be used within a ExpressionTag of a TemplateEngine</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ functionDocumentation() }}</td></tr>
<tr><td>parameter:</td><td>titleLevel</td><td>number</td><td>optional (default=1)</td><td>The level of the tag title</td></tr>
</table>

### operatorDocumentation Function
<table>
<tr><td>description:</td><td colspan="4">Generates markdown documentation of all the operators that can be used within a ExpressionTag of a TemplateEngine</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ operatorDocumentation() }}</td></tr>
<tr><td>parameter:</td><td>titleLevel</td><td>number</td><td>optional (default=1)</td><td>The level of the tag title</td></tr>
</table>

### exampleDocumentation Function
<table>
<tr><td>description:</td><td colspan="4">Generates markdown documentation of all the examples. This could be used to generate example.md file.</td></tr>
<tr><td>return type:</td><td colspan="4">String</td></tr>
<tr><td>expression example:</td><td colspan="4">{{ exampleDocumentation() }}</td></tr>
<tr><td>parameter:</td><td>titleLevel</td><td>number</td><td>optional (default=1)</td><td>The level of the tag title</td></tr>
</table>

