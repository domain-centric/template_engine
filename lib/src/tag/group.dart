import 'dart:collection';

import 'package:template_engine/src/tag/tag_renderer.dart';

class TagGroups extends UnmodifiableListView<TagGroup> {
  TagGroups(super.source);
}

/// [TagDefinition]s are grouped in [TagGroup]s
/// This is used during the rendering of documentation:
/// Each [TagGroup] will become a chapter,
/// containing a paragraph for each [TagDefinition]
class TagGroup extends UnmodifiableListView<TagDefinition> {
  final String name;

  TagGroup(this.name, super.source);
}

class StandardTagGroups extends TagGroups {
  StandardTagGroups() : super([]);
}

class CoreTagGroup extends TagGroup {
  CoreTagGroup() : super('Core', []);
}
