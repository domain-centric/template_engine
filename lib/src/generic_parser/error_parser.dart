import 'package:petitparser/petitparser.dart';
import 'package:template_engine/src/error.dart';
import 'package:template_engine/src/generic_parser/map2_parser_extension.dart';
import 'package:template_engine/template_engine.dart';

Parser<RenderNode> unknownTagOrVariableParser(ParserContext context) =>
    (string(context.tagStart) &
            whiteSpaceParser().optional() &
            // any text up unit the Tag end
            any().starLazy(string(context.tagEnd)).flatten() &
            whiteSpaceParser().optional() &
            string(context.tagEnd))
        .map2((values, parserPosition) {
      context.errors.add(Error(
          stage: ErrorStage.parse,
          message: 'Unknown tag or variable.',
          source: ErrorSource(
            template: context.template,
            parserPosition: parserPosition,
          )));
      return TextNode(values.join());
    });
