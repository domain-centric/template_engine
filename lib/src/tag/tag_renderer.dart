import 'package:template_engine/src/error.dart';
import 'package:template_engine/template_engine.dart';

abstract class TagRenderer extends Renderer {
  final TemplateSource source;

  TagRenderer(
    this.source,

    /// See [TagName]
  );

  // @override
  // String render(RenderContext context) {
  //   try {
  //     var value = context.variables.value(namePath);
  //     return value.toString();
  //   } on VariableException catch (e) {
  //     context.errors.add(
  //         Error(stage: ErrorStage.render, message: e.message, source: source));
  //     return '';
  //   }
  // }
}
