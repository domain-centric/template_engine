import 'package:template_engine/template_engine.dart';

/// TODO
abstract class Variable {
  /// for documentation only
}

class VariableNode extends RenderNode {
  
  final List<String> namePath;
  final TemplateSection templateSection;

  VariableNode({
    required this.templateSection,
    /// The name path of an [Variable].
    /// This corresponds with the keys in the [Variable] map.
    /// Separate the names with a dot for nested [Variable]s.
    /// E.g.:
    /// {'person': {'name': 'John Doe', 'age',30}}
    /// person.name refers to the [Variable] value of 'John Doe'
    required String namePath,
  }) : namePath=namePath.split('.');

  @override
  String render(RenderContext context) {
    var value = findVariableValue(context.variables, namePath);
    return value.toString();
  }
  
  Object? findVariableValue(Map<String, Object> variables, List<String> namePath) {
    if (variables.containsKey(namePath.first)) {
      if (namePath.length==1) {
        return variables[namePath.first];
      } else {
        return findVariableValue(variables, namePath.sublist(1));
      }
    } else {
      throw ArgumentError('The variable name path could not be found');
    }

  }
}
