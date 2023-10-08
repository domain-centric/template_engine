import 'package:template_engine/template_engine.dart';

/// Renders some value depending on the implementation of the [Renderer]
///
/// For [T] see [RenderType]
///

abstract class Renderer<T> {
  T render(RenderContext context);
}

class RenderException extends RenderError implements Exception {
  RenderException({required super.message, required super.position});
}

/// Types returned by the [Renderer.render] method or
/// the Type of [ParserTree.children] are normally one of the following:
/// * String
/// * int
/// * double
/// * bool
/// * DateTime
/// * Some other object
/// * [Renderer]<Generic type is on of the above>
/// * List<Generic type is on of the above>
abstract class RenderType {
  /// Documentation only
}

/// The [ParserTree](https://en.wikipedia.org/wiki/Parse_tree) contains
/// parsed nodes from a [Template] that can be rendered to a [String].
class ParserTree<T> extends Renderer<String> {
  /// The [children] that where parsed and can be rendered to a [String].
  /// The [children] are of type [RenderType]
  final List<T> children;

  ParserTree([this.children = const []]);

  @override
  String render(RenderContext context) =>
      children.map((node) => renderNode(context, node)).join();

  String renderNode(RenderContext context, T node) {
    if (node is Renderer) {
      try {
        return node.render(context).toString();
      } on Exception catch (e) {
        if (e is RenderException) {
          context.errors.add(e);
        }
        return context.renderedError;
      }
    } else if (node is List) {
      return node.map((n) => renderNode(context, n)).join();
    } else {}
    return node.toString();
  }
}

class RenderContext {
  final TemplateEngine engine;
  final Variables variables;
  final List<RenderError> errors;
  final String renderedError;

  /// the Template being rendered
  final Template templateBeingRendered;

  final List<TemplateParseResult> parsedTemplates;
  RenderContext(
      {required this.engine,
      required this.parsedTemplates,
      required this.templateBeingRendered,

      /// How errors need to be rendered
      String? renderedError,
      Variables? variables})
      : variables = variables ?? {},
        renderedError =
            renderedError ?? '${engine.tagStart}ERROR${engine.tagEnd}',
        errors = [];
}

abstract class RenderResult {
  final String text;

  RenderResult({
    required this.text,
  });

  String get errorMessage;

  @override
  String toString() => text;
}

/// contains the [RenderResult] of a [Template]
class TemplateRenderResult extends RenderResult {
  final Template template;
  final List<Error> errors;

  TemplateRenderResult(
      {required this.template, required super.text, this.errors = const []});

  @override
  String get errorMessage {
    if (errors.isEmpty) {
      return "";
    }
    var parseErrors = errors.whereType<ParseError>();
    var renderErrors = errors.whereType<RenderError>();
    if (parseErrors.isNotEmpty && renderErrors.isNotEmpty) {
      return 'Errors in: ${template.source}:\n'
          '  Parse error${parseErrors.length > 1 ? "s" : ""}:\n'
          '${parseErrors.map((error) => '    $error').join('\n')}\n'
          '  Render error${renderErrors.length > 1 ? "s" : ""}:\n'
          '${renderErrors.map((error) => '    $error').join('\n')}';
    } else if (parseErrors.isNotEmpty) {
      return 'Parse error${parseErrors.length > 1 ? "s" : ""} '
          'in: ${template.source}:\n'
          '${parseErrors.map((error) => '  $error').join('\n')}';
    } else {
      return 'Render error${renderErrors.length > 1 ? "s" : ""} '
          'in: ${template.source}:\n'
          '${renderErrors.map((error) => '  $error').join('\n')}';
    }
  }
}

/// contains the [RenderResult] of one or more [Template]
class TemplatesRenderResult extends RenderResult {
  final List<TemplateRenderResult> renderResults;

  TemplatesRenderResult(this.renderResults)
      : super(
            text: renderResults
                .where((renderResult) =>
                    renderResult.template is! ImportedTemplate)
                .map((renderResult) => renderResult.text)
                .join());

  @override
  String get errorMessage => renderResults
      .where((renderResult) => renderResult.errorMessage.isNotEmpty)
      .map((renderResult) => renderResult.errorMessage)
      .join('\n');

  TemplatesRenderResult add(TemplateRenderResult renderResult) {
    var newRenderResults = [...renderResults, renderResult];
    return TemplatesRenderResult(newRenderResults);
  }
}
