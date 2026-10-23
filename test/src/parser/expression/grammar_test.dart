import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('grammar ...', () async {
    var grammar = Grammar.standard();
    var operatorDoc = aggregatedOperatorDocumentation(grammar, 1);
    operatorDoc.should.startWith(
      'An expression can contain one or more operators',
    );
    operatorDoc.should.contain('# Unary operators');
    operatorDoc.should.contain('## + operator');
    operatorDoc.should.contain('# Custom operators');
  });
}
