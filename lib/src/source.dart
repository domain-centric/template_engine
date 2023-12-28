import 'dart:convert';
import 'dart:io';

/// [source] is the location of a file.
/// [source] can be a [File.path], [ProjectFilePath] or [Uri]
Future<String> readSource(String source) async {
  try {
    return await readFromFilePath(source);
  } on UnsupportedSourceException {
    try {
      return await readFromHttpUri(source);
    } on UnsupportedSourceException {
      try {
        return await readFromFileUri(source);
      } on Exception catch (e) {
        return Future.error(e);
      }
    }
  }
}

/// Reads a file from a operation systems
/// [File Path](https://en.wikipedia.org/wiki/Path_(computing))/
Future<String> readFromFilePath(String source) async {
  try {
    var file = File(source);
    return await file.readAsString();
  } on Exception {
    return Future.error(UnsupportedSourceException());
  }
}

Future<String> readFromHttpUri(String source) async {
  var url = Uri.parse(source);
  if (url.isScheme('HTTP') || url.isScheme("HTTPS")) {
    try {
      var request = await HttpClient().getUrl(url);
      var response = await request.close();
      if (response.statusCode != 200) {
        return Future.error(Exception(
            'Error reading: $source, status code: ${response.statusCode}'));
      }
      return response.transform(const Utf8Decoder()).join();
    } on Exception catch (e) {
      return Future.error(Exception('Error reading: $source, $e'));
    }
  }
  return Future.error(UnsupportedSourceException());
}

/// Reads from a
/// [File URI scheme](https://en.wikipedia.org/wiki/File_URI_scheme).
/// This includes a [ProjectFilePath].
Future<String> readFromFileUri(String source) async {
  try {
    var uri = Uri.parse(source);
    var file = File.fromUri(uri);
    return await file.readAsString();
  } on Exception catch (e) {
    return Future.error(Exception('Error reading: $source, $e'));
  }
}

class UnsupportedSourceException implements Exception {
  UnsupportedSourceException();
}
