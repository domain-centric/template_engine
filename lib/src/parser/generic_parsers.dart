import 'package:petitparser/parser.dart';

Parser whiteSpaceParser() => whitespace().star().flatten();

Parser intParser() => digit().plus().flatten().map(int.parse);
