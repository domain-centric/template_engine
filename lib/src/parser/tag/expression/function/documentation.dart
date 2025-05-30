import 'dart:io';

import 'package:collection/collection.dart';
import 'package:template_engine/template_engine.dart';

const String _templateEngineHyperLink =
    '[template_engine](https://pub.dev/packages/template_engine)';
const String templateEngineGitHubBlobMainUri =
    'https://github.com/domain-centric/template_engine/blob/main';

/// Functions that create documentation of the [TemplateEngine] configuration
class DocumentationFunctions extends FunctionGroup {
  DocumentationFunctions()
    : super('Documentation Functions', [
        TagDocumentation(),
        DataTypeDocumentation(),
        ConstantDocumentation(),
        VariableDocumentation(),
        FunctionDocumentation(),
        OperatorDocumentation(),
        ExampleDocumentation(),
      ]);
}

class TitleLevelParameter extends Parameter<num> {
  TitleLevelParameter()
    : super(
        name: 'titleLevel',
        description: 'The level of the tag title',
        presence: Presence.optionalWithDefaultValue(1),
      );
}

abstract class DocumentationFunction extends ExpressionFunction<String> {
  DocumentationFunction({
    required super.name,
    required super.description,
    super.exampleExpression,
    super.exampleResult,
    required List<String> Function(RenderContext renderContext, int titleLevel)
    documentationFunction,
  }) : super(
         parameters: [TitleLevelParameter()],
         function: (position, renderContext, parameters) => Future.value(
           documentationFunction(
             renderContext,
             _titleLevel(parameters),
           ).join('\n'),
         ),
       );

  static int _titleLevel(Map<String, Object> parameters) {
    var titleLevel = parameters['titleLevel'];
    if (titleLevel is! int) {
      throw ParameterException('Parameter titleLevel: must be a integer');
    }
    if (titleLevel < 1 && titleLevel > 10) {
      throw ParameterException(
        'Parameter titleLevel: must be a number >=1 and <=10',
      );
    }
    return titleLevel;
  }
}

// Checks if the current directory is named 'template_engine'
// This uses the current working directory from Dart:io
// and compares the last segment to 'template_engine'
bool get isTemplateEngineProject {
  try {
    return Directory.current.path.split(Platform.pathSeparator).last ==
        'template_engine';
  } catch (_) {
    // If Directory.current is not available (e.g., web), return false
    return false;
  }
}

class TagDocumentation extends DocumentationFunction {
  TagDocumentation()
    : super(
        name: 'tagDocumentation',
        description:
            'Generates markdown documentation of all the tags '
            'within a TemplateEngine',
        documentationFunction: (renderContext, titleLevel) => [
          'Tags are specific texts in templates that are replaced by the '
              '$_templateEngineHyperLink with other information.',
          '',
          'A tag:',
          '* Starts with some bracket and/or character combination, e.g.: {{',
          '* Followed by some contents',
          '* Ends with some closing bracket and/or character combination, e.g.: }}',
          '',
          'A tag example: {{customer.name}}',
          '',
          'By default the TemplateEngine tags start with {{ and end with }} brackets,',
          'just like the popular template engines',
          '[Mustache](https://mustache.github.io/) and',
          '[Handlebars](https://handlebarsjs.com).',
          '',
          'You can also define alternative Tag brackets in the TemplateEngine',
          'constructor parameters. See TemplateEngine.tagStart and',
          'TemplateEngine.tagEnd',
          '',
          'It is recommended to use a start and end combination that is not used',
          'elsewhere in your templates, e.g.: Do not use < > as Tag start and end',
          'if your template contains HTML or XML',
          '',
          _title(titleLevel, 'Custom tags'),
          'The $_templateEngineHyperLink comes with DefaultTags. '
              'You can replace or add your',
          'own Tags by manipulating the the TemplateEngine.tags field.',
          '',
          _title(titleLevel, 'Available tags'),
          ...(isTemplateEngineProject
                  ? DefaultTags()
                  : renderContext.engine.tags)
              .map(
                (tag) => tag.createMarkdownDocumentation(
                  renderContext,
                  titleLevel + 1,
                ),
              )
              .flattened,
        ],
      );
}

