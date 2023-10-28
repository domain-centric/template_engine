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
              Parameter<String>(name: 'value', presence: Presence.mandatory())
              // TODO parameter type: template, text, code, dartCode
            ],
            function: (position, renderContext, parameters) {
              try {
                var projectFilePath =
                    ProjectFilePath(parameters['value'] as String);

                var template =
                    ImportedTemplate.fromProjectFilePath(projectFilePath);
                TemplateParseResult? parsedTemplate = renderContext
                    .parsedTemplates
                    .firstWhereOrNull((pt) => pt.template == template);
                if (parsedTemplate == null) {
                  var engine = renderContext.engine;

                  parsedTemplate =
                      engine.parseTemplate(template).children.first;
                  renderContext.parsedTemplates.add(parsedTemplate);
                }
                var errorsBefore = [...renderContext.errors];
                var renderResult = parsedTemplate.render(renderContext);

                var importErrors = renderContext.errors
                    .where((error) => !errorsBefore.contains(error))
                    .toList();
                if (importErrors.isNotEmpty) {
                  var importError =
                      ImportError(position, template, importErrors);
                  renderContext.errors = [...errorsBefore, importError];
                }
                return renderResult;
              } on Exception catch (e) {
                var error = RenderError(
                    message: 'Error importing template: '
                        '${e.toString().replaceAll('\r', '').replaceAll('\n', '')}',
                    position: position);
                renderContext.errors.add(error);
                return renderContext.renderedError;
              }
            });
}
