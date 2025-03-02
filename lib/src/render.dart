// ignore_for_file: public_member_api_docs, sort_constructors_first, unintended_html_in_doc_comment
import 'package:template_engine/template_engine.dart';

/// Renders some value depending on the implementation of the [Renderer]
///
/// For [T] see [RenderType]
///

abstract class Renderer<T> {
  Future<T> render(RenderContext context);
}

class RenderException extends RenderError implements Exception {
  RenderException({required super.message, required super.position});
}

/// Types returned by the [Renderer.render] method or
/// the Type of [ParserTree.children] are normally one of the following:
/// * String
/// * int
/// * double
/// * bool
/// * DateTime
/// * Some other object
/// * [Renderer]<Generic type is on of the above>
/// * List<Generic type is on of the above>
abstract class RenderType {
  /// Documentation only
}

/// The [ParserTree](https://en.wikipedia.org/wiki/Parse_tree) contains
/// parsed nodes from a [Template] that can be rendered to a [IntermediateRenderResult].
class ParserTree<T> extends Renderer<IntermediateRenderResult> {
  /// The [children] that where parsed and can be rendered to a [String].
  /// The [children] are of type [RenderType]
  final List<T> children;

  ParserTree([this.children = const []]);

  @override
  Future<IntermediateRenderResult> render(RenderContext context) async {
    var errors = <TemplateError>[];
    var textBuffer = StringBuffer();
    for (var child in children) {
      try {
        var result = await renderNode(context, child);
        textBuffer.write(resultToString(result));
        errors.addAll(resultErrors(result));
      } on TemplateError catch (e) {
        errors.add(e);
        textBuffer.write(context.renderedError);
      } catch (e) {
        var error =
            RenderError(message: e.toString(), position: position(child));
        errors.add(error);
        textBuffer.write(context.renderedError);
      }
    }
    return IntermediateRenderResult(
        text: textBuffer.toString(), errors: errors);
  }

  String position(child) =>
      child is ExpressionWithSourcePosition ? child.position : '?';

  /// returns either an:
  /// * [IntermediateRenderResult] containing a text and possible errors
  /// * an [Object] that can be converted to a [String]
  /// * a [List] of [Object]s that can be converted to a [String]
  Future<dynamic> renderNode(RenderContext context, T node) async {
    if (node is Renderer) {
      var result = await node.render(context);
      return result;
    } else if (node is List) {
      var values = [];
      for (var item in node) {
        var value = await renderNode(context, item);
        values.add(value);
      }
      return values;
    } else {
      return node.toString();
    }
  }

  String resultToString(result) {
    if (result is List) {
      return result.join();
    } else {
      return result.toString();
    }
  }

  Iterable<TemplateError> resultErrors(result) {
    if (result is IntermediateRenderResult) {
      return result.errors;
    }
    if (result is List) {
      var errors = <TemplateError>[];
      for (var node in result) {
        errors.addAll(resultErrors(node));
      }
      return errors;
    }
    return [];
  }
}

class RenderContext {
  final TemplateEngine engine;
  final VariableMap variables;
  final String renderedError;

  /// the Template being rendered
  final Template templateBeingRendered;

  final List<TemplateParseResult> parsedTemplates;
  RenderContext(
      {required this.engine,
      required this.parsedTemplates,
      required this.templateBeingRendered,

      /// How errors need to be rendered
      String? renderedError,
      VariableMap? variables})
      : variables = variables ?? {},
        renderedError =
            renderedError ?? '${engine.tagStart}ERROR${engine.tagEnd}';
}

abstract class RenderResult {
  final String text;

  RenderResult({
    required this.text,
  });

  String get errorMessage;

  @override
  String toString() => text;
}

class IntermediateRenderResult extends RenderResult {
  final List<TemplateError> errors;
  IntermediateRenderResult({required super.text, required this.errors});
  @override
  String get errorMessage => errors.join('\n');
}

/// contains the [RenderResult] of a [Template]
class TemplateRenderResult extends RenderResult {
  final Template template;
  final List<TemplateError> errors;

  TemplateRenderResult(
      {required this.template, required super.text, this.errors = const []});

  @override
  String get errorMessage {
    if (errors.isEmpty) {
      return "";
    }
    var parseErrors = errors.whereType<ParseError>();
    var renderErrors =
        errors.where((error) => error is RenderError || error is ImportError);
    if (parseErrors.isNotEmpty && renderErrors.isNotEmpty) {
      return 'Errors in: ${template.sourceTitle}:\n'
          '  Parse error${parseErrors.length > 1 ? "s" : ""}:\n'
          '${parseErrors.map((error) => error.toIndentedString(2)).join('\n')}\n'
          '  Render error${renderErrors.length > 1 ? "s" : ""}:\n'
          '${renderErrors.map((error) => error.toIndentedString(2)).join('\n')}';
    } else if (parseErrors.isNotEmpty) {
      return 'Parse error${parseErrors.length > 1 ? "s" : ""} '
          'in: ${template.sourceTitle}:\n'
          '${parseErrors.map((error) => error.toIndentedString(1)).join('\n')}';
    } else {
      return 'Render error${renderErrors.length > 1 ? "s" : ""} '
          'in: ${template.sourceTitle}:\n'
          '${renderErrors.map((error) => error.toIndentedString(1)).join('\n')}';
    }
  }
}

/// contains the [RenderResult] of one or more [Template]
class TemplatesRenderResult extends RenderResult {
  final List<TemplateRenderResult> renderResults;

  TemplatesRenderResult(this.renderResults)
      : super(
            text: renderResults
                .where((renderResult) =>
                    renderResult.template is! ImportedTemplate)
                .map((renderResult) => renderResult.text)
                .join());

  @override
  String get errorMessage => renderResults
      .where((renderResult) => renderResult.errorMessage.isNotEmpty)
      .map((renderResult) => renderResult.errorMessage)
      .join('\n');

  TemplatesRenderResult add(TemplateRenderResult renderResult) {
    var newRenderResults = [...renderResults, renderResult];
    return TemplatesRenderResult(newRenderResults);
  }
}
