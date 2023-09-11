import 'package:template_engine/template_engine.dart';

class Prefixes extends OperatorGroup {
  Prefixes()
      : super('Prefixes',
            [PositiveOperator(), NegativeOperator(), NotOperator()]);
}

class PositiveOperator extends PrefixOperator<num> {
  PositiveOperator()
      : super(
          operator: '+',
          description: 'Optional prefix for positive numbers',
          expressionExample: '{{+3}}',
          expressionExampleResult: '3',
          codeExample: ProjectFilePath(
              'test/src/parser/tag/expression/operator/prefix/positive_test.dart'),
          function: (number) => number,
        );
}

class NegativeOperator extends PrefixOperator<num> {
  NegativeOperator()
      : super(
          operator: '-',
          description: 'Prefix for a negative number',
          expressionExample: '{{-3}}',
          expressionExampleResult: '-3',
          codeExample: ProjectFilePath(
              'test/src/parser/tag/expression/operator/prefix/negative_test.dart'),
          function: (number) => -number,
        );
}

class NotOperator extends PrefixOperator<bool> {
  NotOperator()
      : super(
          operator: '!',
          description: 'Prefix to invert a boolean, e.g.: !true =false',
          expressionExample: '{{!true}}',
          expressionExampleResult: 'false',
          codeExample: ProjectFilePath(
              'test/src/parser/tag/expression/operator/prefix/not_test.dart'),
          function: (boolean) => !boolean,
        );
}
