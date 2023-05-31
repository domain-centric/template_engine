import 'package:petitparser/petitparser.dart';
import 'package:template_engine/src/error.dart';
import 'package:template_engine/src/generic_parser/map2_parser_extension.dart';
import 'package:template_engine/src/variable/variable_renderer.dart';
import 'package:template_engine/template_engine.dart';

Parser<RenderNode> variableParser(ParserContext context) =>
    (string(context.tagStart) &
            whiteSpaceParser().optional() &
            VariableNamePathParser(context) &
            whiteSpaceParser().optional() &
            string(context.tagEnd))
        .map2((values, position) => VariableNode(
            source: ErrorSource(
              template: context.template,
              parserPosition: position,
            ),
            namePath: values[2]));

Parser variableNameParser() => (letter() | digit()).plus().flatten();

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
    if (variables.isEmpty) {
      return string('Never supposed to find this when there are no variables');
    } else {}
    return ChoiceParser<String>(_createNamePathParsers(variables));
  }

  static List<Parser<String>> _createNamePathParsers(
      Map<String, Object> variables,
      [String parentPath = '']) {
    List<Parser<String>> namePathParsers = [];
    for (String name in variables.keys) {
      //TODO validate name
      String namePath = _createNamePath(parentPath, name);
      namePathParsers.add(string(namePath));
      var value = variables[name];
      if (value is Map<String, Object>) {
        // recursive call
        // TODO do we need to add something to prevent endless round trips?
        namePathParsers.addAll(_createNamePathParsers(value, namePath));
      }
    }
    return namePathParsers;
  }

  static String _createNamePath(String parentPath, String name) {
    if (parentPath.isEmpty) {
      return name;
    } else {
      return '$parentPath.$name';
    }
  }
}
