import 'package:collection/collection.dart';
import 'package:template_engine/src/parser/tag/expression/tag_expression_parser.dart';
import 'package:template_engine/src/parser/tag/tag.dart';

class StandardTags extends DelegatingList<Tag> {
  StandardTags() : super([ExpressionTag()]);
}
