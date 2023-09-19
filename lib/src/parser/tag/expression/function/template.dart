import 'package:template_engine/template_engine.dart';

class TemplateGroup extends FunctionGroup {
  TemplateGroup() : super('Template', [TemplateSource()]);
}

class TemplateSource extends ExpressionFunction<String> {
  TemplateSource()
      : super(
            name: "template.source",
            description: 'Gives the relative path of the current template',
            function: templateSourcePath);

  static String templateSourcePath(
          RenderContext renderContext, Map<String, Object> parameterValues) =>
      renderContext.template.source;
}
