import 'package:collection/collection.dart';
import 'package:template_engine/template_engine.dart';

class ImportFunctions extends FunctionGroup {
  ImportFunctions()
      : super('Import Functions', [
          ImportFile(),
        ]);
}

class ImportFile extends ExpressionFunction<String> {
  ImportFile()
      : super(
            name: 'import',
            description: 'Imports a file',
            exampleExpression:
                "{{import('doc/template/common/generated_comment.template')}}",
            exampleCode: ProjectFilePath(
                'test/src/parser/tag/expression/function/import/import_test.dart'),
            parameters: [
              Parameter<String>(
                  name: 'value',
                  presence: Presence
                      .mandatory()) //TODO check if it is a valide [ProjectFilePath]
              ///TODO parameter type: template, text, code, dartCode
            ],
            function: (renderContext, parameters) {
              var projectFilePath =
                  ProjectFilePath(parameters['value'] as String);
              var template = FileTemplate.fromProjectFilePath(projectFilePath);
              TemplateParseResult? parsedTemplate = renderContext
                  .parsedTemplates
                  .firstWhereOrNull((pt) => pt.template == template);
              if (parsedTemplate == null) {
                var engine = renderContext.engine;
                parsedTemplate = engine
                    .parseTemplate(template)
                    .children
                    .first; //TODO what to do with parserTemplate.errorMessage?
              }
              renderContext.parsedTemplates.add(parsedTemplate);
              var renderResult = parsedTemplate.render(
                  renderContext); //TODO what to do with renderResult.errorMessage?
              return renderResult;
            });
}
