import 'package:petitparser/petitparser.dart';
import 'package:template_engine/src/error.dart';
import 'package:template_engine/src/generic_parser/map2_parser_extension.dart';
import 'package:template_engine/src/variable/variable.dart';
import 'package:template_engine/src/variable/variable_renderer.dart';
import 'package:template_engine/template_engine.dart';

Parser<RenderNode>? createVariableParser(ParserContext context) {
  var variables = context.variables;
  if (variables.isEmpty) {
    return null;
  }
  return (string(context.tagStart) &
          whiteSpaceParser().optional() &
          VariableNamePathParser(context) &
          whiteSpaceParser().optional() &
          string(context.tagEnd))
      .map2((values, position) => VariableNode(
          source: TemplateSource(
            template: context.template,
            parserPosition: position,
          ),
          namePath: values[2]));
}

class VariableNamePathParser extends Parser<String> {
  VariableNamePathParser(ParserContext context)
      : _parser = _createParser(context);

  final Parser<String> _parser;

  @override
  Parser<String> copy() => _parser.copy();

  @override
  Result<String> parseOn(Context context) => _parser.parseOn(context);

  static Parser<String> _createParser(ParserContext context) {
    var variables = context.variables;
    return ChoiceParser<String>(_createNamePathParsers(variables));
  }

  static List<Parser<String>> _createNamePathParsers(Variables variables) =>
      variables.namePaths.map((namePath) => string(namePath)).toList();
}
