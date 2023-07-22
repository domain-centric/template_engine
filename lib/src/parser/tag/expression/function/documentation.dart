import 'package:template_engine/template_engine.dart';

/// Functions that create documentation of the [TemplateEngine] configuration
class DocumentationFunctions extends FunctionGroup {
  DocumentationFunctions()
      : super('Documentation Functions', [
          TagDocumentation(),
          // BaseTypeDocumentation(),
          //TODO basetypes
          //TODO constants
          //TODO variables
          //TODO operators
          FunctionDocumentation(),
        ]);
}

class TitleLevelParameter extends Parameter<num> {
  TitleLevelParameter()
      : super(
            name: 'titleLevel',
            description: 'The level of the tag title',
            presence: Presence.optionalWithDefaultValue(1));
}

abstract class DocumentationFunction extends ExpressionFunction<String> {
  DocumentationFunction({
    required super.name,
    required super.description,
    super.exampleExpression,
    super.exampleResult,
    required List<DocumentationFactory> Function(RenderContext renderContext)
        documentationSource,
  }) : super(
            parameters: [TitleLevelParameter()],
            function: (renderContext, parameters) => _createDocumentation(
                renderContext, documentationSource(renderContext), parameters));

  static String _createDocumentation(
    RenderContext renderContext,
    List<DocumentationFactory> factories,
    Map<String, Object> parameters,
  ) {
    var titleLevel = parameters['titleLevel'];
    if (titleLevel is! int) {
      throw ParameterException('Parameter titleLevel: must be a integer');
    }
    if (titleLevel < 1 && titleLevel > 10) {
      throw ParameterException(
          'Parameter titleLevel: must be a number >=1 and <=10');
    }

    var markdown = <String>[];
    for (var factory in factories) {
      markdown.addAll(
          factory.createMarkdownDocumentation(renderContext, titleLevel));
    }
    return markdown.join('\n');
  }
}

class TagDocumentation extends DocumentationFunction {
  TagDocumentation()
      : super(
            name: 'engine.tag.documentation',
            description: 'Generates markdown documentation of all the tags '
                'within a TemplateEngine',
            documentationSource: (renderContext) => renderContext.engine.tags);
}

// class BasicTypeDocumentation extends ExpressionFunction<String> {
//   BasicTypeDocumentation()
//       : super(
//             name: 'engine.basicType.documentation',
//             description: 'Generates markdown documentation of all the basic '
//                 'types that can be used within a ExpressionTag of a '
//                 'TemplateEngine',
//             parameters: [TitleLevelParameter()],
//             function: (renderContext, parameters) => createDocumentation(
//                 renderContext, renderContext.engine.functionGroups, parameters));
// }

class FunctionDocumentation extends DocumentationFunction {
  FunctionDocumentation()
      : super(
            name: 'engine.function.documentation',
            description:
                'Generates markdown documentation of all the functions '
                'that can be used within a ExpressionTag of a TemplateEngine',
            documentationSource: (renderContext) =>
                renderContext.engine.functionGroups);
}

abstract class DocumentationFactory {
  List<String> createMarkdownDocumentation(
      RenderContext renderContext, int titleLevel);
}
