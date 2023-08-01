import 'package:collection/collection.dart';
import 'package:template_engine/template_engine.dart';

class NegativeNumberExpression extends Expression {
  final Source source;
  final Expression valueExpression;

  NegativeNumberExpression(this.source, this.valueExpression);

  @override
  Object render(RenderContext context) {
    var value = valueExpression.render(context);
    if (value is num) {
      return -value;
    }
    context.errors.add(Error.fromSource(
        stage: ErrorStage.render,
        source: source,
        message: 'A number expected after the - operator'));
    return '-';
  }

  @override
  String toString() {
    return 'NegativeNumberExpression{$valueExpression}';
  }
}

class NotExpression extends Expression {
  final Source source;
  final Expression valueExpression;

  NotExpression(this.source, this.valueExpression);

  @override
  Object render(RenderContext context) {
    var value = valueExpression.render(context);
    if (value is bool) {
      return !value;
    }
    context.errors.add(Error.fromSource(
        stage: ErrorStage.render,
        source: source,
        message: 'A boolean expected after the ! operator'));
    return '!';
  }
}

class TwoValueOperatorVariant<PARAMETER_TYPE extends Object> {
  final String description;
  final Object Function(PARAMETER_TYPE left, PARAMETER_TYPE right) function;

  List<String> validate(String operator, Object leftValue, Object rightValue) {
    var typeDesc = typeDescription<PARAMETER_TYPE>();
    bool leftTypeOk = leftValue is PARAMETER_TYPE;
    bool rightTypeOk = rightValue is PARAMETER_TYPE;
    if (leftTypeOk && rightTypeOk) {
      return [];
    } else if (!leftTypeOk && !rightTypeOk) {
      return ['left and right of the $operator operator must be a $typeDesc'];
    }
    if (!leftTypeOk) {
      return ['left of the $operator operator must be a $typeDesc'];
    }
    return ['right of the $operator operator must be a $typeDesc'];
  }

  Object eval(Object leftValue, Object rightValue) =>
      function(leftValue as PARAMETER_TYPE, rightValue as PARAMETER_TYPE);

  TwoValueOperatorVariant(this.description, this.function);
}

/// delegates the work to one of the [variants] that can process
/// the correct types of the evaluated [left] and [right] values.
class OperatorVariantExpression extends Expression {
  final Source source;
  final List<TwoValueOperatorVariant> variants;
  final String operator;
  final Expression left;
  final Expression right;

  OperatorVariantExpression(
      {required this.source,
      required this.operator,
      required this.variants,
      required this.left,
      required this.right});

  @override
  Object render(RenderContext context) {
    var leftValue = left.render(context);
    var rightValue = right.render(context);

    var errors = <String>[];
    for (var operatorVariant in variants) {
      var variantErrors =
          operatorVariant.validate(operator, leftValue, rightValue);
      if (variantErrors.isEmpty) {
        return operatorVariant.eval(leftValue, rightValue);
      } else {
        errors.addAll(variantErrors);
      }
    }
    context.errors.add(Error.fromSource(
        stage: ErrorStage.render,
        source: source,
        message: errors.join(', or ')));
    return operator;
  }
}

/// A value that needs to be calculated (evaluated)
/// from 2 expressions that return a object of type [T]
class TwoValueOperatorExpression<T extends Object> extends Expression {
  final Source source;
  final String operator;
  final Expression left;
  final Expression right;
  final T Function(T left, T right) function;

  TwoValueOperatorExpression(
      {required this.source,
      required this.operator,
      required this.left,
      required this.right,
      required this.function});

