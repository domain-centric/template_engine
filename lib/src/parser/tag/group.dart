import 'package:collection/collection.dart';
import 'package:template_engine/src/parser/tag/expression/tag_expression_parser.dart';
import 'package:template_engine/src/parser/tag/tag.dart';
import 'package:template_engine/src/template_engine.dart';

class StandardTags extends DelegatingList<Tag> {
  StandardTags(TemplateEngine templateEngine) : super([ExpressionTag()]);
}
