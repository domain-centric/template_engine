import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/src/error.dart';
import 'package:template_engine/src/render.dart';
import 'package:template_engine/src/template_engine.dart';

import 'error_test.dart';

void main() {
  // See also other .._parser_test_files

  given('object: A RenderNodeThatRegistersError and a TemplateEngine', () {
    var parseResult = RenderNodeThatRegistersError();
    var engine = TemplateEngine(variables: {});

    when('call: render(parseResult)', () {
      then(
          'expect: a  thrown',
          () => Should.throwException<RenderException>(
              () => {engine.render(parseResult)}));
    });
  });
}

class RenderNodeThatRegistersError extends ParentNode {
  @override
  String render(RenderContext context) {
    context.errors.add(Error(
        stage: ErrorStage.render,
        message: 'Something went wrong.',
        source: DummySource()));
    return "";
  }
}
