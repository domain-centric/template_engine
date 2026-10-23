import 'package:test/test.dart';

import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';

import '../parser/expression/expression_test.dart';

void main() {
  group('AST node rendering', () {
    late RenderContext renderContext;
    setUp(() {
      renderContext = FakeRenderContext(
        variables: {'value': 5, 'active': true},
      );
    });

    test('text node returns literal text', () async {
      var textNode = TextNode('hi');
      var render = await textNode.render(renderContext);
      render.should.be('hi');
    });

    test('ExpressionBlockNode renders a LiteralExpression ', () async {
      final expressionBlock = ExpressionBlockNode(LiteralExpression('ok'));
      var render = await expressionBlock.render(renderContext);
      render.should.be('ok');
    });

    test('ExpressionBlockNode renders a VariableExpression', () async {
      final expressionBlock = ExpressionBlockNode(
        VariableExpression(TemplateLocation.unknown(), 'value'),
      );
      var render = await expressionBlock.render(renderContext);
      render.should.be('5');
    });

    test(
      'ExpressionBlockNode renders an errorPlaceHolder and has an error in the render context when expression throws an TemplateEngineException',
      () async {
        final expressionBlock = ExpressionBlockNode(
          ExpressionThatThrowsAnTemplateEngineException(),
        );
        var render = await expressionBlock.render(renderContext);
        Should.satisfyAllConditions([
          () => render.should.be('{{ERROR}}'),
          () => renderContext.errors.should.haveCount(1),
          () =>
              renderContext.errors.first.message.should.be('RenderErrorDummy'),
          () => renderContext.errors.first.location.should.be(
            TemplateLocation(6, 66),
          ),
        ]);
      },
    );

    test('IfNode renders an errorPlaceHolder when condition throws', () async {
      final ifNode = IfNode(
        ExpressionThatThrowsAnTemplateEngineException(),
        [TextNode('Yes')],
        [TextNode('No')],
      );
      final render = await ifNode.render(renderContext);
      Should.satisfyAllConditions([
        () => render.should.be('{{ERROR}}'),
        () => renderContext.errors.should.haveCount(1),
        () => renderContext.errors.first.message.should.be('RenderErrorDummy'),
      ]);
    });

    test(
      'AssignmentNode renders an errorPlaceHolder when expression throws',
      () async {
        final assignment = AssignmentNode(
          'value',
          ExpressionThatThrowsAnTemplateEngineException(),
        );
        final render = await assignment.render(renderContext);
        Should.satisfyAllConditions([
          () => render.should.be('{{ERROR}}'),
          () => renderContext.errors.should.haveCount(1),
          () =>
              renderContext.errors.first.message.should.be('RenderErrorDummy'),
        ]);
      },
    );

    test(
      'ForNode renders an errorPlaceHolder when an expression throws',
      () async {
        final forNode = ForNode(
          'index',
          ExpressionThatThrowsAnTemplateEngineException(),
          LiteralExpression(2),
          [TextNode('body')],
        );
        final render = await forNode.render(renderContext);
        Should.satisfyAllConditions([
          () => render.should.be('{{ERROR}}'),
          () => renderContext.errors.should.haveCount(1),
          () =>
              renderContext.errors.first.message.should.be('RenderErrorDummy'),
        ]);
      },
    );

    test(
      'ForEachNode renders an errorPlaceHolder when iterable expression throws',
      () async {
        final forEachNode = ForEachNode(
          'item',
          ExpressionThatThrowsAnTemplateEngineException(),
          [TextNode('body')],
        );
        final render = await forEachNode.render(renderContext);
        Should.satisfyAllConditions([
          () => render.should.be('{{ERROR}}'),
          () => renderContext.errors.should.haveCount(1),
          () =>
              renderContext.errors.first.message.should.be('RenderErrorDummy'),
        ]);
      },
    );

    test(
      'WhileNode renders an errorPlaceHolder when condition throws',
      () async {
        final whileNode = WhileNode(
          ExpressionThatThrowsAnTemplateEngineException(),
          [TextNode('body')],
        );
        final render = await whileNode.render(renderContext);
        Should.satisfyAllConditions([
          () => render.should.be('{{ERROR}}'),
          () => renderContext.errors.should.haveCount(1),
          () =>
              renderContext.errors.first.message.should.be('RenderErrorDummy'),
        ]);
      },
    );

    test('if node chooses branches based on condition', () async {
      final ifNode = IfNode(
        VariableExpression(TemplateLocation.unknown(), 'active'),
        [TextNode('Yes')],
        [TextNode('No')],
      );
      var render = await ifNode.render(renderContext);
      render.should.be('Yes');
    });

    test('assignment node stores value and returns empty output', () async {
      final context = FakeRenderContext();
      final assignment = AssignmentNode('x', LiteralExpression(42));
      var render = await assignment.render(context);
      Should.satisfyAllConditions([
        () => render.should.be(''),
        () => (context.variables['x'] as int).should.be(42),
      ]);
    });

    test('comment node render nothing', () async {
      var render = await CommentNode().render(renderContext);
      render.should.be('');
    });

    test('Error nodes render nothing', () async {
      var render = await ErrorNode('broken').render(renderContext);
      render.should.be('');
    });
  });
}

class ExpressionThatThrowsAnTemplateEngineException extends Expression {
  @override
  Future<dynamic> evaluate(RenderContext context) {
    throw RenderError('RenderErrorDummy', TemplateLocation(6, 66));
  }
}
