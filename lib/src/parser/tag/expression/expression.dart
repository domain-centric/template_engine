import 'package:template_engine/template_engine.dart';

/// A subset of [Renderer] for expressions
/// It is a combination of one or more:
/// * [Value]s
/// * [Variable]s
/// * [ExpressionFunction]s
/// * [Operator]s
abstract class Expression<T extends Object> extends Renderer<T> {}

///TODO can we let renderer implement HasPosition? If so, we can eliminate [ExpressionWithSourcePosition]

abstract class ExpressionWithSourcePosition<T extends Object>
    extends Expression<T>
    implements HasPosition {
  @override
  final Position position;

  ExpressionWithSourcePosition({required this.position});
}

/// A [Value] [Expression] holds a value that does not change when
/// rendered (evaluated).
/// e.g. it can be like a [num], [bool], [String] etc...
class Value<T extends Object> extends Expression<T> {
  Value(T value) : _originalValue = value, value = Future.value(value);

  final Future<T> value;
  final T _originalValue;

  @override
  Future<T> render(RenderContext context) => value;

  @override
  String toString() => 'Value{$_originalValue}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Value<T> &&
          // ignore: runtimeType == other.runtimeType, because value is cast to an object with class Value<T extends Object>:
          _originalValue == other._originalValue;

  @override
  int get hashCode => _originalValue.hashCode;
}
