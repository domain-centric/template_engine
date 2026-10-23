// void validateIdentifier(String name) {
//   if (name.isEmpty) {
//     throw InvalidIdentifierName('Identifier cannot be empty.');
//   }

//   // Case-insensitive regex
//   final identifierRegex = RegExp(r'^[a-z_][a-z0-9_]*$', caseSensitive: false);

//   if (!identifierRegex.hasMatch(name)) {
//     throw InvalidIdentifierName('Invalid identifier name: "$name".');
//   }
// }

// class InvalidIdentifierName extends ArgumentError {
//   InvalidIdentifierName(String super.message);
// }

void validateIdentifier({
  /// e.g. constant name, function name, or parameter name,etc
  required String nameType,
  required String nameToValidate,
}) {
  if (nameToValidate.isEmpty) {
    throw InvalidIdentifierName('$nameType cannot be empty');
  }

  // First character must be a letter or underscore
  final first = nameToValidate[0];
  if (!_isLetter(first) && first != '_') {
    throw InvalidIdentifierName(
      'invalid $nameType: "$nameToValidate", '
      'letter OR underscore expected at position 0',
    );
  }

  // Remaining characters must be letter, digit, or underscore
  for (int i = 1; i < nameToValidate.length; i++) {
    final char = nameToValidate[i];
    if (!_isLetter(char) && !_isDigit(char) && char != '_') {
      throw InvalidIdentifierName(
        'invalid $nameType: "$nameToValidate", '
        'letter OR digit expected at position $i',
      );
    }
  }
}

bool _isLetter(String c) => RegExp(r'[a-z]', caseSensitive: false).hasMatch(c);

bool _isDigit(String c) => RegExp(r'[0-9]').hasMatch(c);

class InvalidIdentifierName implements Exception {
  final String message;
  InvalidIdentifierName(this.message);
}
