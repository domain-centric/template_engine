import 'package:template_engine/src/error.dart';
import 'package:template_engine/src/variable/variable.dart';

/// Renders some value depending on the implementation of the [Renderer]
/// 
/// Values can be:
/// * String
/// * int
/// * double
/// * bool
/// * DateTime
/// * Some other object
/// * Renderer<Generic type is on of the above>
/// * List<Generic type is on of the above>
/// 
// TODO consider rename the class name  that does not end with -er (see) debates on internet


abstract class Renderer<T> {
  T render(RenderContext context);
}

class ParentRenderer extends Renderer {
  List<Object> children;

  ParentRenderer([this.children = const []]);

  @override
  String render(RenderContext context) =>
      children.map((child) => renderChild(context, child)).join();

  String renderChild(RenderContext context, Object child) {
    if (child is Renderer) {
      return child.render(context);
    } else {
      return child.toString();
    }
  }
}

class RenderContext {
  final Variables variables;
  final List<Error> errors;

  RenderContext(
    Variables variables,
  )   : variables = variables.clone(),
        errors = [];
}

class RenderResult implements Exception {
  final List<Error> errors;
  final String text;

  RenderResult({
    required this.text,
    this.errors = const [],
  });

  String get errorMessage => errors.map((error) => error.toString()).join('\n');

  @override
  String toString() => text;
}