class DataTypeDocumentation extends DocumentationFunction {
  DataTypeDocumentation()
    : super(
        name: 'dataTypeDocumentation',
        description:
            'Generates markdown documentation of all the data '
            'types that can be used within a ExpressionTag of a '
            'TemplateEngine',
        documentationFunction: (renderContext, titleLevel) => [
          'A [data type](https://en.wikipedia.org/wiki/Data_type) defines what the',
          'possible values an expression, such as a variable, operator',
          'or a function call, might use.',
          '',
          'The $_templateEngineHyperLink supports several default DataTypes.',
          '',
          _title(titleLevel, 'Custom DataTypes'),
          'You can adopt existing DataTypes or add your own custom DataTypes by',
          'manipulating the TemplateEngine.dataTypes field.  ',
          'See [example]($templateEngineGitHubBlobMainUri'
              '/test/src/parser/tag/expression/data_type/custom_data_type_test.dart)',
          '',
          _title(titleLevel, 'Available Data Types'),
          ...(isTemplateEngineProject
                  ? DefaultDataTypes()
                  : renderContext.engine.dataTypes)
              .map(
                (dataType) => dataType.createMarkdownDocumentation(
                  renderContext,
                  titleLevel,
                ),
              )
              .flattened,
        ],
      );
}

String _title(int titleLevel, String title) => '${'#' * titleLevel} $title  ';

class ConstantDocumentation extends DocumentationFunction {
  ConstantDocumentation()
    : super(
        name: 'constantDocumentation',
        description:
            'Generates markdown documentation of all the constants '
            'that can be used within a ExpressionTag of a TemplateEngine',
        documentationFunction: (renderContext, titleLevel) => [
          'A [Constant](https://en.wikipedia.org/wiki/Constant_(computer_programming))'
              ' is a value that does not change value over time.',
          '',
          'The $_templateEngineHyperLink comes with several mathematical constants.',
          '',
          _title(titleLevel, 'Custom Constants'),
          'You can create and add your own Constants by',
          'manipulating the TemplateEngine.constants field.  ',
          'See [Example]($templateEngineGitHubBlobMainUri/test/src/parser/tag/expression/constant/custom_constant_test.dart)',
          '',
          _title(titleLevel, 'Available Constants'),
          ...(isTemplateEngineProject
                  ? DefaultConstants()
                  : renderContext.engine.constants)
              .map(
                (constant) => constant.createMarkdownDocumentation(
                  renderContext,
                  titleLevel,
                ),
              )
              .flattened,
        ],
      );
}

class VariableDocumentation extends DocumentationFunction {
  VariableDocumentation()
    : super(
        name: 'variableDocumentation',
        description:
            'Generates markdown documentation of variables '
            'that can be used within a ExpressionTag of a TemplateEngine',
        documentationFunction: (renderContext, titleLevel) => [
          'A [variable](https://en.wikipedia.org/wiki/Variable_(computer_science)) is',
          'a named container for some type of information',
          '(like a [number](https://en.wikipedia.org/wiki/Double-precision_floating-point_format), '
              '[boolean](https://en.wikipedia.org/wiki/Boolean_data_type), '
              '[string](https://en.wikipedia.org/wiki/String_(computer_science)), etc...)',
          '',
          '* Variables are stored as key, value pairs in a dart Map<String, dynamic> where:',
          '  * String=Variable name',
          '  * dynamic=Variable value',
          '* Variables can be used in an ExpressionTag',
          '* Initial variable values are passed to the TemplateEngine.render method',
          '* Variables can be modified during rendering',
          '',
          'The [variable name](https://en.wikipedia.org/wiki/Variable_(computer_science)) ',
          'identifies the variable and corresponds with the keys',
          'in the variable map.',
          '',
          'The [variable names](https://en.wikipedia.org/wiki/Variable_(computer_science)):  ',
          '* are [case sensitive](https://en.wikipedia.org/wiki/Case_sensitivity)',
          '* must start with a lower case letter, optionally followed by (lower or upper) letters and or digits.',
          '* conventions: use [lowerCamelCase](https://en.wikipedia.org/wiki/Camel_case)',
          '* must be unique and does not match a other tag syntax',
          '',
          'Variables can be nested. Concatenate '
              '[variable names](https://en.wikipedia.org/wiki/Variable_(computer_science)) separated with dot\'s',
          'to get the variable value of a nested '
              '[variable name](https://en.wikipedia.org/wiki/Variable_(computer_science)):'
              '',
          'E.g.:<br>',
          'Variable map: {\'person\': {\'name\': \'John Doe\', \'age\',30}}<br>',
          'Variable name person.name: refers to the variable value of \'John Doe\'',
          '',
          'Examples:',
          '* [Variable Example]($templateEngineGitHubBlobMainUri'
              '/test/src/parser/tag/expression/variable/variable_test.dart)',
          '* [Nested Variable Example]($templateEngineGitHubBlobMainUri'
              '/test/src/parser/tag/expression/variable/nested_variable_test.dart)',
        ],
      );
}

