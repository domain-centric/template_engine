import 'package:template_engine/src/generic_parser/parser.dart';
import 'package:template_engine/src/render.dart';
import 'package:template_engine/src/tag/group.dart';
import 'package:template_engine/src/tag/tag_renderer.dart';
import 'package:template_engine/src/template.dart';

/// The [TemplateEngine] does the following:
/// * Parse the [Template] text into a
///   [parser tree](https://en.wikipedia.org/wiki/Parse_tree), see [RenderNode]
/// * Render the [parser tree](https://en.wikipedia.org/wiki/Parse_tree)
///   to a output such as:
///   * [Html](https://en.wikipedia.org/wiki/HTML)
///   * [Programming code](https://en.wikipedia.org/wiki/Programming_language)
///   * [Markdown](https://en.wikipedia.org/wiki/Markdown)
///   * [Xml](https://en.wikipedia.org/wiki/XML),
///     [Json](https://en.wikipedia.org/wiki/JSON),
///     [Yaml](https://en.wikipedia.org/wiki/YAML)
///   * Etc...
///
/// ```dart
/// TODO add link to an example file
/// main () {
///  var template=TextTemplate('Hello {{name}}.');
///  // See also FileTemplate and WebTemplate
///  var engine=TemplateEngine(variables={'name':'world'});
///  var model=engine.parse(template);
///  // Here you could manipulate the model
///  // or do additional model validations if needed.
///  assert(engine.render(model),'Hello world.')
/// }
/// ```
///
/// TODO add link to examples on pub.dev
class TemplateEngine {
  /// The [TagDefinition]s to be used for parsing.
  /// If null it will use [StandardTagGroups]
  final TagGroups tagGroups;

  /// The variables to be used for parsing.
  /// Note that all variables that are used need to be declared here so that
  /// the parser can recognize them.
  /// [Variable]s can get a different value during rendering.
  final Map<String, Object> variables;

  /// The tag starts with given prefix.
  /// Use a prefix combination that is not used elsewhere in your templates.
  /// e.g.: Do not use < as a prefix if your template contains HTML or XML
  /// By default the prefix is: {{
  /// Examples of other prefixes and suffixes:
  /// * HTML and XML uses < >
  /// * JSON uses { }
  /// * PHP uses <? ?>
  /// * JSP and ASP uses <% %>
  final String tagStart;

  /// The tag ends with given suffix.
  /// Use a suffix combination that is not used elsewhere in your templates.
  /// e.g.: Do not use > as a suffix if your template contains HTML or XML
  /// By default the prefix is: }}
  /// Examples of other prefixes and suffixes:
  /// * HTML and XML uses < >
  /// * JSON uses { }
  /// * PHP uses <? ?>
  /// * JSP and ASP uses <% %>
  String tagEnd = '}}';

  TemplateEngine({
    TagGroups? tagGroups,
    this.variables = const {},
    this.tagStart = '{{',
    this.tagEnd = '}}',
  }) : tagGroups = tagGroups ?? StandardTagGroups();

  /// Parse the [Template] text into a
  /// [parser tree](https://en.wikipedia.org/wiki/Parse_tree).
  /// See [RenderNode]
  ParentNode parse(Template template) {
    var context = ParserContext(
        tagGroups: tagGroups,
        variables: variables,
        tagStart: tagStart,
        tagEnd: tagEnd,
        template: template);
    var parser = templateParser(context);
    var result = parser.parse(template.text);

    // if (result.isFailure) {
    //   context.events.add(Event.parseError(
    //       result.message,
    //       TemplateSection(
    //         template: template,
    //         parserPosition: result.toPositionString(),
    //       )));
    // }
    if (context.errors.isEmpty) {
      return ParentNode(result.value);
    } else {
      throw ParseException(context.errors);
    }
  }

  /// Render the [parser tree](https://en.wikipedia.org/wiki/Parse_tree)
  /// to a string (and write it as files when needed)
  String render(ParentNode model) {
    var context = RenderContext(variables);
    var result = model.render(context);
    if (context.errors.isEmpty) {
      return result;
    } else {
      throw RenderException(context.errors);
    }
  }
}
