import 'package:petitparser/parser.dart';
import 'package:template_engine/src/error.dart';
import 'package:template_engine/src/generic_parser/map2_parser_extension.dart';
import 'package:template_engine/src/tag/tag.dart';
import 'package:template_engine/template_engine.dart';

Parser<TagRenderer>? createTagParser(ParserContext context) {
  var tags = context.tagGroups.tags;
  if (tags.isEmpty) {
    return null;
  }
  return ChoiceParser<TagRenderer>(tags
      .map<Parser<TagRenderer>>(
          (tagDefinition) => tagDefinitionParser(context, tagDefinition))
      .toList());
}

Parser<TagRenderer> tagDefinitionParser(
        ParserContext context, TagDefinition tagDefinition) =>
    (string(context.tagStart) &
            whiteSpaceParser().optional() &
            string(tagDefinition.name) &
            whiteSpaceParser().optional() &
            string(context.tagEnd))
        .map2((values, position) => tagDefinition.tagNodeFactory(TemplateSource(
              template: context.template,
              parserPosition: position,
            ))); //TODO add attributes from values[?]