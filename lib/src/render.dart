
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
/// the Type of [ParserTree.nodes] are normally one of the following:
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
class ParserTree extends Renderer<String> {
  /// The source
  final Template template;

  /// The nodes that where parsed and can be rendered to a [String].
  /// The nodes are of type [RenderType]
  List<Object> nodes;

  ParserTree(this.template, [this.nodes = const []]);

  @override
  String render(RenderContext context) =>
      nodes.map((node) => renderNode(context, node)).join();

  String renderNode(RenderContext context, Object node) {
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
  final Template template;
  RenderContext(
      {required this.engine,
      required this.template,

      /// How errors need to be rendered
      String? renderedError,
      Variables? variables})
      : variables = variables ?? {},
        renderedError =
            renderedError ?? '${engine.tagStart}ERROR${engine.tagEnd}',
        errors = [];
}

class RenderResult {
  final List<RenderError> errors;
  final String text;

  RenderResult({
    required this.text,
    this.errors = const [],
  });

  String get errorMessage => errors.map((error) => '  $error').join('\n');

  @override
  String toString() => text;
}

/// contains the [RenderResult] of a [Template]
class TemplateRenderResult extends RenderResult {
  final Template template;

  TemplateRenderResult(
      {required this.template, required super.text, super.errors});

  @override
  String get errorMessage {
    switch (errors.length) {
      case 0:
        return '';
      case 1:
        return 'Render error in: ${template.source}:\n${super.errorMessage}';
      default:
        return 'Render errors in: ${template.source}:\n${super.errorMessage}';
    }
  }
}
