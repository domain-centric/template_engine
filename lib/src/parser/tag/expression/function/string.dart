import 'package:template_engine/template_engine.dart';

class StringFunctions extends FunctionGroup {
  StringFunctions()
      : super('String', [
          StringLength(),
        ]);
}

class StringLength extends ExpressionFunction<num> {
  StringLength()
      : super(
            name: 'length',
            description: 'Returns the length of a string',
            exampleExpression: '{{length("Hello")}}',
            exampleResult: "Hello".length.toString(),
            parameters: [
              Parameter<String>(name: 'string', presence: Presence.mandatory())
            ],
            function: (renderContext, parameters) {
              var value = parameters['string'];
              if (value is String) {
                return value.length;
              } else {
                throw ParameterException('String expected');
              }
            });
}
