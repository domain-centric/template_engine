import 'dart:collection';

import 'package:logging/logging.dart';
import 'package:template_engine/src/parser/parser.dart';
import 'package:template_engine/src/render.dart';
import 'package:template_engine/src/tag/group.dart';
import 'package:template_engine/src/tag/tag.dart';
import 'package:template_engine/src/template.dart';

/// The [TemplateEngine] does the following:
/// * get the [Template]
/// * parse the [Template] text into a
///   [parser tree](https://en.wikipedia.org/wiki/Parse_tree), see [RenderNode]
/// * render the [parser tree](https://en.wikipedia.org/wiki/Parse_tree)
///   to a string (and write it as files when needed)
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
    final String tagStart ;

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
  final Logger logger;
  static final defaultLogger = Logger('TemplateEngine');
/// Read only variables, to be cloned to a mutable [Map] when rendered.
  

  
  TemplateEngine({
    TagGroups? tagGroups,
this.variables = const {},
    this.tagStart = '{{',
    this.tagEnd = '}}',
    Logger? logger,
  })  :
        tagGroups=tagGroups??StandardTagGroups(),
        logger = logger ?? defaultLogger {
    _initLogger();
  }

  void _initLogger() {
    Logger.root.level = Level.ALL; // defaults to Level.INFO
    Logger.root.onRecord.listen((record) {
      // ignore: avoid_print
      print('${record.level.name}: ${record.time}: ${record.message}');
    });
  }

  /// Parse the [Template] text into a
  /// [parser tree](https://en.wikipedia.org/wiki/Parse_tree).
  /// See [RenderNode]
  ParentNode parse(
    Template template
  ) {
     var parserContext = ParserContext(
          tagGroups: tagGroups,
          variables: variables,
          tagStart: tagStart,
          tagEnd: tagEnd,
          logger: logger ,
          template: template
        );
    var parser = templateParser(parserContext);
    var result = parser.parse(template.text);
    /// todo if logger has errors, throw them
    if (result.isFailure) {
      throw ParseException(result.message);
    } else {
      return ParentNode(result.value);
    }
  }

  /// Render the [parser tree](https://en.wikipedia.org/wiki/Parse_tree)
  /// to a string (and write it as files when needed)
  String render(ParentNode model) {
    var context = RenderContext(
      variables: variables,
      logger: logger,
    );
    return model.render(context);
  }
}

