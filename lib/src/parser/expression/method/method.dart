import 'dart:async';

import 'package:collection/collection.dart';
import 'package:recase/recase.dart';
import 'package:template_engine/template_engine.dart';

final standardMethods = <MethodDefinition>[
  ...standardDynamicMethods,
  ...standardStringMethods,
  ...standardNumberMethods,
  ...standardIntMethods,
  ...standardDoubleMethods,
  ...standardListMethods,
  ...standardSetMethods,
  ...standardMapMethods,
];

class MethodException implements Exception {
  final String message;
  MethodException(this.message);
}

class MethodCallExpression implements Expression {
  /// all [MethodDefinition] that share the same lowercase name
  /// (obtained via [Grammar._methodLookUp])
  final List<MethodDefinition> methodDefinitions;

  /// [owner] is the object that owns the method
  final Expression owner;

  /// function arguments:
  /// * [key] = parameter name of type [String]
  /// * [value] = argument of type [Expression]
  final ArgumentExpressionList argumentExpressionList;
  final TemplateLocation location;

  MethodCallExpression(
    this.owner,
    this.location,
    this.methodDefinitions,
    this.argumentExpressionList,
  ) {
    if (methodDefinitions.isEmpty) {
      throw ParseError('Method definitions may not be empty', location);
    }
  }

  @override
  Future<dynamic> evaluate(RenderContext context) async {
    final ownerValue = await owner.evaluate(context);
    var methodDefinition = findMethodDefinition(ownerValue);
    if (methodDefinition == null) {
      var expectedMethodOwnerTypes = methodDefinitions
          .map((def) => def.ownerType.toString())
          .toSet()
          .join(', or ');
      throw RenderError(
        'Method ${methodDefinitions.first.name} '
        'can only be called on: $expectedMethodOwnerTypes',
        location,
      );
    }
    var argumentExpressionMap = ArgumentExpressionMap(
      argumentExpressionList,
      methodDefinition.parameters,
    );

    if (argumentExpressionMap.errors.isNotEmpty) {
      context.errors.addAll(argumentExpressionMap.errors);
      throw argumentExpressionMap.errors;
    }
    var argumentValueMap = await argumentExpressionMap.evaluate(context);

    return await methodDefinition.callMethod(
      context,
      location,
      ownerValue,
      argumentExpressionMap.toLocationMap(),
      argumentValueMap,
    );
  }

  MethodDefinition? findMethodDefinition(dynamic methodOwner) =>
      methodDefinitions.firstWhereOrNull(
        (methodDef) =>
            //methodDef.ownerType == dynamic ||
            methodDef.isOwnerType(methodOwner),
      );

  @override
  String toString() => 'MethodCallExpression{${methodDefinitions.first.name}}';
}

/// A method is a piece of dart code that performs a specific operation
/// on a given object (the method owner).
/// So a method can basically do anything that dart code can do.
///
/// An example of a method call: 'Hello'.length()
/// Should result in: 5
class MethodDefinition<OWNER_TYPE, RETURN_TYPE>
    implements DocumentationProvider, ExampleProvider {
  final ownerType = OWNER_TYPE;
  final returnType = RETURN_TYPE;
  final String name;
  final List<Parameter> parameters;
  final String description;
  @override
  late final MarkdownDocumentation documentation = MethodSignatureDocumentation(
    this,
  );
  @override
  final List<Example> examples;

  /// A function that executes the method
  ///
  /// returns a [Future] of the return type of the method
  /// If the method returns a void the method should return a Future.value()
  ///
  /// Throws a [Error] (preferably a RenderError) if the method fails to execute
  ///
  /// Adds an error to the [RenderContext.errors] if there was a problem
  /// but the method was able to return a value
  final Future<RETURN_TYPE> Function(MethodCallContext<OWNER_TYPE> context)
  method;

  MethodDefinition({
    required this.name,
    required this.parameters,
    required this.method,
    required this.description,
    required this.examples,
  }) {
    validateIdentifier(nameType: 'method name', nameToValidate: name);
  }

  /// Wraps a call to the [method] function
  /// and provides a [MethodCallContext] to it
  Future<RETURN_TYPE> callMethod(
    RenderContext renderContext,
    TemplateLocation methodLocation,
    dynamic owner,
    Map<String, TemplateLocation> argumentLocations,
    Map<String, dynamic> argumentValues,
  ) async {
    var context = MethodCallContext<OWNER_TYPE>(
      renderContext,
      methodLocation,
      owner as OWNER_TYPE,
      argumentLocations,
      argumentValues,
    );

    return await method(context);
  }

  bool isOwnerType(dynamic methodOwner) => methodOwner is OWNER_TYPE;
}

class MethodCallContext<OWNER_TYPE> {
  final RenderContext _renderContext;
  final TemplateLocation methodLocation;
  final OWNER_TYPE owner;
  final Map<String, TemplateLocation> argumentLocations;
  final Map<String, dynamic> argumentValues;

  MethodCallContext(
    this._renderContext,
    this.methodLocation,
    this.owner,
    this.argumentLocations,
    this.argumentValues,
  );

  void addWarning(String message, TemplateLocation location) {
    _renderContext.errors.add(RenderError(message, location));
  }
}

class MethodSignatureDocumentation implements MarkdownDocumentation {
  final MethodDefinition methodDef;
  MethodSignatureDocumentation(this.methodDef);

  @override
  String createMarkdownDocumentation(Grammar grammar, int titleLevel) {
    var writer = HtmlTableWriter();
    writer.setTitle(titleLevel, '${methodDef.name} Method');
    writer.addRow(['description:', methodDef.description], [1, 4]);
    writer.addRow(
      ['return type:', typeDescription(methodDef.returnType)],
      [1, 4],
    );
    var parameterRows = methodDef.parameters.map(
      (parameter) => parameter.createHtmlTableRow(),
    );
    writer.rows.addAll(parameterRows);
    for (final example in methodDef.examples) {
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

String aggregatedMethodDocumentation(Grammar grammar, int titleLevel) => [
  'A [method](https://en.wikipedia.org/wiki/Method_(computer_programming)) is just a '
      '[function](https://en.wikipedia.org/wiki/Function_(computer_programming)) '
      'that lives inside an object. ',
  'It does everything a function does, but it’s tied to the object it belongs to.'
      '',
  'A method can be used after an expression value and a . (dot) operator, ',
  '',
  "In example: 'Hello'.length()",
  'Should result in: 5',
  '',
  parameterAndArgumentDocumentation(titleLevel, ParameterOwner.method),
  '',
  ...grammar.methodsPerOwnerType.entries.map(
    (entry) => [
      markdownTitle(titleLevel, '${entry.key.toString().titleCase} Methods'),
      entry.value
          .map(
            (methodSignature) => methodSignature.documentation
                .createMarkdownDocumentation(grammar, titleLevel + 1),
          )
          .join('\n'),
    ].join('\n'),
  ),

  '',
  markdownTitle(titleLevel, 'Custom Methods'),
  'You can use pre-packaged $templateEngineHyperLink methods or '
      'add your own custom methods by manipulating the '
      'Grammar.methods field.',
  'See ${customMethodExample.toMarkdownLink()}',
].join('\n');

final customMethodExample = TestFileExample.fromProjectFilePath(
  '/test/src/parser/expression/method/custom_method_test.dart',
);