class FunctionDocumentation extends DocumentationFunction {
  FunctionDocumentation()
    : super(
        name: 'functionDocumentation',
        description:
            'Generates markdown documentation of all the functions '
            'that can be used within a ExpressionTag of a TemplateEngine',
        documentationFunction: (renderContext, titleLevel) => [
          'A [function](https://en.wikipedia.org/wiki/Function_(computer_programming)) '
              'is a piece of dart code that performs a specific task.',
          'So a function can basically do anything that dart code can do.',
          '',
          'A function can be used anywhere in an tag expression. '
              'Wherever that particular task should be performed.',
          '',
          'An example of a function call: cos(pi)',
          'Should result in: -1',
          '',
          _title(titleLevel, 'Parameters and Arguments'),
          '**Function & Parameter & argument names:**',
          '* are [case sensitive](https://en.wikipedia.org/wiki/Case_sensitivity)',
          '* must start with a lower case letter, optionally followed by '
              '(lower or upper case) letters and or digits.',
          '* conventions: use [lowerCamelCase](https://en.wikipedia.org/wiki/Camel_case)',
          '* must be unique and does not match a other tag syntax',
          '',
          '**Parameters vs Arguments**',
          '* Parameters are the names used in the function definition.',
          '* Arguments are the actual values passed when calling the function.',
          '',
          '**Parameters:**',
          '* A function can have zero or more parameters',
          '* Parameters are defined as either mandatory or optional',
          '* Optional parameters can have a default value',
          '',
          '**Arguments:**',
          '* Multiple arguments are separated with a comma, e.g. single argument: '
              '`cos(pi)` multiple arguments: `volume(10,20,30)`',
          '* There are different types of arguments',
          '  * Positional Arguments: These are passed in the order the function '
              'defines them. e.g.: `volume(10, 20, 30)`',
          '  * Named Arguments: You can specify which parameter you\'re assigning a '
              'value to, regardless of order. e.g.: `volume(l=30, h=10, w=20)`',
          '* Arguments can set a parameter only once',
          '* You can mix positional arguments and named arguments, but positional '
              'arguments must come first',
          '* Named arguments remove ambiguity: If you want to skip an optional '
              'argument or specify one out of order, you must name it explicitly',
          '',
          '**Argument values:**',
          '* must match the expected parameter type. e.g. '
              '`area(length=\'hello\', width=\'world\')` will result in a failure',
          '* may be a tag expression such as a variable, constant, operation, '
              'function, or combination. e.g. `cos(2*pi)`',
          '',
          _title(titleLevel, 'Custom Functions'),
          'You can use prepackaged [template_engine] functions or add your own custom '
              'functions by manipulating the TemplateEngine.functionGroups field.  ',
          'See [Example]($templateEngineGitHubBlobMainUri'
              '/test/src/parser/tag/expression/function/custom_function_test.dart).',
          '',
          _title(titleLevel, 'Available Functions'),
          ...(isTemplateEngineProject
                  ? DefaultFunctionGroups()
                  : renderContext.engine.functionGroups)
              .map(
                (functionGroup) => functionGroup.createMarkdownDocumentation(
                  renderContext,
                  titleLevel + 1,
                ),
              )
              .flattened,
        ],
      );
}

