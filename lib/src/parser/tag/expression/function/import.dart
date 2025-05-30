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

class ImportTemplate extends ExpressionFunction<IntermediateRenderResult> {
  ImportTemplate()
    : super(
        name: 'importTemplate',
        description: 'Imports, parses and renders a template file',
        exampleExpression:
            "{{importTemplate('test/src/parser/tag/expression/function/import/to_import.md.template')}}",
        exampleCode: ProjectFilePath(
          'test/src/parser/tag/expression/function/import/'
          'import_template_test.dart',
        ),
        parameters: [
          Parameter<String>(
            name: 'source',
            description: 'The project path of the template file',
            presence: Presence.mandatory(),
          ),
        ],
        function: (position, renderContext, parameters) async {
          var source = parameters['source'] as String;

          try {
            var text = await readSource(source);
            var template = ImportedTemplate(source: source, text: text);
            TemplateParseResult? templateParseResult = renderContext
                .parsedTemplates
                .firstWhereOrNull((pt) => pt.template == template);
            if (templateParseResult == null) {
              var engine = renderContext.engine;
              var parseResult = await engine.parseTemplate(template);
              templateParseResult = parseResult.children.first;
              renderContext.parsedTemplates.add(templateParseResult);
            }
            var renderResult = await templateParseResult.render(renderContext);
            var errors = renderResult.errors;
            if (errors.isNotEmpty) {
              var error = ImportError(position, template, [...errors]);
              renderResult.errors.clear();
              renderResult.errors.add(error);
            }
            return renderResult;
          } on Exception catch (e) {
            var message = e
                .toString()
                .replaceFirst('Exception: ', '')
                .replaceAll('\r', '')
                .replaceAll('\n', '');
            throw RenderError(
              message: 'Error importing template: $message',
              position: position,
            );
          }
        },
      );
}

class ImportPure extends ExpressionFunction<String> {
  ImportPure()
    : super(
        name: 'importPure',
        description: 'Imports a file as is (without parsing and rendering)',
        exampleExpression:
            "{{importPure('test/src/template_engine_template_example_test.dart')}}",
        exampleCode: ProjectFilePath(
          'test/src/parser/tag/expression/function/import/import_pure_test.dart',
        ),
        parameters: [
          Parameter<String>(
            name: 'source',
            description:
                'The project path of the file. '
                'This path can be a absolute or relative file path or URI.',
            presence: Presence.mandatory(),
          ),
        ],
        function: (position, renderContext, parameters) async {
          try {
            var source = parameters['source'] as String;
            var text = await readSource(source);
            return text;
          } on Exception catch (e) {
            var message = e
                .toString()
                .replaceFirst('Exception: ', '')
                .replaceAll('\r', '')
                .replaceAll('\n', '');
            throw RenderError(
              message: 'Error importing a pure file: $message',
              position: position,
            );
          }
        },
      );
}

class ImportJson extends ExpressionFunction<Map<String, dynamic>> {
  ImportJson()
    : super(
        name: 'importJson',
        description:
            'Imports a JSON file '
            'and decode it to a Map<String, dynamic>, '
            'which could be assigned it to a variable.',
        exampleExpression:
            "{{json=importJson('test/src/parser/tag/expression/function/import/person.json')}}"
            "{{json.person.child.name}}",
        exampleCode: ProjectFilePath(
          'test/src/parser/tag/expression/function/import/import_json_test.dart',
        ),
        parameters: [
          Parameter<String>(
            name: 'source',
            description:
                'The project path of the JSON file. '
                'This path can be a absolute or relative file path or URI.',
            presence: Presence.mandatory(),
          ),
        ],
        function: (position, renderContext, parameters) async {
          try {
            var source = parameters['source'] as String;
            var jsonText = await readSource(source);
            var jsonMap = jsonDecode(jsonText);
            return jsonMap;
          } on Exception catch (e) {
            var message = e
                .toString()
                .replaceFirst('Exception: ', '')
                .replaceAll('\r', '')
                .replaceAll('\n', '');
            throw RenderError(
              message: 'Error importing a Json file: $message',
              position: position,
            );
          }
        },
      );
}

class ImportXml extends ExpressionFunction<Map<String, dynamic>> {
  ImportXml()
    : super(
        name: 'importXml',
        description:
            'Imports a XML file '
            'and decode it to a Map<String, dynamic>, '
            'which could be assigned it to a variable.',
        exampleExpression:
            "{{xml=importXml('test/src/parser/tag/expression/function/import/person.xml')}}"
            "{{xml.person.child.name}}",
        exampleCode: ProjectFilePath(
          'test/src/parser/tag/expression/function/import/import_xml_test.dart',
        ),
        parameters: [
          Parameter<String>(
            name: 'source',
            description:
                'The project path of the XML file. '
                'This path can be a absolute or relative file path or URI.',
            presence: Presence.mandatory(),
          ),
        ],
        function: (position, renderContext, parameters) async {
          try {
            var source = parameters['source'] as String;

            var xmlText = await readSource(source);
            var xmlMap = xmlToDataMap(xmlText);
            return xmlMap;
          } on Exception catch (e) {
            var message = e
                .toString()
                .replaceFirst('Exception: ', '')
                .replaceAll('\r', '')
                .replaceAll('\n', '');
            throw RenderError(
              message: 'Error importing a XML file: $message',
              position: position,
            );
          }
        },
      );

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
        description:
            'Imports a YAML file '
            'and decode it to a Map<String, dynamic>, '
            'which could be assigned it to a variable.',
        exampleExpression:
            "{{yaml=importYaml('test/src/parser/tag/expression/function/import/person.yaml')}}"
            "{{yaml.person.child.name}}",
        exampleCode: ProjectFilePath(
          'test/src/parser/tag/expression/function/import/import_yaml_test.dart',
        ),
        parameters: [
          Parameter<String>(
            name: 'source',
            description:
                'The project path of the YAML file. '
                'This path can be a absolute or relative file path or URI.',
            presence: Presence.mandatory(),
          ),
        ],
        function: (position, renderContext, parameters) async {
          try {
            var source = parameters['source'] as String;
            var yamlText = await readSource(source);
            var yamlMap = yamlToDataMap(yamlText);
            return yamlMap;
          } on Exception catch (e) {
            var message = e
                .toString()
                .replaceFirst('Exception: ', '')
                .replaceAll('\r', '')
                .replaceAll('\n', '');
            var error = RenderError(
              message: 'Error importing a YAML file: $message',
              position: position,
            );
            throw error;
          }
        },
      );

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
    String key,
    dynamic value,
  ) {
    if (value is YamlMap) {
      return MapEntry(key, _yamlMapToDataMap(value));
    } else {
      return MapEntry(key, value);
    }
  }
}
