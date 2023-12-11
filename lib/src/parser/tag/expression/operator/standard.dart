import 'package:collection/collection.dart';
import 'package:template_engine/src/parser/tag/expression/operator/addition.dart';
import 'package:template_engine/src/parser/tag/expression/operator/assignment.dart';
import 'package:template_engine/src/parser/tag/expression/operator/parentheses.dart';
import 'package:template_engine/src/parser/tag/expression/operator/prefixes.dart';
import 'package:template_engine/template_engine.dart';

class StandardOperators extends DelegatingList<OperatorGroup> {
  StandardOperators()
      : super([
          Parentheses(),
          Prefixes(),
          Multiplication(),
          Additions(),
          Assignments(),
        ]);
}
