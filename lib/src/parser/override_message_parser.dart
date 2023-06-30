import 'package:petitparser/petitparser.dart';

/// Overrides the error message when the [super.delegate] fails.
class OverrideMessageParser<R> extends Parser<R> {
  final Parser<R> delegate;

  /// Error message to indicate parse failures with.
  final String message;

  OverrideMessageParser(this.delegate, this.message);

  @override
  Result<R> parseOn(Context context) {
    // If we have a message we can switch to fast mode.
    var result = delegate.parseOn(context);
    if (result.isFailure) {
      return context.failure(message);
    } else {
      return result;
    }
  }

  @override
  int fastParseOn(String buffer, int position) =>
      delegate.fastParseOn(buffer, position);

  @override
  bool hasEqualProperties(FlattenParser<R> other) =>
      super.hasEqualProperties(other) && message == other.message;

  @override
  OverrideMessageParser<R> copy() =>
      OverrideMessageParser<R>(delegate, message);
}
