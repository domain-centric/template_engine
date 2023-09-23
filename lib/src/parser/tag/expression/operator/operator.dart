import 'package:collection/collection.dart';
import 'package:petitparser/petitparser.dart';
import 'package:template_engine/template_engine.dart';

class PrefixExpression<PARAMETER_TYPE extends Object>
    extends Expression<PARAMETER_TYPE> {
  final PrefixOperator<PARAMETER_TYPE> operator;
  final Expression valueExpression;
  final String position;

  PrefixExpression(
      {required this.operator,
      required this.position,
      required this.valueExpression});

  @override
  PARAMETER_TYPE render(RenderContext context) {
    var value = valueExpression.render(context);
    if (value is PARAMETER_TYPE) {
      return operator.function(value);
    }
    throw RenderException(
        message:
            '${typeDescription<PARAMETER_TYPE>()} expected after the ${operator.operator} operator',
        position: position);
  }

  @override
  String toString() {
    return 'PrefixExpression{${operator.operator}}';
  }
}

class TwoValueOperatorVariant<PARAMETER_TYPE extends Object> {
  final String description;
  final Object Function(PARAMETER_TYPE left, PARAMETER_TYPE right) function;
  final String expressionExample;
  final String? expressionExampleResult;
  final ProjectFilePath? codeExample;

  TwoValueOperatorVariant(
      {required this.description,
      required this.function,
      required this.expressionExample,
      this.expressionExampleResult,
      this.codeExample});

  String get parameterTypeDescription => typeDescription<PARAMETER_TYPE>();

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
}

/// delegates the work to one of the [variants] that can process
/// the correct types of the evaluated [left] and [right] values.
class OperatorVariantExpression extends Expression {
  final String position;
  final List<TwoValueOperatorVariant> variants;
  final String operator;
  final Expression left;
  final Expression right;

  OperatorVariantExpression(
      {required this.position,
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
    throw RenderException(message: errors.join(', or '), position: position);
  }
}

/// A value that needs to be calculated (evaluated)
/// from 2 expressions that return a object of type [T]
class TwoValueOperatorExpression<T extends Object> extends Expression {
  final String position;
  final String operator;
  final Expression left;
  final Expression right;
  final T Function(T left, T right) function;

  TwoValueOperatorExpression(
      {required this.position,
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
      throw RenderException(
          message: 'left and right of the $operator operator '
              'must be a ${typeDescription<T>()}',
          position: position);
    } else if (!leftTypeOk) {
      throw RenderException(
          message: 'left of the $operator operator '
              'must be a ${typeDescription<T>()}',
          position: position);
    } else {
      throw RenderException(
          message: 'right of the $operator operator '
              'must be a ${typeDescription<T>()}',
          position: position);
    }
  }

  @override
  String toString() => 'TwoValueOperatorExpression{$operator}';
}

/// An [Operator] behaves generally like functions,
/// but differs syntactically or semantically.
///
/// Common simple examples include arithmetic (e.g. addition with +) and
/// logical operations (e.g. logical AND with &).
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
  addParser(Template template, ExpressionGroup2<Expression> group);
}

class PrefixOperator<PARAMETER_TYPE extends Object> extends Operator {
  final String operator;
  final String description;
  final PARAMETER_TYPE Function(PARAMETER_TYPE value) function;
  final String expressionExample;
  final String? expressionExampleResult;
  final ProjectFilePath? codeExample;

  PrefixOperator({
    required this.operator,
    required this.description,
    required this.function,
    required this.expressionExample,
    this.expressionExampleResult,
    this.codeExample,
  });

  String get parameterTypeDescription => typeDescription<PARAMETER_TYPE>();

  @override
  List<String> createMarkdownDocumentation(
      RenderContext renderContext, int titleLevel) {
    var writer = HtmlTableWriter();
    writer.addHeaderRow(['operator: $operator'], [2]);
    writer.addHeaderRow(['parameter type: $parameterTypeDescription'], [2]);
    writer.addRow(['description:', description]);
    writer.addRow([
      'expression example:',
      expressionExampleResult == null
          ? expressionExample
          : '$expressionExample '
              'should render: $expressionExampleResult'
    ]);
    if (codeExample != null) {
      writer.addRow(['code example:', codeExample!.githubMarkdownLink]);
    }
    return writer.toHtmlLines();
  }

