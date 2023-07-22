import 'dart:math';

// Convenient function to get differences in strings e.g. in tests.
String stringDifference(String s1, String s2) {
  var sharedLength = min(s1.length, s2.length);
  for (int i = 0; i < sharedLength; i++) {
    var char1 = s1.codeUnitAt(i);
    var char2 = s2.codeUnitAt(i);
    if (char1 != char2) {
      return 'Difference at position ${i + 1}: $char1 versus $char2';
    }
  }
  if (s1.length > sharedLength) {
    return 'Difference at position ${s1.length}: ${s1.codeUnitAt(s1.length - 1)} versus none';
  }
  if (s2.length > sharedLength) {
    return 'Difference at position ${s2.length}: none versus ${s2.codeUnitAt(s2.length - 1)}';
  }
  return 'Equal';
}

String typeDescription<T>() {
  switch (T) {
    case num:
      return 'number';
    case bool:
      return 'boolean';

    default:
      return T.toString();
  }
}
