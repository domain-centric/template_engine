// TODO

// import 'package:template_engine/template_engine.dart';

// class TagDocumentation extends TagFunction<String> {
//   TagDocumentation()
//       : super(
//             name: "tag.documentation",
//             description:
//                 "Creates Markdown documentation for all the configured Tags.");

//   @override
//   String createParserResult(
//       {required ParserContext context,
//       required TemplateSource source,
//       required Map<String, Object> attributes}) {
//     var markdown = StringBuffer();
//     for (var tag in context.tags) {
//       markdown.write('# ${tag.name}\n');
//       markdown.write(tag.documentation(context));
//       markdown.write('\n\n');
//     }
//     return markdown.toString();
//   }
// }
