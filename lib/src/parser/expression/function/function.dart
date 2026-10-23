import 'dart:async';

import 'package:collection/collection.dart';
import 'package:template_engine/template_engine.dart';

final standardFunctionGroups = <FunctionGroup>[
  standardMathFunctions,
  standardTemplateFunctions,
  standardDocumentationFunctions,
  standardImportFunctions,
];

class FunctionException implements Exception {
  final String message;
  FunctionException(this.message);
}

class FunctionCallExpression implements Expression {
  final FunctionDefinition functionDefinition;

  /// function arguments:
  /// * [key] = parameter name of type [String]
  /// * [value] = argument of type [Expression]
  final ArgumentExpressionMap argumentExpressionMap;
  final TemplateLocation location;

  FunctionCallExpression(
    this.location,
    this.functionDefinition,
    this.argumentExpressionMap,
  );

  @override
  Future<dynamic> evaluate(RenderContext context) async {
    var argumentValueMap = await argumentExpressionMap.evaluate(context);
    var functionCallContext = FunctionCallContext(
      location,
      context,
      argumentExpressionMap.toLocationMap(),
      argumentValueMap,
    );
    return await functionDefinition.function(functionCallContext);
  }

  @override
  String toString() => 'Function{${functionDefinition.name}}';
}

/// A function is a piece of dart code that performs a specific task.
// So a function can basically do anything that dart code can do.
///
/// A function can be used anywhere in an expression.
/// Wherever that particular task should be performed.
///
/// An example of a function call: cos(pi)
/// Should result in: -1
class FunctionDefinition<RETURN_TYPE> extends DocumentationProvider {
  final String name;
  final List<Parameter> parameters;

  @override
  final FunctionDefinitionDocumentation2<RETURN_TYPE> documentation;

  /// A function that executes the function as defined in [FunctionDefinition]
  ///
  /// returns a [Future] of the return type of the function
  /// If the method returns a void the method should return a Future.value()
  ///
  /// Throws a [Error] (preferably a RenderError) if the method fails to execute
  ///
  /// Adds an error to the [RenderContext.errors] if there was a problem
  /// but the method was able to return a value
  final Future<RETURN_TYPE> Function(FunctionCallContext context) function;

  FunctionDefinition({
    required this.name,
    this.parameters = const [],
    required this.function,
    required FunctionDefinitionDocumentation<RETURN_TYPE> documentation,
  }) : documentation = FunctionDefinitionDocumentation2<RETURN_TYPE>(
         name: name,
         parameters: parameters,
         description: documentation.description,
         examples: documentation.examples,
       ) {
    validateIdentifier(nameType: 'function name', nameToValidate: name);
  }
}

class FunctionCallContext {
  final TemplateLocation functionLocation;
  final RenderContext renderContext;
  final Map<String, TemplateLocation> argumentLocations;
  final Map<String, dynamic> argumentValues;

  FunctionCallContext(
    this.functionLocation,
    this.renderContext,
    this.argumentLocations,
    this.argumentValues,
  );

  void addWarning(String message, TemplateLocation location) {
    renderContext.errors.add(RenderError(message, location));
  }
}

class FunctionDefinitionDocumentation<RETURN_TYPE> {
  final String description;
  final List<Example> examples;

  FunctionDefinitionDocumentation({
    required this.description,
    required this.examples,
  });
}

class FunctionDefinitionDocumentation2<RETURN_TYPE>
    implements MarkdownDocumentation, ExampleProvider {
  final String name;
  final List<Parameter<dynamic>> parameters;
  final String description;
  @override
  final List<Example> examples;
  FunctionDefinitionDocumentation2({
    required this.name,
    required this.parameters,
    required this.description,
    required this.examples,
  });

  @override
  String createMarkdownDocumentation(Grammar grammar, int titleLevel) {
    var writer = HtmlTableWriter();
    writer.setTitle(titleLevel, '$name Function');
    writer.addRow(['description:', description], [1, 4]);
    writer.addRow(['return type:', typeDescription(RETURN_TYPE)], [1, 4]);
    var parameterRows = parameters.map(
      (parameter) => parameter.createHtmlTableRow(),
    );
    writer.rows.addAll(parameterRows);
    for (final example in examples) {
      writer.addRow(
        [
          '${example.typeString}:',
          example.toMarkdown(grammar.codeBlockDelimiter),
        ],
        [1, 4],
      );
    }
    return writer.toHtml();
  }
}

class FunctionGroup extends DelegatingList<FunctionDefinition>
    implements MarkdownDocumentation, ExampleProvider {
  final String name;

  FunctionGroup(this.name, super.base);

  @override
  String createMarkdownDocumentation(Grammar grammar, int titleLevel) => [
    '${"#" * titleLevel} $name',
    ...map(
      (functionDef) => functionDef.documentation.createMarkdownDocumentation(
        grammar,
        titleLevel + 1,
      ),
    ),
  ].join('\n');

  @override
  List<Example> get examples =>
      expand((functionDef) => functionDef.documentation.examples).toList();
}

String aggregatedFunctionDocumentation(Grammar grammar, int titleLevel) => [
  'A [function](https://en.wikipedia.org/wiki/Function_(computer_programming)) '
      'is a piece of dart code that performs a specific task.',
  'So a function can basically do anything that dart code can do.',
  '',
  'A function can be used anywhere in an expression. '
      'Wherever that particular task should be performed.',
  '',
  'An example of a function call: cos(pi)',
  'Should result in: -1',
  '',
  parameterAndArgumentDocumentation(titleLevel, ParameterOwner.function),
  '',
  ...grammar.functionGroups.map(
    (functionGroup) =>
        functionGroup.createMarkdownDocumentation(grammar, titleLevel),
  ),

  '',
  markdownTitle(titleLevel, 'Custom Functions'),
  'You can use pre-packaged $templateEngineHyperLink functions or '
      'add your own custom functions by manipulating the '
      'TemplateEngine.functionGroups field.',
  'See ${customFunctionExample.toMarkdownLink()}',
].join('\n');

final customFunctionExample = TestFileExample.fromProjectFilePath(
  '/test/src/parser/expression/function/custom_function_test.dart',
);
