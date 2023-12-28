import 'package:collection/collection.dart';
import 'package:template_engine/template_engine.dart';

/// Functions that create documentation of the [TemplateEngine] configuration
class DocumentationFunctions extends FunctionGroup {
  DocumentationFunctions()
      : super('Documentation Functions', [
          TagDocumentation(),
          DataTypeDocumentation(),
          ConstantDocumentation(),
          //Note: variable documentation can not be generated (=template text)
          FunctionDocumentation(),
          OperatorDocumentation(),
          ExampleDocumentation()
        ]);
}

class TitleLevelParameter extends Parameter<num> {
  TitleLevelParameter()
      : super(
            name: 'titleLevel',
            description: 'The level of the tag title',
            presence: Presence.optionalWithDefaultValue(1));
}

abstract class DocumentationFunction extends ExpressionFunction<String> {
  DocumentationFunction({
    required super.name,
    required super.description,
    super.exampleExpression,
    super.exampleResult,
    required List<String> Function(RenderContext renderContext, int titleLevel)
        documentationFunction,
  }) : super(
            parameters: [TitleLevelParameter()],
            function: (position, renderContext, parameters) => Future.value(
                documentationFunction(renderContext, _titleLevel(parameters))
                    .join('\n')));

  static int _titleLevel(
    Map<String, Object> parameters,
  ) {
    var titleLevel = parameters['titleLevel'];
    if (titleLevel is! int) {
      throw ParameterException('Parameter titleLevel: must be a integer');
    }
    if (titleLevel < 1 && titleLevel > 10) {
      throw ParameterException(
          'Parameter titleLevel: must be a number >=1 and <=10');
    }
    return titleLevel;
  }
}

class TagDocumentation extends DocumentationFunction {
  TagDocumentation()
      : super(
            name: 'tagDocumentation',
            description: 'Generates markdown documentation of all the tags '
                'within a TemplateEngine',
            documentationFunction: (renderContext, titleLevel) => renderContext
                .engine.tags
                .map((tag) =>
                    tag.createMarkdownDocumentation(renderContext, titleLevel))
                .flattened
                .toList());
}

class DataTypeDocumentation extends DocumentationFunction {
  DataTypeDocumentation()
      : super(
            name: 'dataTypeDocumentation',
            description: 'Generates markdown documentation of all the data '
                'types that can be used within a ExpressionTag of a '
                'TemplateEngine',
            documentationFunction: (renderContext, titleLevel) => renderContext
                .engine.dataTypes
                .map((dataType) => dataType.createMarkdownDocumentation(
                    renderContext, titleLevel))
                .flattened
                .toList());
}

class ConstantDocumentation extends DocumentationFunction {
  ConstantDocumentation()
      : super(
            name: 'constantDocumentation',
            description:
                'Generates markdown documentation of all the constants '
                'that can be used within a ExpressionTag of a TemplateEngine',
            documentationFunction: (renderContext, titleLevel) => renderContext
                .engine.constants
                .map((constant) => constant.createMarkdownDocumentation(
                    renderContext, titleLevel))
                .flattened
                .toList());
}

class FunctionDocumentation extends DocumentationFunction {
  FunctionDocumentation()
      : super(
            name: 'functionDocumentation',
            description:
                'Generates markdown documentation of all the functions '
                'that can be used within a ExpressionTag of a TemplateEngine',
            documentationFunction: (renderContext, titleLevel) => renderContext
                .engine.functionGroups
                .map((functionGroup) => functionGroup
                    .createMarkdownDocumentation(renderContext, titleLevel))
                .flattened
                .toList());
}

class OperatorDocumentation extends DocumentationFunction {
  OperatorDocumentation()
      : super(
            name: 'operatorDocumentation',
            description:
                'Generates markdown documentation of all the operators '
                'that can be used within a ExpressionTag of a TemplateEngine',
            documentationFunction: (renderContext, titleLevel) => renderContext
                .engine.operatorGroups
                .map((operatorGroup) => operatorGroup
                    .createMarkdownDocumentation(renderContext, titleLevel))
                .flattened
                .toList());
}

class ExampleDocumentation extends DocumentationFunction {
  ExampleDocumentation()
      : super(
            name: 'exampleDocumentation',
            description:
                'Generates markdown documentation of all the examples. '
                'This could be used to generate example.md file.',
            documentationFunction: (renderContext, titleLevel) => renderContext
                .engine.tags
                .map((tag) =>
                    tag.createMarkdownExamples(renderContext, titleLevel))
                .flattened
                .toList());
}

abstract class DocumentationFactory {
  List<String> createMarkdownDocumentation(
      RenderContext renderContext, int titleLevel);
}

abstract class ExampleFactory {
  List<String> createMarkdownExamples(
      RenderContext renderContext, int titleLevel);
}

class HtmlTableWriter {
  List<String> rows = [];

  void addHeaderRow(List<String> values, [List<int>? columnSpans]) {
    var row = HtmlTableRow(values, columnSpans, CellType.tableHeader);
    rows.add(row.toHtml());
  }

  void addRow(List<String> values, [List<int>? columnSpans]) {
    var row = HtmlTableRow(values, columnSpans, CellType.tableData);
    rows.add(row.toHtml());
  }

  List<String> toHtmlLines() => [
        '<table>',
        ...rows,
        '</table>',
        '',
      ];
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

String typeDescription<T>() {
  switch (T) {
    case const (num):
      return 'number';
    case const (bool):
      return 'boolean';

    default:
      return T.toString();
  }
}
