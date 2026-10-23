import 'package:template_engine/template_engine.dart';

/// Represents a unary operator expression, consisting of a single operand
/// and an operator symbol (e.g. `!`, `-`).
///
/// The expression is evaluated by first evaluating the [operand] and then
/// selecting the first [UnaryOperatorSignature] that accepts the operand type.
/// If no signature matches, a [RenderError] is thrown.
///
/// Multiple [signatures] allow operator overloading based on operand type.
class UnaryOperatorExpression extends Expression {
  final TemplateLocation location;
  // a value expression that the operand acts upon
  final Expression operand;
  final UnaryOperatorDefinition definition;

  UnaryOperatorExpression({
    required this.location,
    required this.definition,
    required this.operand,
  });

  @override
  Future<dynamic> evaluate(RenderContext context) async {
    final operandValue = await operand.evaluate(context);
    var invalidTypes = <String>{};
    for (var signature in definition.signatures) {
      var invalidType = signature.inValidType(definition.symbol, operandValue);
      if (invalidType == null) {
        return signature.evaluate(operandValue);
      } else {
        invalidTypes.add(invalidType);
      }
    }
    throw RenderError(
      '${invalidTypes.join(', or ')} '
      'expected after the ${definition.symbol} operator',
      location,
    );
  }
}

class UnaryOperatorDefinition {
  final String symbol;
  final List<UnaryOperatorSignature> signatures;
  late final UnaryOperatorDocumentation documentation =
      UnaryOperatorDocumentation(symbol, signatures);

  UnaryOperatorDefinition({required this.symbol, required this.signatures});
}

/// Describes a single valid type combination ("signature") for a unary operator.
///
/// A signature defines:
/// - The expected type of the operand
/// - The resulting type of the operation
/// - A human-readable [description]
/// - Example usages for documentation purposes
/// - The evaluation [function] that performs the operation
///
/// Multiple signatures can be defined for a single operator to support
/// overloading (e.g. numeric negation vs logical negation).
///
/// Generic type parameters:
/// - [OPERAND_TYPE]: expected type of the operand
/// - [RESULT_TYPE]: type of the result produced by the operator
class UnaryOperatorSignature<OPERAND_TYPE, RESULT_TYPE>
    implements ExampleProvider {
  final operandType = OPERAND_TYPE;

  final resultType = RESULT_TYPE;
  final resultTypeDescription = typeDescription(RESULT_TYPE);
  final String description;
  @override
  final List<Example> examples;
  final RESULT_TYPE Function(OPERAND_TYPE operand) function;

  UnaryOperatorSignature({
    required this.description,
    required this.examples,
    required this.function,
  });

  String? inValidType(String operator, dynamic operand) {
    if (operand is! OPERAND_TYPE) {
      return typeDescription(OPERAND_TYPE);
    }
    return null;
  }

  RESULT_TYPE evaluate(dynamic operand) => function(operand as OPERAND_TYPE);

  String syntaxMarkdown(String operatorSymbol) =>
      'syntax: $operatorSymbol&lt;${typeDescription(OPERAND_TYPE)}&gt;<br>'
      'returns: &lt;${typeDescription(RESULT_TYPE)}&gt;';
}

/// Provides Markdown documentation for a unary operator.
///
/// This class generates a formatted HTML/Markdown representation of an
/// operator, including:
/// - Syntax for each supported signature
/// - Descriptions of each signature
/// - Example usages
///
/// It aggregates documentation from all [signatures], making it suitable
/// for generating reference documentation for template languages or DSLs.
class UnaryOperatorDocumentation implements MarkdownDocumentation {
  final String operatorSymbol;
  final List<UnaryOperatorSignature> signatures;

  UnaryOperatorDocumentation(this.operatorSymbol, this.signatures);

  @override
  String createMarkdownDocumentation(Grammar grammar, int titleLevel) {
    var writer = HtmlTableWriter();
    writer.setTitle(titleLevel, '$operatorSymbol operator');
    for (var signature in signatures) {
      writer.addRow(
        ['<p align="center">${signature.syntaxMarkdown(operatorSymbol)}</p>'],
        [2],
      );
      writer.addRow(['description:', signature.description]);
      for (final example in signature.examples) {
        writer.addRow([
          '${example.typeString}:',
          example.toMarkdown(grammar.codeBlockDelimiter),
        ]);
      }
    }
    return writer.toHtml();
  }

  late final List<Example> examples = signatures
      .expand((s) => s.examples)
      .toList();
}
