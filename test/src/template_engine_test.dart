import 'package:shouldly/shouldly.dart';
import 'package:given_when_then_unit_test/given_when_then_unit_test.dart';
import 'package:template_engine/src/error.dart';
import 'package:template_engine/src/render.dart';
import 'package:template_engine/src/template_engine.dart';

import 'error_test.dart';

void main() {
  // See also other .._parser_test_files

  given('object: A RendererThatRegistersError and a TemplateEngine', () {
    var parseResult = ParserTreeThatRegistersError();
    var engine = TemplateEngine();

    when('call: render(parseResult)', () {
      var result = engine.render(parseResult);
      then('expect: 1 error', () {
        return result.errors.length.should.be(1);
      });

      var expected = 'Render Error: Something went wrong. '
          'position: 1:4 source: Text';

      then('expect: an errorMessage: "$expected"', () {
        return result.errorMessage.should.be(expected);
      });
    });
  });
}

class ParserTreeThatRegistersError extends ParserTree {
  @override
  String render(RenderContext context) {
    context.errors.add(Error(
        stage: ErrorStage.render,
        message: 'Something went wrong.',
        source: DummySource()));
    return "";
  }
}
