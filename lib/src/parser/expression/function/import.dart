import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:template_engine/template_engine.dart';
import 'package:xml/xml.dart';
import 'package:yaml/yaml.dart';

final standardImportFunctions = FunctionGroup('Import Functions', [
  importTemplate,
  importPure,
  importJson,
  importXml,
  importYaml,
]);

final importTemplate = FunctionDefinition(
  name: 'importTemplate',
  documentation: FunctionDefinitionDocumentation(
    description: 'Imports, parses and renders a template file as a string',
    examples: [
      ExpressionBlockExample(
        (delimiter) =>
            "${delimiter.start}importTemplate('test/src/parser/expression/function/import/to_import.md.template')${delimiter.end}",
      ),
      TestFileExample.fromProjectFilePath(
        'test/src/parser/expression/function/import/'
        'import_template_test.dart',
      ),
    ],
  ),
  parameters: [
    Parameter<String>(
      name: 'source',
      description: 'The project path of the template file',
      presence: PresenceMandatory(),
    ),
  ],
  function: (context) async {
    var source = context.argumentValues['source'] as String;

    try {
      var renderContext = context.renderContext;
      var engine = TemplateEngine(renderContext.grammar);
      var text = await readSource(source);
      var template = ImportedTemplate(source: source, text: text);
      // do we have a cashed import?
      ParseResult? templateParseResult = renderContext.parsedImportedTemplates
          .firstWhereOrNull((pt) => pt.document.template == template);
      if (templateParseResult == null) {
        // if not create it
        templateParseResult = await engine.parseTemplate(template);
        // and cash it
        renderContext.parsedImportedTemplates.add(templateParseResult);
        // parse errors can be retrieved from renderContext.parsedTemplates
      }
      var renderResult = await engine.render(
        templateParseResult,
        parsedImportedTemplates: renderContext.parsedImportedTemplates,
        variables: renderContext.variables,
      );
      if (renderResult.errors.isNotEmpty) {
        var error = ImportError(context.functionLocation, renderResult);
        renderContext.errors.add(error);
      }
      return renderResult.text;
    } on Exception catch (e) {
      var message = e
          .toString()
          .replaceFirst('Exception: ', '')
          .replaceAll('\r', '')
          .replaceAll('\n', '');
      throw RenderError(
        'Error importing template: $message',
        context.functionLocation,
      );
    }
  },
);

final importPure = FunctionDefinition(
  name: 'importPure',
  documentation: FunctionDefinitionDocumentation(
    description: 'Imports a file as is (without parsing and rendering)',
    examples: [
      ExpressionBlockExample(
        (delimiter) =>
            "${delimiter.start}importPure('test/src/template_engine_template_example_test.dart')${delimiter.end}",
      ),
      TestFileExample.fromProjectFilePath(
        'test/src/parser/expression/function/import/import_pure_test.dart',
      ),
    ],
  ),

  parameters: [
    Parameter<String>(
      name: 'source',
      description:
          'The project path of the file. '
          'This path can be a absolute or relative file path or URI.',
      presence: PresenceMandatory(),
    ),
  ],
  function: (context) async {
    try {
      var source = context.argumentValues['source'] as String;
      var text = await readSource(source);
      return text;
    } on Exception catch (e) {
      var message = e
          .toString()
          .replaceFirst('Exception: ', '')
          .replaceAll('\r', '')
          .replaceAll('\n', '');
      throw RenderError(
        'Error importing a pure file: $message',
        context.functionLocation,
      );
    }
  },
);

final importJson = FunctionDefinition(
  name: 'importJson',
  documentation: FunctionDefinitionDocumentation(
    description:
        'Imports a JSON file '
        'and decode it to a Map<String, dynamic> '
        '(e.g. to be assigned to a variable)',
    examples: [
      ExpressionBlockExample(
        (delimiter) =>
            "${delimiter.start}json=importJson('test/src/parser/expression/"
            "function/import/person.json')${delimiter.end}"
            "${delimiter.start}json.person.child.name${delimiter.end}",
      ),
      TestFileExample.fromProjectFilePath(
        'test/src/parser/expression/function/import/import_json_test.dart',
      ),
    ],
  ),

  parameters: [
    Parameter<String>(
      name: 'source',
      description:
          'The project path of the JSON file. '
          'This path can be a absolute or relative file path or URI.',
      presence: PresenceMandatory(),
    ),
  ],
  function: (context) async {
    try {
      var source = context.argumentValues['source'] as String;
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
        'Error importing a Json file: $message',
        context.functionLocation,
      );
    }
  },
);

