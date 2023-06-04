import 'package:template_engine/src/error.dart';
import 'package:template_engine/src/variable/variable.dart';
import 'package:template_engine/template_engine.dart';

/// A [RenderNode] to render a [VariableValue]
class VariableNode extends RenderNode {
  final String namePath;
  final TemplateSource source;

  VariableNode({
    required this.source,

    /// See [VariableName]
    required this.namePath,
  });

  @override
  String render(RenderContext context) {
    try {
      var value = context.variables.value(namePath);
      return value.toString();
    } on VariableException catch (e) {
      context.errors.add(
          Error(stage: ErrorStage.render, message: e.message, source: source));
      return '';
    }
  }
}
