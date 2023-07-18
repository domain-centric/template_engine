import 'package:collection/collection.dart';
import 'package:template_engine/template_engine.dart';

class DefaultFunctionGroups extends DelegatingList<FunctionGroup> {
  DefaultFunctionGroups() : super([MathFunctions(), StringFunctions()]);
}
