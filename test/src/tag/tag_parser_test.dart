import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:shouldly/shouldly.dart';
import 'package:template_engine/src/error.dart';
import 'package:template_engine/src/render.dart';
import 'package:template_engine/src/tag/group.dart';
import 'package:template_engine/src/tag/tag.dart';
import 'package:template_engine/src/tag/tag_renderer.dart';
import 'package:template_engine/src/template.dart';
import 'package:template_engine/src/template_engine.dart';

void main() {
  given('a custom TagDefinition', () {
    var tagDefinition = TagDefinition(
        name: 'greeting',
        description: 'A custom tag that generates a greeting.',
        attributeDefinitions: [],
        tagNodeFactory: (TemplateSource source) => GreetingRenderer(source));
    var tagGroup =
        TagGroup(name: 'Greeting tags', tagDefinitions: [tagDefinition]);
    var tagGroups = TagGroups([tagGroup]);
    var engine = TemplateEngine(tagGroups: tagGroups);
    var template = TextTemplate('{{greeting}}');

    when('calling engine.parse()', () {
      var result = engine.parse(template);
      then('return 1 child"', () {
        result.children.length.should.be(1);
      });
      then('return 1 child of type GreetingRenderer"', () {
        result.children.first.should.beOfType<GreetingRenderer>();
      });
    });
  });
}

class GreetingRenderer extends TagRenderer {
  GreetingRenderer(super.source);

  static String greeting = 'Hello world.';
  @override
  String render(RenderContext context) => greeting;
}
