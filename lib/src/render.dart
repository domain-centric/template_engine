import 'package:template_engine/src/error.dart';

/// Renders some text depending on the implementation of the [RenderNode]
abstract class RenderNode {
  String render(RenderContext context);
}

/// A [RenderNode] that is a placeholder for normal text
class TextNode implements RenderNode {
  String text;

  TextNode(this.text);

  @override
  String render(RenderContext context) => text;
}

class ParentNode extends RenderNode {
  List<RenderNode> children;

  ParentNode([this.children = const []]);

  @override
  String render(RenderContext context) =>
      children.map((child) => child.render(context)).join();
}

class RenderContext {
  final Map<String, Object> variables;
  final List<Error> errors;

  RenderContext(
    Map<String, Object> variables,
  )   : variables = _createMapClone(variables),
        errors = [];

  static _createMapClone(Map<String, Object> variables) =>
      Map<String, Object>.from(variables);
}

class RenderResult implements Exception {
  final List<Error> errors;
  final String text;

  RenderResult({
    required this.text,
    this.errors = const [],
  });

  String get errorMessage => errors.map((error) => error.toString()).join('\n');

  @override
  String toString() => text;
}
