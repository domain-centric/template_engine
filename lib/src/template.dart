import 'dart:convert';
import 'dart:io';

import 'package:template_engine/template_engine.dart';
import 'package:xml/xml.dart';
import 'package:yaml/yaml.dart';

/// A template is a text that can contain [Tag]s.
/// This text is parsed by the [TemplateEngine] into [Renderer]s.
/// These [Renderer]s render a new text.
/// [TagRenderer]s are replaced with some other text, depending on the
/// implementation of the [TagRenderer]
abstract class Template {
  /// Explains where the template text came form.
  final String source;

  /// The text to be parsed by the [TemplateEngine]
  final String text;

  const Template({
    required this.source,
    required this.text,
  });

  @override
  bool operator ==(Object other) =>
      other is Template &&
      other.source.toLowerCase() == source.toLowerCase() &&
      other.text == text;

  @override
  int get hashCode => source.toLowerCase().hashCode ^ text.hashCode;
}

class TextTemplate extends Template {
  TextTemplate(String text)
      : super(
          source: createSource(text),
          text: text,
        );

  static createSource(String text) {
    String textToShow = text.split(RegExp('\\n')).first;

    if (textToShow.length > 40) {
      textToShow = textToShow.substring(0, 40);
    }

    if (text.length > textToShow.length) {
      return "'$textToShow...'";
    } else {
      return "'$textToShow'";
    }
  }
}

class FileTemplate extends Template {
  FileTemplate(File source)
      : super(source: source.path, text: source.readAsStringSync());

  FileTemplate.fromProjectFilePath(ProjectFilePath path)
      : super(source: path.relativePath, text: path.file.readAsStringSync());
}

class ImportedTemplate extends FileTemplate {
  ImportedTemplate.fromProjectFilePath(super.path)
      : super.fromProjectFilePath();
}

class ImportedJson extends FileTemplate {
  ImportedJson.fromProjectFilePath(super.path) : super.fromProjectFilePath();

  Map<String, dynamic> decode() => jsonDecode(text);
}

class ImportedXml extends FileTemplate {
  ImportedXml.fromProjectFilePath(super.path) : super.fromProjectFilePath();

  Map<String, dynamic> decode() {
    var document = XmlDocument.parse(text);
    return convertToMap(document);
  }

  Map<String, dynamic> convertToMap(XmlNode node) {
    var map = <String, dynamic>{};
    for (var element in node.childElements) {
      var entry = convertToEntry(element);
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

  MapEntry<String, dynamic> convertToEntry(XmlElement element) {
    if (element.children.length == 1 && element.children.first is XmlText) {
      return MapEntry(element.name.local, element.innerText);
    } else {
      return MapEntry(element.name.local, convertToMap(element));
    }
  }
}

class ImportedYaml extends FileTemplate {
  ImportedYaml.fromProjectFilePath(super.path) : super.fromProjectFilePath();

  Map<String, dynamic> decode() {
    var document = loadYaml(text);
    var map = convertToMap(document);
    return map;
  }

  Map<String, dynamic> convertToMap(YamlMap yamlMap) {
    var map = <String, dynamic>{};
    for (var key in yamlMap.keys) {
      var value = yamlMap[key];
      var entry = convertToEntry(key, value);
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

  MapEntry<String, dynamic> convertToEntry(String key, dynamic value) {
    if (value is YamlMap) {
      return MapEntry(key, convertToMap(value));
    } else {
      return MapEntry(key, value);
    }
  }
}
