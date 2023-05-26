import 'package:logging/logging.dart';

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
  List<RenderNode> children = [];

  @override
  String render(RenderContext context) =>
      children.map((node) => node.render(context)).join();
}



/// Creates a [parser tree](https://en.wikipedia.org/wiki/Parse_tree)
/// from the parse result.
class ParserTree extends ParentNode {
  ParserTree(List parseResult) {
    _populateChildren(parseResult);
  }

  void _populateChildren(List<dynamic> parseResult) {
    for (var value in parseResult) {
      if (value is RenderNode) {
        children.add(value);
      } else if (children.isNotEmpty && children.last is TextNode) {
        ((children.last) as TextNode).text += value.toString();
      } else {
        children.add(TextNode(value.toString()));
      }
    }
  }
}

class RenderContext {
  final Map<String, Object> variables;
  final Logger logger;

  RenderContext({
    required Map<String, Object> variables,
    required this.logger,
  }) : variables = _createMapClone(variables);

  static _createMapClone(Map<String, Object> variables) =>
      Map<String, Object>.from(variables);
}
