import 'dart:io';

/// [source] is the location of a file.
/// [source] can be a [File.path], [ProjectFilePath] or [Uri]
String readSource(String source) {
  var text = readFromFilePath(source) ??
      readFromHttpUri(source) ??
      readFromFileUri(source);
  if (text == null) {
    throw Exception('Source could not be read: $source');
  }
  return text;
}

/// Reads a file from a operation systems
/// [File Path](https://en.wikipedia.org/wiki/Path_(computing))/
String? readFromFilePath(String source) {
  try {
    var file = File(source);
    return file.readAsStringSync();
  } on Exception {
    return null;
  }
}

String? readFromHttpUri(String source) {
  try {
    var uri = Uri.parse(source);
    if (uri.isScheme('HTTP') || uri.isScheme("HTTPS")) {
      //TODO see https://pub.dev/packages/sync_http and
      // https://github.com/google/sync_http.dart/blob/master/test/http_basic_test.dart
      return "TODO";
    } else {
      return null;
    }
  } on Exception {
    return null;
  }
}

/// Reads from a
/// [File URI scheme](https://en.wikipedia.org/wiki/File_URI_scheme).
/// This includes a [ProjectFilePath].
String? readFromFileUri(String source) {
  try {
    var uri = Uri.parse(source);
    var file = File.fromUri(uri);
    return file.readAsStringSync();
  } on Exception {
    return null;
  }
}
