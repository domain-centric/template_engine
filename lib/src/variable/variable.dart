import 'package:template_engine/template_engine.dart';

/// TODO explain what it is (google)
/// TODO add types (see TemplateEngine constuctor parameter variables)
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
    try {
  var value = findVariableValue(context.variables, namePath);
  return value.toString();
} on ArgumentError catch (e) {
  context.logger.warning(ParserWarning(templateSection, e.message));
  return '';
}
   
  }
  
  Object? findVariableValue(Map<String, Object> variables, List<String> namePath, [namePathIndex=0]) {
    if (variables.containsKey(namePath[namePathIndex])) {
      if (namePath.length==namePathIndex+1) {
        return variables[namePath.first];
      } else {
        // recursive call
        return findVariableValue(variables, namePath, namePathIndex+1);
      }
    } else {
      throw ArgumentError('Variable name path could not be found: ${namePath.sublist(0,namePathIndex+1).join('.')}');
    }

  }
}