final importXml = FunctionDefinition(
  name: 'importXml',
  documentation: FunctionDefinitionDocumentation(
    description:
        'Imports a XML file '
        'and decode it to a Map<String, dynamic> '
        '(e.g. to be assigned to a variable)',
    examples: [
      ExpressionBlockExample(
        (delimiter) =>
            "${delimiter.start}xml=importXml('test/src/parser/expression"
            "/function/import/person.xml')${delimiter.end}"
            "${delimiter.start}xml.person.child.name${delimiter.end}",
      ),
      TestFileExample.fromProjectFilePath(
        'test/src/parser/expression/function/import/import_xml_test.dart',
      ),
    ],
  ),

  parameters: [
    Parameter<String>(
      name: 'source',
      description:
          'The project path of the XML file. '
          'This path can be a absolute or relative file path or URI.',
      presence: PresenceMandatory(),
    ),
  ],
  function: (context) async {
    try {
      var source = context.argumentValues['source'] as String;

      var xmlText = await readSource(source);
      var xmlMap = _xmlToDataMap(xmlText);
      return xmlMap;
    } on Exception catch (e) {
      var message = e
          .toString()
          .replaceFirst('Exception: ', '')
          .replaceAll('\r', '')
          .replaceAll('\n', '');
      throw RenderError(
        'Error importing a XML file: $message',
        context.functionLocation,
      );
    }
  },
);

DataMap _xmlToDataMap(String xml) {
  var document = XmlDocument.parse(xml);
  return _xmlNodeToDataMap(document);
}

Map<String, dynamic> _xmlNodeToDataMap(XmlNode node) {
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

MapEntry<String, dynamic> _xmlElementToEntry(XmlElement element) {
  if (element.children.length == 1 && element.children.first is XmlText) {
    return MapEntry(element.name.local, element.innerText);
  } else {
    return MapEntry(element.name.local, _xmlNodeToDataMap(element));
  }
}

final importYaml = FunctionDefinition(
  name: 'importYaml',
  documentation: FunctionDefinitionDocumentation(
    description:
        'Imports a YAML file '
        'and decode it to a Map<String, dynamic> '
        '(e.g. to be assigned to a variable)',
    examples: [
      ExpressionBlockExample(
        (delimiter) =>
            "${delimiter.start}yaml=importYaml('test/src/parser/expression/"
            "function/import/person.yaml')${delimiter.end}"
            "${delimiter.start}yaml.person.child.name${delimiter.end}",
      ),
      TestFileExample.fromProjectFilePath(
        'test/src/parser/expression/function/import/import_yaml_test.dart',
      ),
    ],
  ),

  parameters: [
    Parameter<String>(
      name: 'source',
      description:
          'The project path of the YAML file. '
          'This path can be a absolute or relative file path or URI.',
      presence: PresenceMandatory(),
    ),
  ],
  function: (context) async {
    try {
      var source = context.argumentValues['source'] as String;
      var yamlText = await readSource(source);
      var yamlMap = _yamlToDataMap(yamlText);
      return yamlMap;
    } on Exception catch (e) {
      var message = e
          .toString()
          .replaceFirst('Exception: ', '')
          .replaceAll('\r', '')
          .replaceAll('\n', '');
      throw RenderError(
        'Error importing a YAML file: $message',
        context.functionLocation,
      );
    }
  },
);

DataMap _yamlToDataMap(String yaml) {
  var document = loadYaml(yaml);
  var map = _yamlMapToDataMap(document);
  return map;
}

DataMap _yamlMapToDataMap(YamlMap yamlMap) {
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

MapEntry<String, dynamic> _yamlKeyValueToEntry(String key, dynamic value) {
  if (value is YamlMap) {
    return MapEntry(key, _yamlMapToDataMap(value));
  } else {
    return MapEntry(key, value);
  }
}
