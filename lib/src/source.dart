import 'dart:convert';
import 'dart:io';

/// [source] is the location of a file.
/// [source] can be a [File.path], [ProjectFilePath] or [Uri]
Future<String> readSource(String source) async {
  var sourceUri = Uri.tryParse(source);
  if (sourceUri == null) {
    return await readFromFilePath(source);
  }
  return await readFromUri(sourceUri);
}

Future<String> readFromUri(Uri sourceUri) async {
  if (sourceUri.isScheme('HTTP') || sourceUri.isScheme("HTTPS")) {
    return await readFromHttpUri(sourceUri);
  }
  return await readFromFileUri(sourceUri);
}

/// Reads a file from a operation systems
/// [File Path](https://en.wikipedia.org/wiki/Path_(computing))/
Future<String> readFromFilePath(String source) async =>
    await File(source).readAsString();

Future<String> readFromHttpUri(Uri source) async {
  try {
    var request = await HttpClient().getUrl(source);
    var response = await request.close();
    if (response.statusCode != 200) {
      return await Future.error(
        Exception(
          'Error reading: $source, status code: ${response.statusCode}',
        ),
      );
    }
    return await response.transform(const Utf8Decoder()).join();
  } on Exception catch (e) {
    return Future.error(Exception('Error reading: $source, $e'));
  }
}

/// Reads from a
/// [File URI scheme](https://en.wikipedia.org/wiki/File_URI_scheme).
/// This includes a [ProjectFilePath].
Future<String> readFromFileUri(Uri source) async {
  try {
    var file = File.fromUri(source);
    return await file.readAsString();
  } on Exception catch (e) {
    return Future.error(Exception('Error reading: $source, $e'));
  }
}
