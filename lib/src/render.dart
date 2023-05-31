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
      children.map((node) => node.render(context)).join();
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

class RenderException implements Exception {
  final List<Error> events;
  final String message;

  RenderException(this.events)
      : message = events.map((event) => event.toString()).toSet().join('\n');

  @override
  String toString() => message;
}
