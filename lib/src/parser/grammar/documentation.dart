import 'package:template_engine/template_engine.dart';

abstract class DocumentationProvider {
  MarkdownDocumentation get documentation;
}

abstract class MarkdownDocumentation {
  String createMarkdownDocumentation(Grammar grammar, int titleLevel);
}

String markdownTitle(int titleLevel, String title) =>
    '${'#' * titleLevel} $title';

const String templateEngineHyperLink =
    '[template_engine](https://pub.dev/packages/template_engine)';

const String templateEngineGitHubBlobMainUri =
    'https://github.com/domain-centric/template_engine/blob/main';

class DefinitionDocumentation
    implements MarkdownDocumentation, ExampleProvider {
  final String title;
  final String description;
  final SyntaxDocumentation? syntax;
  @override
  final List<Example> examples;

  const DefinitionDocumentation({
    required this.title,
    required this.description,
    this.syntax,
    this.examples = const [],
  });

  @override
  String createMarkdownDocumentation(Grammar grammar, int titleLevel) {
    var writer = HtmlTableWriter();
    writer.setTitle(titleLevel, title);
    writer.addRow(['description:', description]);
    if (syntax != null) {
      writer.addRow([
        'syntax:',
        syntax!.codeBlockFunction(grammar.codeBlockDelimiter),
      ]);
      var explanation = syntax!.explanationFunction(grammar.codeBlockDelimiter);
      if (explanation.isNotEmpty) {
        writer.addRow(['syntax explanation:', explanation]);
      }
    }
    for (final example in examples) {
      writer.addRow([
        '${example.typeString}:',
        example.toMarkdown(grammar.codeBlockDelimiter),
      ]);
    }
    return writer.toHtml();
  }
}

class SyntaxDocumentation {
  final String Function(CodeBlockDelimiter delimiter) codeBlockFunction;
  final String Function(CodeBlockDelimiter delimiter) explanationFunction;

  SyntaxDocumentation({
    required this.codeBlockFunction,
    required this.explanationFunction,
  });
}

class HtmlTableWriter {
  String? titleLine;
  List<String> rows = [];

  HtmlTableWriter();

  /// Adds a title above the Table for navigation
  /// * From the wiki navigation pane
  /// * Deep linking using [Uri.fragment]
  void setTitle(int titleLevel, String title) {
    titleLine = "${'#' * (titleLevel)} $title";
  }

  void addHeaderRow(List<String> values, [List<int>? columnSpans]) {
    var row = HtmlTableRow(values, columnSpans, CellType.tableHeader);
    rows.add(row.toHtml());
  }

  void addRow(List<String> values, [List<int>? columnSpans]) {
    var row = HtmlTableRow(values, columnSpans, CellType.tableData);
    rows.add(row.toHtml());
  }

  String toHtml() =>
      [?titleLine, '<table>', ...rows, '</table>', ''].join('\n');
}

class HtmlTableRow {
  late StringBuffer row;

  HtmlTableRow(
    List<String> values, [
    List<int>? columnSpans,
    CellType cellType = CellType.tableData,
  ]) {
    row = StringBuffer();
    row.write('<tr>');
    for (int i = 0; i < values.length; i++) {
      var span = _columnSpan(columnSpans, i);
      if (span <= 1) {
        row.write('<${cellType.elementName}>');
      } else {
        row.write('<${cellType.elementName} colspan="$span">');
      }
      row.write(values[i]);
      row.write('</${cellType.elementName}>');
    }
    row.write('</tr>');
  }

  int _columnSpan(List<int>? columnSpans, int i) {
    if (columnSpans == null || i >= columnSpans.length) {
      return 1;
    }
    return columnSpans[i];
  }

  String toHtml() => row.toString();
}

enum CellType {
  tableHeader('th'),

  /// normal cell
  tableData('td');

  final String elementName;
  const CellType(this.elementName);
}

String typeDescription(Type type) {
  var description = type.toString();
  if (description == 'num') return 'number';
  if (description == 'bool') return 'boolean';
  return description;
}
