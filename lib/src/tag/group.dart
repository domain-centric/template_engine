import 'package:collection/collection.dart';
import 'package:template_engine/src/tag/tag.dart';

class TagGroups extends DelegatingList<TagGroup> {
  TagGroups(super.source);

  List<TagDefinition> get tags {
    var tags = <TagDefinition>[];
    for (var tagGroup in this) {
      tags.addAll(tagGroup);
    }
    return tags;
  }
}

/// [TagDefinition]s are grouped in [TagGroup]s
/// This is used during the rendering of documentation:
/// Each [TagGroup] will become a chapter,
/// containing a paragraph for each [TagDefinition]
class TagGroup extends UnmodifiableListView<TagDefinition> {
  final String name;
  final String? description;

  TagGroup(
      {required this.name,
      this.description,
      required List<TagDefinition> tagDefinitions})
      : super(tagDefinitions);
}

class StandardTagGroups extends TagGroups {
  StandardTagGroups() : super([CoreTagGroup()]);
}

class CoreTagGroup extends TagGroup {
  CoreTagGroup() : super(name: 'Core', tagDefinitions: []);
}
