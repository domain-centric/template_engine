import 'package:template_engine/template_engine.dart';

/// A subset of [Renderer] for expressions
/// It is a combination of one or more:
/// * [Value]s
/// * [Variable]s
/// * [ExpressionFunction]s
/// * [Operator]s
abstract class Expression<T extends Object> extends Renderer<T> {}

abstract class ExpressionWithSourcePosition<T extends Object>
    extends Expression<T> {
  final String position;

  ExpressionWithSourcePosition({required this.position});
}

/// A [Value] [Expression] holds a value that does not change when
/// rendered (evaluated).
/// e.g. it can be like a [num], [bool], [String] etc...
class Value<T extends Object> extends Expression<T> {
  Value(T value) : value = Future.value(value);

  final Future<T> value;

  @override
  Future<T> render(RenderContext context) => value;

  @override
  String toString() => 'Value{$value}';
}
