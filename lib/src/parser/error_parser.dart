import 'package:petitparser/petitparser.dart';
import 'package:template_engine/template_engine.dart';

/// This [Parser] looks for any remaining tags that where not recognized
/// by the [Tag][Parser]s.
/// It will return this unknown tag as a [String] and add detailed error(s)
/// to the [ParserContext].
class InvalidTagParser extends Parser<Object> {
  final ParserContext parserContext;
  final Parser<String> tagStartParser;
  final Parser<String> anythingBeforeEndParser;
  final Parser<String> tagEndParser;
  InvalidTagParser(this.parserContext)
      : tagStartParser = string(parserContext.engine.tagStart),
        anythingBeforeEndParser = untilEndOfTagParser(
            parserContext.engine.tagStart, parserContext.engine.tagEnd),
        tagEndParser = string(parserContext.engine.tagEnd);

  @override
  Parser<Object> copy() => InvalidTagParser(parserContext);

  /// see dart doc if this class.
  @override
  Result<Object> parseOn(Context context) {
    var errors = <ParseError>[];
    var tagStartResult = tagStartParser.parseOn(context);
    if (tagStartResult is Failure) {
      return tagStartResult;
    }
    var expressionResult = expressionParser(parserContext, verboseErrors: true)
        .parseOn(tagStartResult);
    if (expressionResult.position > tagStartResult.position) {
      if (expressionResult is Failure) {
        errors.add(ParseError.fromFailure(expressionResult as Failure));
      }
    }

    var anythingBeforeEndResult =
        anythingBeforeEndParser.parseOn(expressionResult);
    if (errors.isEmpty &&
        anythingBeforeEndResult is Success &&
        anythingBeforeEndResult.value.isNotEmpty) {
      errors.add(ParseError(
        message: 'invalid tag syntax',
        position: expressionResult.toPositionString(),
      ));
    }

    var tagEndResult = tagEndParser.parseOn(anythingBeforeEndResult);
    if (tagEndResult is Failure) {
      return tagEndResult;
    }

    if (errors.isNotEmpty) {
      parserContext.errors.addAll(errors);
      String tag =
          context.buffer.substring(context.position, tagEndResult.position);
      return tagEndResult.success(tag);
    } else {
      return tagEndResult.failure('not an invalid tag');
    }
  }
}

/// Adds an error if a [Tag] end is found but not a  [Tag] start.
/// It replaces the [Tag] end to a [String] e.g. containing: }}
Parser<String> missingTagStartParser(ParserContext parserContext) =>
    string(parserContext.engine.tagEnd).valueContextMap((value, context) {
      parserContext.errors.add(ParseError(
          message: 'Found tag end: ${parserContext.engine.tagEnd}, '
              'but it was not preceded with a tag start: '
              '${parserContext.engine.tagStart}',
          position: context.toPositionString()));
      return value;
    });

// Adds an error if a [Tag] start is found but no [Tag] start because if
/// they are both present they would have been parsed already.
/// It replaces the [Tag] end to a [String] e.g. containing: {{
Parser<String> missingTagEndParser(ParserContext parserContext) =>
    (string(parserContext.engine.tagStart) &
            any().star() &
            string(parserContext.engine.tagEnd).not())
        .valueContextMap((values, context) {
      parserContext.errors.add(ParseError(
          message: 'Found tag start: ${parserContext.engine.tagStart}, '
              'but it was not followed with a tag end: '
              '${parserContext.engine.tagEnd}',
          position: context.toPositionString()));
      return values.first;
    });