  @override
  Object render(RenderContext context) {
    var leftValue = left.render(context);
    bool leftTypeOk = leftValue is T;
    var rightValue = right.render(context);
    bool rightTypeOk = rightValue is T;
    if (leftTypeOk && rightTypeOk) {
      return function(leftValue, rightValue);
    }

    if (!leftTypeOk && !rightTypeOk) {
      context.errors.add(Error.fromSource(
          stage: ErrorStage.render,
          source: source,
          message:
              'left and right of the $operator operator must be a ${typeDescription<T>()}'));
      return operator;
    } else if (!leftTypeOk) {
      context.errors.add(Error.fromSource(
          stage: ErrorStage.render,
          source: source,
          message:
              'left of the $operator operator must be a ${typeDescription<T>()}'));
      return operator;
    } else {
      context.errors.add(Error.fromSource(
          stage: ErrorStage.render,
          source: source,
          message:
              'right of the $operator operator must be a ${typeDescription<T>()}'));
      return operator;
    }
  }

  @override
  String toString() => 'TwoValueOperatorExpression{$operator}';
}

/// An [Operator] behaves generally like functions,
/// but differs syntactically or semantically.
///
/// Common simple examples include arithmetic (e.g. addition with +) and
///  logical operations (e.g. &).
///
/// An [Operator] can be used anywhere in an tag expression
/// wherever that particular [Operator] should be performed.
///
/// The [TemplateEngine] supports several standard [Operator]s.
///
/// ## Custom Operators
/// You can adopt existing [Operator]s or add your own custom [Operator]s by
/// manipulating the [TemplateEngine.operatorGroups] field.
/// See [custom_operator_test.dart](https://github.com/domain-centric/template_engine/blob/main/test/src/parser/tag/expression/operator/custom_operator_test.dart).
///
abstract class Operator implements DocumentationFactory, ExampleFactory {
  final String operator;

  /// a description and an example for each type.
  /// e.g. example [descriptions] for an + operator:
  /// * Adds two numbers, e.g.: 2+3=5
  /// * Concatenates two strings, e.g.: 'Hel'+'lo'="Hello"
  final List<String> descriptions;

  Operator(
    this.operator,
    this.descriptions,
  );

  addParser(Template template, ExpressionGroup2<Expression> group);

  @override
  List<String> createMarkdownDocumentation(
      RenderContext renderContext, int titleLevel) {
    var writer = HtmlTableWriter();
    writer.addHeaderRow([operator], [2]);
    if (descriptions.isNotEmpty) {
      writer.addRow(['description:', descriptions.join('<br>')]);
    }
    // TODO if (exampleCode != null) {
    //   writer.addRow(['code example:', exampleCode!.githubMarkdownLink], [1, 4]);
    // }
    return writer.toHtmlLines();
  }

  @override
  List<String> createMarkdownExamples(
          RenderContext renderContext, int titleLevel) =>
      [];
  // TODO exampleCode == null ? [] : ['* ${exampleCode!.githubMarkdownLink}'];

  @override
  String toString() => 'Operator{$operator}';
}

abstract class OperatorWith2Values extends Operator {
  final List<TwoValueOperatorVariant> variants;

  OperatorWith2Values(
    String operator,
    this.variants,
  ) : super(operator, variants.map((v) => v.description).toList());

  Expression createExpression(
          Source source, Expression left, Expression right) =>
      OperatorVariantExpression(
        source: source,
        operator: operator,
        variants: variants,
        left: left,
        right: right,
      );
  @override
  String toString() => 'Operator{$operator}';
}

class OperatorGroup extends DelegatingList<Operator>
    implements DocumentationFactory, ExampleFactory {
  final String name;
  OperatorGroup(this.name, super.base);

  @override
  List<String> createMarkdownDocumentation(
          RenderContext renderContext, int titleLevel) =>
      [
        '${"#" * titleLevel} $name',
        ...map((operator) => operator.createMarkdownDocumentation(
            renderContext, titleLevel + 1)).flattened
      ];

  @override
  List<String> createMarkdownExamples(
      RenderContext renderContext, int titleLevel) {
    var examples = map((function) =>
            function.createMarkdownExamples(renderContext, titleLevel + 1))
        .flattened;
    if (examples.isEmpty) {
      return [];
    } else {
      return [
        '${"#" * titleLevel} $name',
        ...examples,
      ];
    }
  }
}
