import 'package:template_engine/template_engine.dart';

/// [Tag]s are specific texts in [Template]s that are replaced by the
/// [TemplateEngine] with other information.
///
/// [Tag]s:
/// * Are surrounded with symbols like {{  }}
/// * Start with [TagName]
/// * Can be followed by [Attribute]s
abstract class Tag {
  /// For documentation only
}

/// A [TagName]:
/// * may not be empty
/// * is case un-sensitive
/// * may contain letters, numbers and dots. e.g.: 'project.path'
/// * must be unique
abstract class TagName {
  /// For documentation only
}

abstract class TagDefinition {
  /// See [TagName]
  final String name;

  /// An general explanation on what the tag does.
  /// Note that the annotations have their on description
  final String description;

  /// A tag may have 0 or more [Attribute]s
  final List<AttributeDefinition> attributeDefinitions;

  TagDefinition({
    required this.name,
    required this.description,
    required this.attributeDefinitions,
  });

  TagNode tagNodeFactory();

  @override
  String toString() {
    return 'TagDefinition{'
        'name=$name, '
        'description=$description, '
        'attributeDefinitions=$attributeDefinitions}';
  }
}

/// A [Tag] can have 0 or more attributes.
/// An [Attribute]:
/// * Has a name
/// * Has a value of one of the following types:
///   * bool
///   * String
///   * int
///   * double
///   * date
///   * list where the elements are one of the types above
///   * map where the keys are a string and the values are one of the types above
///   * a [Tag] that is converted to a [RenderNode]
///  * Can be optional
///  * Can have an default value when the attribute is optional
abstract class Attribute {
  /// for documentation only
}

class AttributeDefinition {
  /// The name of the [Attribute]. The name:
  /// * may not be empty
  /// * is case un-sensitive
  /// * may contain letters and numbers: 'title'
  final String name;

  /// A function to validate the value of an [Attribute]
  /// It returns an empty list when ok.
  /// It returns a list or error messages when not ok.
  final List<String> Function(Object value) validateValue;

  /// optional=true: the attribute is mandatory
  /// optional=false: the attribute may be omitted
  final bool optional;

  AttributeDefinition({
    required this.name,
    required this.validateValue,
    required this.optional,
  });
}

/// A [RenderNode] that is a placeholder for a [Tag]
abstract class TagNode extends ParentNode {}
