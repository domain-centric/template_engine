import 'package:collection/collection.dart';
import 'package:template_engine/src/parser/tag/tag.dart';
import 'package:template_engine/src/parser/tag/tag_variable.dart';

class StandardTags extends DelegatingList<Tag> {
  StandardTags() : super([TagVariable()]);
}
