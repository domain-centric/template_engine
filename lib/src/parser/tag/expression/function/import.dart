import 'package:collection/collection.dart';
import 'package:template_engine/template_engine.dart';

class ImportFunctions extends FunctionGroup {
  ImportFunctions()
      : super('Import Functions', [
          ImportTemplate(),
          ImportPure(),
          ImportJson(),
          ImportXml(),
        ]);
}

class ImportTemplate extends ExpressionFunction<String> {
  ImportTemplate()
      : super(
            name: 'importTemplate',
            description: 'Imports, parses and renders a template file',
            exampleExpression:
                "{{import('doc/template/common/generated_comment.template')}}",
            exampleCode: ProjectFilePath(
                'test/src/parser/tag/expression/function/import/'
                'import_template_test.dart'),
            parameters: [
              Parameter<String>(
                  name: 'source',
                  description: 'The project path of the template file',
                  presence: Presence.mandatory())
            ],
            function: (position, renderContext, parameters) {
              try {
                var projectFilePath =
                    ProjectFilePath(parameters['source'] as String);

                var template =
                    ImportedJson.fromProjectFilePath(projectFilePath);
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

class ImportPure extends ExpressionFunction<String> {
  ImportPure()
      : super(
            name: 'importPure',
            description: 'Imports a file as is (without parsing and rendering)',
            exampleExpression:
                "{{import.pure('test/src/template_engine_template_example_test.dart')}}",
            exampleCode: ProjectFilePath(
                'test/src/parser/tag/expression/function/import/import_pure_test.dart'),
            parameters: [
              Parameter<String>(
                  name: 'source',
                  description: 'The project path of the file',
                  presence: Presence.mandatory())
            ],
            function: (position, renderContext, parameters) {
              try {
                var projectFilePath =
                    ProjectFilePath(parameters['source'] as String);

                var template =
                    ImportedTemplate.fromProjectFilePath(projectFilePath);
                return template.text;
              } on Exception catch (e) {
                var error = RenderError(
                    message: 'Error importing a pure file: '
                        '${e.toString().replaceAll('\r', '').replaceAll('\n', '')}',
                    position: position);
                renderContext.errors.add(error);
                return renderContext.renderedError;
              }
            });
}

class ImportJson extends ExpressionFunction<Map<String, dynamic>> {
  ImportJson()
      : super(
            name: 'importJson',
            description: 'Imports a json file '
                'and decode it to a Map<String, dynamic>. '
                'You could use it assign it to a variable.',
            exampleExpression:
                "{{json=importJson('test/src/parser/tag/expression/function/import/person.json')}}"
                "{{json.person.child.name}}",
            exampleCode: ProjectFilePath(
                'test/src/parser/tag/expression/function/import/import_json_test.dart'),
            parameters: [
              Parameter<String>(
                  name: 'source',
                  description: 'The project path of the json file',
                  presence: Presence.mandatory())
            ],
            function: (position, renderContext, parameters) {
              try {
                var projectFilePath =
                    ProjectFilePath(parameters['source'] as String);

                var json = ImportedJson.fromProjectFilePath(projectFilePath);

                return json.decode();
              } on Exception catch (e) {
                var error = RenderError(
                    message: 'Error importing a Json file: '
                        '${e.toString().replaceAll('\r', '').replaceAll('\n', '')}',
                    position: position);
                renderContext.errors.add(error);
                return {};
              }
            });
}

class ImportXml extends ExpressionFunction<Map<String, dynamic>> {
  ImportXml()
      : super(
            name: 'importXml',
            description: 'Imports a XML file '
                'and decode it to a Map<String, dynamic>. '
                'You could use it assign it to a variable.',
            exampleExpression:
                "{{xml=importXml('test/src/parser/tag/expression/function/import/person.xml')}}"
                "{{xml.person.child.name}}",
            exampleCode: ProjectFilePath(
                'test/src/parser/tag/expression/function/import/import_xml_test.dart'),
            parameters: [
              Parameter<String>(
                  name: 'source',
                  description: 'The project path of the XML file',
                  presence: Presence.mandatory())
            ],
            function: (position, renderContext, parameters) {
              try {
                var projectFilePath =
                    ProjectFilePath(parameters['source'] as String);

                var xml = ImportedXml.fromProjectFilePath(projectFilePath);

                return xml.decode();
              } on Exception catch (e) {
                var error = RenderError(
                    message: 'Error importing a XML file: '
                        '${e.toString().replaceAll('\r', '').replaceAll('\n', '')}',
                    position: position);
                renderContext.errors.add(error);
                return {};
              }
            });
}
