import 'dart:async';

import 'package:template_engine/template_engine.dart';

abstract class AstNode {
  /// Renders this node using the supplied context.
  Future<String> render(RenderContext context);
}

/// A node containing literal template text.
class TextNode extends AstNode {
  /// The text represented by this node.
  final String text;

  /// Whether to include [text] in rendered output.
  final bool renderText;

  /// Creates a text node, optionally suppressing its output.
  TextNode(this.text, {this.renderText = true});

  @override
  /// Returns the text when [renderText] is true, or an empty string.
  Future<String> render(RenderContext context) =>
      Future.value(renderText ? text : '');
}

/// A node that evaluates and renders an expression.
class ExpressionBlockNode extends AstNode {
  /// The expression to evaluate.
  final Expression expression;

  /// Creates a node for the given expression.
  ExpressionBlockNode(this.expression);

  @override
  /// Converts the evaluated value to text and records evaluation errors.
  Future<String> render(RenderContext context) async {
    try {
      final value = await expression.evaluate(context);
      return value == null ? '' : value.toString();
    } catch (e) {
      context.errors.addAll(templateEngineExceptionsFromException(e));
      return context.errorPlaceholder;
    }
  }
}

/// Converts a thrown value into the template-engine errors it contains.
///
/// Existing [TemplateEngineException]s and nested iterables of such errors
/// are returned; unrelated values produce an empty iterable.
Iterable<TemplateEngineException> templateEngineExceptionsFromException(
  dynamic exception,
) {
  if (exception is TemplateEngineException) {
    return [exception];
  } else if (exception is Iterable) {
    return exception.expand(templateEngineExceptionsFromException);
  } else {
    return [];
  }
}

/// A conditional node with separate branches for true and false conditions.
class IfNode extends AstNode {
  /// The expression that selects a branch.
  final Expression condition;

  /// Nodes rendered when [condition] is truthy.
  final List<AstNode> thenNodes;

  /// Nodes rendered when [condition] is not truthy.
  final List<AstNode> elseNodes;

  /// Creates a conditional node with its condition and branches.
  IfNode(this.condition, this.thenNodes, this.elseNodes);

  @override
  /// Renders the branch selected by the evaluated condition.
  Future<String> render(RenderContext context) async {
    try {
      final result = await condition.evaluate(context);
      if (isTruthy(result)) {
        return await astNodesToString(thenNodes, context);
      }
      return await astNodesToString(elseNodes, context);
    } catch (e) {
      context.errors.addAll(templateEngineExceptionsFromException(e));
      return context.errorPlaceholder;
    }
  }
}

/// Renders [nodes] in order and concatenates their output.
Future<String> astNodesToString(
  List<AstNode> nodes,
  RenderContext context,
) async {
  final buffer = StringBuffer();
  for (final node in nodes) {
    buffer.write(await node.render(context));
  }
  return buffer.toString();
}

class AssignmentNode extends AstNode {
  /// The variable name or dotted path to assign.
  final String variableNamePath;

  /// The expression whose value is assigned.
  final Expression expression;

  /// Creates an assignment to [variableNamePath].
  AssignmentNode(this.variableNamePath, this.expression);

  @override
  /// Assigns the evaluated value and emits no text on success.
  Future<String> render(RenderContext context) async {
    try {
      final value = await expression.evaluate(context);
      final parts = variableNamePath.split('.');
      if (parts.isEmpty) return '';
      var current = context.variables;
      for (var i = 0; i < parts.length - 1; i++) {
        final namePart = parts[i];
        final child = current[namePart];
        if (child is Map<String, dynamic>) {
          current = child;
        } else {
          final next = <String, dynamic>{};
          current[namePart] = next;
          current = next;
        }
      }
      current[parts.last] = value;
      return '';
    } catch (e) {
      context.errors.addAll(templateEngineExceptionsFromException(e));
      return context.errorPlaceholder;
    }
  }
}

/// A template comment that produces no rendered output.
class CommentNode extends AstNode {
  /// Creates an empty comment node.
  CommentNode();

  @override
  /// Returns an empty string.
  Future<String> render(RenderContext context) => Future.value('');
}

/// A node that renders its body for each integer in an inclusive range.
class ForNode extends AstNode {
  /// The variable set to the current integer for each iteration.
  final String variableName;

  /// The expression that produces the first integer in the range.
  final Expression startExpression;

  /// The expression that produces the last integer in the range.
  final Expression endExpression;

  /// The nodes rendered on each iteration.
  final List<AstNode> bodyNodes;