  @override
  List<String> createMarkdownExamples(
          RenderContext renderContext, int titleLevel) =>
      codeExample == null ? [] : ['* ${codeExample!.githubMarkdownLink}'];

  @override
  String toString() => 'Operator{$operator}';

  @override
  addParser(Template template, ExpressionGroup2<Expression<Object>> group) {
    group.prefix(
        char(operator).trim(),
        (context, op, value) => PrefixExpression<PARAMETER_TYPE>(
            operator: this,
            position: context.toPositionString(),
            valueExpression: value));
  }
}

abstract class OperatorWith2Values extends Operator {
  final String operator;
  final OperatorAssociativity associativity;
  final List<TwoValueOperatorVariant> variants;

  OperatorWith2Values(
    this.operator,
    this.associativity,
    this.variants,
  );

  @override
  List<String> createMarkdownDocumentation(
      RenderContext renderContext, int titleLevel) {
    var writer = HtmlTableWriter();
    writer.addHeaderRow(['operator: $operator'], [2]);
    for (var variant in variants) {
      writer.addHeaderRow(
          ['parameter type: ${variant.parameterTypeDescription}'], [2]);
      writer.addRow(['description:', variant.description]);
      writer.addRow([
        'expression example:',
        variant.expressionExampleResult == null
            ? variant.expressionExample
            : '${variant.expressionExample} '
                'should render: ${variant.expressionExampleResult}'
      ]);
      if (variant.codeExample != null) {
        writer
            .addRow(['code example:', variant.codeExample!.githubMarkdownLink]);
      }
    }
    return writer.toHtmlLines();
  }

  @override
  List<String> createMarkdownExamples(
          RenderContext renderContext, int titleLevel) =>
      variants
          .where((variant) => variant.codeExample != null)
          .map((variant) => '* ${variant.codeExample!.githubMarkdownLink}')
          .toList();

  @override
  String toString() => 'Operator{$operator}';

  @override
  addParser(Template template, ExpressionGroup2<Expression<Object>> group) {
    if (associativity == OperatorAssociativity.right) {
      group.right(
          char(operator).trim(),
          (context, left, op, right) => OperatorVariantExpression(
                position: context.toPositionString(),
                operator: operator,
                variants: variants,
                left: left,
                right: right,
              ));
    } else {
      group.left(
          char(operator).trim(),
          (context, left, op, right) => OperatorVariantExpression(
                position: context.toPositionString(),
                operator: operator,
                variants: variants,
                left: left,
                right: right,
              ));
    }
  }
}

///  the associativity of an operator is a property that determines how
/// operators of the same precedence are grouped in the absence of parentheses.
/// If an operand is both preceded and followed by operators, and those
///  operators have equal precedence, then the operand may be used as input
/// to two different operations (i.e. the two operations indicated by the
/// two operators). The choice of which operations to apply the operand to,
/// is determined by the associativity of the operators.
///
/// Operators may be associative (meaning the operations can be grouped
/// arbitrarily):
/// * left-associative (meaning the operations are grouped from the left)
/// * right-associative (meaning the operations are grouped from the right)
/// * non-associative (meaning operations cannot be chained,
///   often because the output type is incompatible with the input types).
///
/// The associativity and precedence of an operator is a part of the
/// definition of the programming language; different programming languages
/// may have different associativity and precedence for the same type of
/// operator.
///
/// See https://en.wikipedia.org/wiki/Operator_associativity
///
enum OperatorAssociativity {
  /// left-associative (meaning the operations are grouped from the left)
  /// This is used for the majority of operators
  left,

  /// right-associative (meaning the operations are grouped from the right)
  /// This is used for the the power operator, e.g.: 2 ^ 3
  right,
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
