import 'package:template_engine/src/error.dart';
import 'package:template_engine/src/variable/variable.dart';
import 'package:template_engine/template_engine.dart';

/// A [Renderer] to render a [VariableValue]
class VariableRenderer extends Renderer<Object?> {
  final String namePath;
  final TemplateSource source;

  VariableRenderer({
    required this.source,

    /// See [VariableName]
    required this.namePath,
  });

  @override
  Object? render(RenderContext context) {
    try {
      return context.variables.value(namePath);
    } on VariableException catch (e) {
      context.errors.add(
          Error(stage: ErrorStage.render, message: e.message, source: source));
      return '';
    }
  }
}
