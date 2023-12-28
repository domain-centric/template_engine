import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:template_engine/template_engine.dart';
import 'package:xml/xml.dart';
import 'package:yaml/yaml.dart';

class ImportFunctions extends FunctionGroup {
  ImportFunctions()
      : super('Import Functions', [
          ImportTemplate(),
          ImportPure(),
          ImportJson(),
          ImportXml(),
          ImportYaml(),
        ]);
}

class ImportTemplate extends ExpressionFunction<String> {
  ImportTemplate()
      : super(
            name: 'importTemplate',
            description: 'Imports, parses and renders a template file',
            exampleExpression:
                "{{importTemplate('doc/template/common/generated_comment.template')}}",
            exampleCode: ProjectFilePath(
                'test/src/parser/tag/expression/function/import/'
                'import_template_test.dart'),
            parameters: [
              Parameter<String>(
                  name: 'source',
                  description: 'The project path of the template file',
                  presence: Presence.mandatory())
            ],
            function: (position, renderContext, parameters) async {
              try {
                var source = parameters['source'] as String;
                var text = await readSource(source);
                var template = ImportedTemplate(source: source, text: text);

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
                var renderResult = await parsedTemplate.render(renderContext);

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
                "{{importPure('test/src/template_engine_template_example_test.dart')}}",
            exampleCode: ProjectFilePath(
                'test/src/parser/tag/expression/function/import/import_pure_test.dart'),
            parameters: [
              Parameter<String>(
                  name: 'source',
                  description: 'The project path of the file. '
                      'This path can be a absolute or relative file path or URI.',
                  presence: Presence.mandatory())
            ],
            function: (position, renderContext, parameters) async {
              try {
                var source = parameters['source'] as String;
                var text = await readSource(source);
                return text;
              } on Exception catch (e) {
                var error = RenderError(
                    message: 'Error importing a pure file: '
                        '${e.toString().replaceAll('\r', '').replaceAll('\n', '')}',
                    position: position);
                renderContext.errors.add(error);
                return Future.value(renderContext.renderedError);
              }
            });
}

class ImportJson extends ExpressionFunction<Map<String, dynamic>> {
  ImportJson()
      : super(
            name: 'importJson',
            description: 'Imports a JSON file '
                'and decode it to a Map<String, dynamic>, '
                'which could be assigned it to a variable.',
            exampleExpression:
                "{{json=importJson('test/src/parser/tag/expression/function/import/person.json')}}"
                "{{json.person.child.name}}",
            exampleCode: ProjectFilePath(
                'test/src/parser/tag/expression/function/import/import_json_test.dart'),
            parameters: [
              Parameter<String>(
                  name: 'source',
                  description: 'The project path of the JSON file. '
                      'This path can be a absolute or relative file path or URI.',
                  presence: Presence.mandatory())
            ],
            function: (position, renderContext, parameters) async {
              try {
                var source = parameters['source'] as String;
                var jsonText = await readSource(source);
                var jsonMap = jsonDecode(jsonText);
                return jsonMap;
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
                'and decode it to a Map<String, dynamic>, '
                'which could be assigned it to a variable.',
            exampleExpression:
                "{{xml=importXml('test/src/parser/tag/expression/function/import/person.xml')}}"
                "{{xml.person.child.name}}",
            exampleCode: ProjectFilePath(
                'test/src/parser/tag/expression/function/import/import_xml_test.dart'),
            parameters: [
              Parameter<String>(
                  name: 'source',
                  description: 'The project path of the XML file. '
                      'This path can be a absolute or relative file path or URI.',
                  presence: Presence.mandatory())
            ],
            function: (position, renderContext, parameters) async {
              try {
                var source = parameters['source'] as String;

                var xmlText = await readSource(source);
                var xmlMap = xmlToDataMap(xmlText);
                return xmlMap;
              } on Exception catch (e) {
                var error = RenderError(
                    message: 'Error importing a XML file: '
                        '${e.toString().replaceAll('\r', '').replaceAll('\n', '')}',
                    position: position);
                renderContext.errors.add(error);
                return {};
              }
            });

  static DataMap xmlToDataMap(String xml) {
    var document = XmlDocument.parse(xml);
    return _xmlNodeToDataMap(document);
  }

  static Map<String, dynamic> _xmlNodeToDataMap(XmlNode node) {
    var map = <String, dynamic>{};
    for (var element in node.childElements) {
      var entry = _xmlElementToEntry(element);
      if (map.containsKey(entry.key)) {
        var existingValue = map[entry.key];
        if (existingValue is List) {
          existingValue.add(entry.value);
        } else {
          var list = [];
          list.add(existingValue);
          map[entry.key] = list;
        }
      } else {
        map[entry.key] = entry.value;
      }
    }
    return map;
  }

  static MapEntry<String, dynamic> _xmlElementToEntry(XmlElement element) {
    if (element.children.length == 1 && element.children.first is XmlText) {
      return MapEntry(element.name.local, element.innerText);
    } else {
      return MapEntry(element.name.local, _xmlNodeToDataMap(element));
    }
  }
}

class ImportYaml extends ExpressionFunction<Map<String, dynamic>> {
  ImportYaml()
      : super(
            name: 'importYaml',
            description: 'Imports a YAML file '
                'and decode it to a Map<String, dynamic>, '
                'which could be assigned it to a variable.',
            exampleExpression:
                "{{yaml=importYaml('test/src/parser/tag/expression/function/import/person.yaml')}}"
                "{{yaml.person.child.name}}",
            exampleCode: ProjectFilePath(
                'test/src/parser/tag/expression/function/import/import_yaml_test.dart'),
            parameters: [
              Parameter<String>(
                  name: 'source',
                  description: 'The project path of the YAML file. '
                      'This path can be a absolute or relative file path or URI.',
                  presence: Presence.mandatory())
            ],
            function: (position, renderContext, parameters) async {
              try {
                var source = parameters['source'] as String;
                var yamlText = await readSource(source);
                var yamlMap = yamlToDataMap(yamlText);
                return yamlMap;
              } on Exception catch (e) {
                var error = RenderError(
                    message: 'Error importing a YAML file: '
                        '${e.toString().replaceAll('\r', '').replaceAll('\n', '')}',
                    position: position);
                renderContext.errors.add(error);
                return {};
              }
            });

  static DataMap yamlToDataMap(String yaml) {
    var document = loadYaml(yaml);
    var map = _yamlMapToDataMap(document);
    return map;
  }

  static DataMap _yamlMapToDataMap(YamlMap yamlMap) {
    var map = <String, dynamic>{};
    for (var key in yamlMap.keys) {
      var value = yamlMap[key];
      var entry = _yamlKeyValueToEntry(key, value);
      if (map.containsKey(entry.key)) {
        var existingValue = map[entry.key];
        if (existingValue is List) {
          existingValue.add(entry.value);
        } else {
          var list = [];
          list.add(existingValue);
          map[entry.key] = list;
        }
      } else {
        map[entry.key] = entry.value;
      }
    }
    return map;
  }

  static MapEntry<String, dynamic> _yamlKeyValueToEntry(
      String key, dynamic value) {
    if (value is YamlMap) {
      return MapEntry(key, _yamlMapToDataMap(value));
    } else {
      return MapEntry(key, value);
    }
  }
}
