import 'dart:collection';

import 'package:logging/logging.dart';

/// Renders some text depending on the implementation of the [RenderNode]
abstract class RenderNode {
  String render(RenderContext context);
}

/// A [RenderNode] that is a placeholder for normal text
class TextNode implements RenderNode {
  final String text;

  TextNode(this.text);

  @override
  String render(RenderContext context) => text;
}

class ParentNode extends RenderNode {
  List<RenderNode> children = [];

  @override
  String render(RenderContext context) =>
      children.map((node) => node.render(context)).join();
}

class RenderContext {
  final Map<String, Object> variables;
  final Logger logger;
  RenderContext(
    UnmodifiableMapView<String, Object> variables,
    this.logger,
  ) : variables = _createMapClone(variables);

  static _createMapClone(UnmodifiableMapView variables) =>
      Map<String, Object>.from(variables);
}
