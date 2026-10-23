import 'package:template_engine/template_engine.dart';

final standardTemplateFunctions = FunctionGroup('Template Functions', [
  templateSourceFunction,
]);

final templateSourceFunction = FunctionDefinition(
  name: "templateSource",
  function: (context) =>
      Future.value(context.renderContext.parseResult.document.template.source),
  documentation: FunctionDefinitionDocumentation(
    description: 'Gives the relative path of the current template',
    examples: [
      ExpressionBlockExample(
        (delimiter) => "${delimiter.start}templateSource()${delimiter.end}",
      ),
      TestFileExample.fromProjectFilePath(
        'test/src/parser/expression/function/template/template_test.dart',
      ),
    ],
  ),
);
