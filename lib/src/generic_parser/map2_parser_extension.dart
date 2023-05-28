import 'package:petitparser/petitparser.dart';

extension Map2ParserExtension<R> on Parser<R> {
  /// Inspired by [MapParserExtension]: with te addition that [Callback2]
  /// also provides the current parser position for error or warnings.
  ///
  /// Returns a parser that evaluates a [callback] as the production action
  /// on success of the receiver.
  ///
  /// For example, the parser `digit().map((char) => int.parse(char))` returns
  /// the number `1` for the input string `'1'`. If the delegate fails, the
  /// production action is not executed and the failure is passed on.
  Parser<S> map2<S>(
    Callback2<R, S> callback, {
    @Deprecated('All callbacks are considered to have side-effects')
        bool hasSideEffects = true,
  }) =>
      Map2Parser<R, S>(this, callback);
}

/// A parser that performs a transformation with a given function on the
/// successful parse result of the delegate.
class Map2Parser<R, S> extends DelegateParser<R, S> {
  Map2Parser(super.delegate, this.callback);

  /// The production action to be called.
  final Callback2<R, S> callback;

  @override
  Result<S> parseOn(Context context) {
    final result = delegate.parseOn(context);
    if (result.isSuccess) {
      var callbackResults = callback(result.value, context.toPositionString());
      return result.success(callbackResults);
    } else {
      return result.failure(result.message);
    }
  }

  @override
  bool hasEqualProperties(Map2Parser<R, S> other) =>
      super.hasEqualProperties(other) && callback == other.callback;

  @override
  Map2Parser<R, S> copy() => Map2Parser<R, S>(delegate, callback);
}

/// We pass the parse position so that errors and or warnings can be logged
/// with the current parse position within the [Template]
typedef Callback2<T, R> = R Function(T value, String parsePosition);
