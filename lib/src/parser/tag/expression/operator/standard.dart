import 'package:collection/collection.dart';
import 'package:template_engine/template_engine.dart';

class StandardOperators extends DelegatingList<OperatorGroup> {
  StandardOperators()
      : super([
          Parentheses(),
          Prefixes(),
          Multiplication(),
          Additions(),
          Comparisons(),
          Assignments(),
        ]);
}