  /// Creates a range loop over [startExpression] through [endExpression].
  ForNode(
    this.variableName,
    this.startExpression,
    this.endExpression,
    this.bodyNodes,
  );

  @override
  /// Renders each iteration and restores the variable's previous value.
  Future<String> render(RenderContext context) async {
    try {
      final startVal = await startExpression.evaluate(context);
      final endVal = await endExpression.evaluate(context);
      if (startVal == null || endVal == null) return '';
      final start = (startVal is num)
          ? startVal.toInt()
          : int.tryParse(startVal.toString()) ?? 0;
      final end = (endVal is num)
          ? endVal.toInt()
          : int.tryParse(endVal.toString()) ?? 0;

      final previousExists = context.variables.containsKey(variableName);
      final previousValue = context.variables[variableName];

      final buffer = StringBuffer();
      if (start <= end) {
        for (var i = start; i <= end; i++) {
          context.variables[variableName] = i;
          buffer.write(await astNodesToString(bodyNodes, context));
        }
      } else {
        for (var i = start; i >= end; i--) {
          context.variables[variableName] = i;
          buffer.write(await astNodesToString(bodyNodes, context));
        }
      }

      if (previousExists) {
        context.variables[variableName] = previousValue;
      } else {
        context.variables.remove(variableName);
      }

      return buffer.toString();
    } catch (e) {
      context.errors.addAll(templateEngineExceptionsFromException(e));
      return context.errorPlaceholder;
    }
  }
}

/// A node that renders its body for each item in an iterable or map.
class ForEachNode extends AstNode {
  /// The variable set to the current item for each iteration.
  final String variableName;

  /// The expression that produces the iterable or map.
  final Expression iterableExpression;

  /// The nodes rendered on each iteration.
  final List<AstNode> bodyNodes;

  /// Creates an iteration loop over [iterableExpression].
  ForEachNode(this.variableName, this.iterableExpression, this.bodyNodes);

  @override
  /// Renders each item and restores the variable's previous value.
  Future<String> render(RenderContext context) async {
    try {
      final iterableValue = await iterableExpression.evaluate(context);
      if (iterableValue == null) return '';

      final previousExists = context.variables.containsKey(variableName);
      final previousValue = context.variables[variableName];

      final buffer = StringBuffer();
      if (iterableValue is Iterable) {
        for (final item in iterableValue) {
          context.variables[variableName] = item;
          buffer.write(await astNodesToString(bodyNodes, context));
        }
      } else if (iterableValue is Map) {
        for (final entry in iterableValue.entries) {
          context.variables[variableName] = entry.value;
          buffer.write(await astNodesToString(bodyNodes, context));
        }
      }

      if (previousExists) {
        context.variables[variableName] = previousValue;
      } else {
        context.variables.remove(variableName);
      }

      return buffer.toString();
    } catch (e) {
      context.errors.addAll(templateEngineExceptionsFromException(e));
      return context.errorPlaceholder;
    }
  }
}

/// A node that repeatedly renders its body while a condition is truthy.
class WhileNode extends AstNode {
  /// The expression evaluated before each iteration.
  final Expression condition;

  /// The nodes rendered while [condition] remains truthy.
  final List<AstNode> bodyNodes;

  /// Creates a condition-controlled loop.
  WhileNode(this.condition, this.bodyNodes);

  @override
  /// Renders the body until the condition is false.
  Future<String> render(RenderContext context) async {
    try {
      final buffer = StringBuffer();
      while (isTruthy(await condition.evaluate(context))) {
        buffer.write(await astNodesToString(bodyNodes, context));
      }
      return buffer.toString();
    } catch (e) {
      context.errors.addAll(templateEngineExceptionsFromException(e));
      return context.errorPlaceholder;
    }
  }
}

/// A node used when a code block could not be parsed.
class ErrorNode extends AstNode {
  /// The original code block contents.
  final String originalCode;

  /// Whether to include [originalCode] in rendered output.
  final bool renderOriginalCode;

  /// Creates an error node, optionally preserving the original code in output.
  ErrorNode(this.originalCode, {this.renderOriginalCode = false});

  @override
  /// Returns the original code when enabled, or an empty string.
  Future<String> render(RenderContext context) =>
      Future.value(renderOriginalCode ? originalCode : '');
}

/// The parsed representation of a template and its syntax tree.
class TemplateDocument {
  /// The template from which this document was parsed.
  final Template template;

  /// The ordered syntax-tree nodes in the template.
  final List<AstNode> nodes;

  /// Creates a document for [template] containing [nodes].
  TemplateDocument({required this.template, required this.nodes});
}
