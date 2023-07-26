import 'package:petitparser/petitparser.dart';
import 'package:shouldly/shouldly.dart';
import 'package:template_engine/template_engine.dart';
import 'package:test/test.dart';

void main() {
  test('{{1110}} should be rendered as 14 by a custom binary data type', () {
    var engine = TemplateEngine();
    engine.dataTypes.insert(0, Binary());
    var parseResult = engine.parse(const TextTemplate('{{1110}}'));
    var renderResult = engine.render(parseResult);
    renderResult.text.should.be('14');
  });
}

class Binary extends DataType {
  @override
  String get name => 'Binary';

  @override
  String get description => 'a integer in binary format';

  @override
  List<ProjectFilePath> get examples => [];

  @override
  Parser<Value<Object>> createParser() => (char('0') | char('1'))
      .plus()
      .flatten('binary integer expected')
      .trim()
      .map((binary) => Value<num>(int.parse(binary, radix: 2)));
}
