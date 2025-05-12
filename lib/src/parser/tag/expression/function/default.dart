import 'package:collection/collection.dart';
import 'package:template_engine/src/parser/tag/expression/function/import.dart';
import 'package:template_engine/src/parser/tag/expression/function/path.dart';
import 'package:template_engine/template_engine.dart';

class DefaultFunctionGroups extends DelegatingList<FunctionGroup> {
  DefaultFunctionGroups()
      : super([
          MathFunctions(),
          StringFunctions(),
          DocumentationFunctions(),
          PathFunctions(),
          ImportFunctions()
        ]);
}
