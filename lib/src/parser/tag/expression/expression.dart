import 'package:template_engine/template_engine.dart';

/// An abstract expression that can be evaluated.
/// It is a combination of one or more:
/// * [Value]s
/// * [Variable]s
/// * [TagFunction]s
/// * [Operator]s
abstract class Expression<T extends Object> {
  /// Evaluates the expression with the provided [variables].
  T eval(Map<String, Object> variables);
}

/// A [Value] expression that does not change when evaluated.
/// e.g. it can be like a [num], [bool], [String] etc...
class Value<T extends Object> extends Expression<T> {
  Value(this.value);

  final T value;

  @override
  T eval(Map<String, Object> variables) => value;

  @override
  String toString() => 'Value{$value}';
}
