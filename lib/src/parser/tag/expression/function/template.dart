import 'package:template_engine/template_engine.dart';

class TemplateFunctions extends FunctionGroup {
  TemplateFunctions() : super('Template Functions', [TemplateSource()]);
}

class TemplateSource extends ExpressionFunction<String> {
  TemplateSource()
      : super(
            name: "template.source",
            description: 'Gives the relative path of the current template',
            exampleExpression: "{{template.source()}}",
            exampleCode: ProjectFilePath(
                'test/src/parser/tag/expression/function/template/template_test.dart'),
            function: templateSourcePath);

  static String templateSourcePath(String position, RenderContext renderContext,
          Map<String, Object> parameterValues) =>
      renderContext.templateBeingRendered.source;
}
