import 'package:template_engine/src/render.dart';
import 'package:template_engine/src/template.dart';
import 'package:template_engine/src/template_engine.dart';
import 'package:template_engine/src/variable/variable.dart';

class Parser {
  ParentNode parse(Template template, ParserContext parserContext) {
    return _createExampleResult(template);
  }

  //TODO replace this method with something that actually parses the template
  ParentNode _createExampleResult(Template template) {
    var root = ParentNode();
    root.children.add(TextNode('Hello '));
    root.children.add(VariableNode(
      templateSection: TemplateSection(
          template: template, row: 1, column: 4, text: '{{name}}'),
      namePath: 'name',
    )); 
    root.children.add(TextNode('.'));
    return root;
  }
}
