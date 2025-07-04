import 'package:template_engine/template_engine.dart';

class StringFunctions extends FunctionGroup {
  StringFunctions() : super('String Functions', [StringLength()]);
}

class StringLength extends ExpressionFunction<num> {
  StringLength()
    : super(
        name: 'length',
        description: 'Returns the length of a string',
        exampleExpression: '{{length("Hello")}}',
        exampleResult: "Hello".length.toString(),
        exampleCode: ProjectFilePath(
          'test/src/parser/tag/expression/function/string/length_test.dart',
        ),
        parameters: [
          Parameter<String>(name: 'string', presence: Presence.mandatory()),
        ],
        function: (position, renderContext, parameters) {
          var value = parameters['string'];
          if (value is String) {
            return Future.value(value.length);
          } else {
            throw ParameterException('String expected');
          }
        },
      );
}
