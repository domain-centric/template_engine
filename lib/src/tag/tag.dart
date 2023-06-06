import 'package:petitparser/parser.dart';
import 'package:template_engine/src/error.dart';
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
class TagName {
  static final nameParser = (letter().plus() & digit().star()).plus();
  static final namePathParser =
      (nameParser & (char('.') & nameParser).star()).end();

  validate(String namePath) {
    var result = namePathParser.parse(namePath);
    if (result.isFailure) {
      throw TagException('Tag name: "$namePath" is invalid: ${result.message} '
          'at position: ${result.position}');
    }
  }
}

// typedef TagNodeFactory = TagNode Function(
//   TemplateSource source,
// );

class TagDefinition {
  /// See [TagName]
  final String name;

  /// An general explanation on what the tag does.
  /// Note that the annotations have their on description
  final String description;

  /// A tag may have 0 or more [Attribute]s
  final List<AttributeDefinition> attributeDefinitions;

  final TagRenderer Function(
    TemplateSource source,
  ) tagNodeFactory;

  TagDefinition({
    required this.name,
    required this.description,
    required this.attributeDefinitions,
    required this.tagNodeFactory,
  });

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
///   * a [Tag] that is converted to a [Renderer]
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

class TagException implements Exception {
  final String message;

  TagException(this.message);
}
