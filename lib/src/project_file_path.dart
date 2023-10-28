import 'dart:io';

import 'package:petitparser/petitparser.dart';

class ProjectFilePath {
  final String relativePath;

  static Parser<String> _fileOrFolderName() => (ChoiceParser([
        letter(),
        digit(),
        char('('),
        char(')'),
        char('_'),
        char('-'),
        char('.'),
      ], failureJoiner: selectFarthestJoined))
          .plus()
          .flatten();

  static Parser<String> _slashAndFileOrFolderName() =>
      (char('/') & _fileOrFolderName()).map((values) => values[1]);

  static Parser<List<String>> _pathParser() =>
      (_fileOrFolderName() & (_slashAndFileOrFolderName().star()))
          .map<List<String>>((values) => [values[0], ...values[1]])
          .endWithBetterFailure();

  ProjectFilePath(this.relativePath) {
    validate(relativePath);
  }

  void validate(String path) {
    var result = _pathParser().parse(path);
    if (result is Failure) {
      throw Exception("Invalid project file path: '$path': ${result.message} "
          "at position: ${result.position + 1}");
    }
  }

  String get fileName {
    var value2 = _pathParser().parse(relativePath).value;
    return value2.last;
  }

  File get file {
    var projectPath = Directory.current.path;
    var filePath = [
      ...projectPath.split(Platform.pathSeparator),
      ...relativePath.split('/'),
    ].join(Platform.pathSeparator);
    return File(filePath);
  }

  Uri get githubUri =>
      Uri.parse('https://github.com/domain-centric/template_engine/blob/main/'
          '$relativePath');

  String get githubMarkdownLink => '<a href="$githubUri">$fileName</a>';

  @override
  String toString() => relativePath;
}

extension EndWithBetterFailureExtension<R> on Parser<R> {
  Parser<R> endWithBetterFailure() =>
      skip(after: EndOfInputWithBetterFailureParser(this));
}

/// A parser that succeeds at the end of input.
/// OR results with an failure with the message of the owning parser
/// Inspired by [EndOfInputParser]
class EndOfInputWithBetterFailureParser extends Parser<void> {
  final Parser parser;
  EndOfInputWithBetterFailureParser(this.parser);

  @override
  Result<void> parseOn(Context context) {
    if (context.position < context.buffer.length) {
      var contextUpToFault = parser.parseOn(context);
      var fault = parser.parseOn(contextUpToFault);
      return fault;
    }
    return context.success(null);
  }

  @override
  int fastParseOn(String buffer, int position) =>
      position < buffer.length ? -1 : position;

  @override
  String toString() => '${super.toString()}[$parser]';

  @override
  EndOfInputWithBetterFailureParser copy() =>
      EndOfInputWithBetterFailureParser(parser);

  @override
  bool hasEqualProperties(EndOfInputWithBetterFailureParser other) =>
      super.hasEqualProperties(other) && parser == other.parser;
}
