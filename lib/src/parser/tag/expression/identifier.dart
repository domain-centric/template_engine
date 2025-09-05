import 'package:petitparser/petitparser.dart';

/// ** [IdentifierName]'s e.g. for variables, constants, functions, parameters and arguments: **
/// * are [case sensitive](https://en.wikipedia.org/wiki/Case_sensitivity)
/// * must start with a lower case letter, optionally followed by (lower or upper case) letters and or digits.
/// * conventions: use [lowerCamelCase](https://en.wikipedia.org/wiki/Camel_case)
/// * must be unique and does not match a other [Tag] syntax
class IdentifierName {
  static final Parser<String> parser =
      (lowercase() & (letter() | digit()).star()).flatten();

  static void validate(String name) {
    var result = parser.end(message: 'letter OR digit expected').parse(name);
    if (result is Failure) {
      throw IdentifierException(
        "Invalid identifier name: '$name', "
        "${result.message} at position ${result.position}",
      );
    }
  }
}

class IdentifierException implements Exception {
  final String message;
  IdentifierException(this.message);
}
