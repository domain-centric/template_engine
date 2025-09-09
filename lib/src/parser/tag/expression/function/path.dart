import 'package:template_engine/template_engine.dart';

class PathFunctions extends FunctionGroup {
  PathFunctions() : super('Path Functions', [TemplateSource()]);
}

class TemplateSource extends ExpressionFunction<String> {
  TemplateSource()
    : super(
        name: "templateSource",
        description: 'Gives the relative path of the current template',
        exampleExpression: "{{templateSource()}}",
        exampleCode: ProjectFilePath(
          'test/src/parser/tag/expression/function/template/template_test.dart',
        ),
        function:
            (
              Position position,
              RenderContext renderContext,
              Map<String, Object> parameterValues,
            ) => Future.value(renderContext.templateBeingRendered.sourceTitle),
      );
}