class OperatorDocumentation extends DocumentationFunction {
  OperatorDocumentation()
    : super(
        name: 'operatorDocumentation',
        description:
            'Generates markdown documentation of all the operators '
            'that can be used within a ExpressionTag of a TemplateEngine',
        documentationFunction: (renderContext, titleLevel) => [
          'An [operator](https://en.wikipedia.org/wiki/Operator_(computer_programming)) '
              'behaves generally like functions,',
          'but differs syntactically or semantically.',
          '',
          'Common simple examples include arithmetic (e.g. addition with `+`) and',
          'logical operations (e.g. `&`).',
          '',
          'An operator can be used anywhere in a tag expression',
          'wherever that particular operator should be performed.',
          '',
          'The TemplateEngine supports several standard operators.',
          '',
          _title(titleLevel, 'Custom Operators'),
          'You can use prepackaged [template_engine] operators or add your own custom ',
          'operators by manipulating the TemplateEngine.operatorGroups field.  ',
          'See [Example]($templateEngineGitHubBlobMainUri'
              '/test/src/parser/tag/expression/operator/custom_operator_test.dart).',
          '',
          _title(titleLevel, 'Available Operators'),
          ...(isTemplateEngineProject
                  ? DefaultOperatorGroups()
                  : renderContext.engine.operatorGroups)
              .map(
                (operatorGroup) => operatorGroup.createMarkdownDocumentation(
                  renderContext,
                  titleLevel + 1,
                ),
              )
              .flattened,
        ],
      );
}

class ExampleDocumentation extends DocumentationFunction {
  ExampleDocumentation()
    : super(
        name: 'exampleDocumentation',
        description:
            'Generates markdown documentation of all the examples. '
            'This could be used to generate example.md file.',
        documentationFunction: (renderContext, titleLevel) =>
            (isTemplateEngineProject
                    ? DefaultTags()
                    : renderContext.engine.tags)
                .map(
                  (tag) =>
                      tag.createMarkdownExamples(renderContext, titleLevel),
                )
                .flattened
                .toList(),
      );
}

abstract class DocumentationFactory {
  List<String> createMarkdownDocumentation(
    RenderContext renderContext,
    int titleLevel,
  );
}

abstract class ExampleFactory {
  List<String> createMarkdownExamples(
    RenderContext renderContext,
    int titleLevel,
  );
}

class HtmlTableWriter {
  String? headerLine;
  List<String> rows = [];

  HtmlTableWriter();

  /// Adds a title above the Table for navigation
  /// * From the wiki navigation pane
  /// * Deep linking using [Uri.fragment]
  void setHeader(int titleLevel, String title) {
    headerLine = "${'#' * (titleLevel)} $title";
  }

  void addHeaderRow(List<String> values, [List<int>? columnSpans]) {
    var row = HtmlTableRow(values, columnSpans, CellType.tableHeader);
    rows.add(row.toHtml());
  }

  void addRow(List<String> values, [List<int>? columnSpans]) {
    var row = HtmlTableRow(values, columnSpans, CellType.tableData);
    rows.add(row.toHtml());
  }

  List<String> toHtmlLines() => [
    if (headerLine != null) headerLine!,
    '<table>',
    ...rows,
    '</table>',
    '',
  ];
}

class HtmlTableRow {
  late StringBuffer row;

  HtmlTableRow(
    List<String> values, [
    List<int>? columnSpans,
    CellType cellType = CellType.tableData,
  ]) {
    row = StringBuffer();
    row.write('<tr>');
    for (int i = 0; i < values.length; i++) {
      var span = _columnSpan(columnSpans, i);
      if (span <= 1) {
        row.write('<${cellType.elementName}>');
      } else {
        row.write('<${cellType.elementName} colspan="$span">');
      }
      row.write(values[i]);
      row.write('</${cellType.elementName}>');
    }
    row.write('</tr>');
  }

  int _columnSpan(List<int>? columnSpans, int i) {
    if (columnSpans == null || i >= columnSpans.length) {
      return 1;
    }
    return columnSpans[i];
  }

  String toHtml() => row.toString();
}

enum CellType {
  tableHeader('th'),

  /// normal cell
  tableData('td');

  final String elementName;
  const CellType(this.elementName);
}

String typeDescription<T>() {
  switch (T) {
    case const (num):
      return 'number';
    case const (bool):
      return 'boolean';

    default:
      return T.toString();
  }
}
