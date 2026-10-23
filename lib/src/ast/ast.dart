import 'dart:async';

import 'package:template_engine/template_engine.dart';

abstract class AstNode {
  Future<String> render(RenderContext context);
}

class TextNode extends AstNode {
  final String text;
  final bool renderText;
  TextNode(this.text, {this.renderText = true});

  @override
  Future<String> render(RenderContext context) =>
      Future.value(renderText ? text : '');
}

class ExpressionBlockNode extends AstNode {
  final Expression expression;

  ExpressionBlockNode(this.expression);

  @override
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

class IfNode extends AstNode {
  final Expression condition;
  final List<AstNode> thenNodes;
  final List<AstNode> elseNodes;

  IfNode(this.condition, this.thenNodes, this.elseNodes);

  @override
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
  /// the name of the variable or the variable.path
  final String variableNamePath;
  final Expression expression;

  AssignmentNode(this.variableNamePath, this.expression);

  @override
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

class CommentNode extends AstNode {
  CommentNode();

  @override
  Future<String> render(RenderContext context) => Future.value('');
}

class ForNode extends AstNode {
  final String variableName;
  final Expression startExpression;
  final Expression endExpression;
  final List<AstNode> bodyNodes;

  ForNode(
    this.variableName,
    this.startExpression,
    this.endExpression,
    this.bodyNodes,
  );

  @override
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

class ForEachNode extends AstNode {
  final String variableName;
  final Expression iterableExpression;
  final List<AstNode> bodyNodes;

  ForEachNode(this.variableName, this.iterableExpression, this.bodyNodes);

  @override
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

class WhileNode extends AstNode {
  final Expression condition;
  final List<AstNode> bodyNodes;

  WhileNode(this.condition, this.bodyNodes);

  @override
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

class ErrorNode extends AstNode {
  final String originalCode;
  final bool renderOriginalCode;

  ErrorNode(this.originalCode, {this.renderOriginalCode = false});

  @override
  Future<String> render(RenderContext context) =>
      Future.value(renderOriginalCode ? originalCode : '');
}

class TemplateDocument {
  /// the source of this document
  final Template template;
  final List<AstNode> nodes;

  TemplateDocument({required this.template, required this.nodes});
}
